-- =====================================================================
-- Data Profiling - tabela customers (base de dados MoreRhythm)
-- Consultas de verificação complementares à Data Profiling Task (SSIS)
-- =====================================================================
USE MoreRhythm;
GO

-- a) Unicidade da chave primária (o Candidate Key Profile não suporta numeric)
SELECT COUNT(*) AS total, COUNT(DISTINCT number) AS distintos
FROM customers;

-- b) Valores em falta "disfarçados": NULL, string vazia ou só espaços, por coluna
SELECT
    SUM(CASE WHEN zone IS NULL THEN 1 ELSE 0 END)                                      AS zone_null,
    SUM(CASE WHEN address IS NULL OR LTRIM(RTRIM(address)) = '' THEN 1 ELSE 0 END)     AS address_vazio,
    SUM(CASE WHEN clity IS NULL OR LTRIM(RTRIM(clity)) = '' THEN 1 ELSE 0 END)         AS clity_vazio,
    SUM(CASE WHEN zip_code IS NULL OR LTRIM(RTRIM(zip_code)) = '' THEN 1 ELSE 0 END)   AS zip_code_vazio,
    SUM(CASE WHEN phone IS NULL OR LTRIM(RTRIM(phone)) = '' THEN 1 ELSE 0 END)         AS phone_vazio,
    SUM(CASE WHEN mobile IS NULL OR LTRIM(RTRIM(mobile)) = '' THEN 1 ELSE 0 END)       AS mobile_vazio,
    SUM(CASE WHEN contact IS NULL OR LTRIM(RTRIM(contact)) = '' THEN 1 ELSE 0 END)     AS contact_vazio,
    SUM(CASE WHEN email IS NULL OR LTRIM(RTRIM(email)) = '' THEN 1 ELSE 0 END)         AS email_vazio,
    SUM(CASE WHEN BBAN IS NULL OR LTRIM(RTRIM(BBAN)) = '' THEN 1 ELSE 0 END)           AS bban_vazio
FROM customers;

-- c) BBAN vazio: distinguir string vazia (0 bytes) de espaço (1 byte)
SELECT number, name, DATALENGTH(BBAN) AS bytes
FROM customers
WHERE BBAN IS NULL OR LTRIM(RTRIM(BBAN)) = '';

-- d) Zona em falta ou inexistente na tabela zones
SELECT c.number, c.name, c.zone
FROM customers c
LEFT JOIN zones z ON z.code = c.zone
WHERE c.zone IS NULL OR z.code IS NULL;

-- e) NIF fora do domínio (não tem 9 dígitos, só zeros ou vazio)
SELECT number, name, taxpayer_number, type
FROM customers
WHERE LEN(LTRIM(RTRIM(taxpayer_number))) <> 9
   OR taxpayer_number LIKE '0000%'
   OR LTRIM(RTRIM(taxpayer_number)) = '';

-- f) NIF repetido (indício de cliente duplicado)
SELECT taxpayer_number, COUNT(*) AS n
FROM customers
GROUP BY taxpayer_number
HAVING COUNT(*) > 1;

-- g) BBAN repetido (indício de cliente duplicado)
SELECT number, name, taxpayer_number, address, zip_code, BBAN, create_date
FROM customers
WHERE BBAN IN (SELECT BBAN FROM customers
               WHERE BBAN IS NOT NULL AND LTRIM(RTRIM(BBAN)) <> ''
               GROUP BY BBAN HAVING COUNT(*) > 1)
ORDER BY BBAN, number;

-- h) Mesmo código postal ou mesmo telefone em clientes diferentes (candidatos a duplicado aproximado)
SELECT c1.number AS cliente_1, c1.name AS nome_1, c2.number AS cliente_2, c2.name AS nome_2,
       c1.taxpayer_number AS nif_1, c2.taxpayer_number AS nif_2, c1.zip_code, c1.phone
FROM customers c1
JOIN customers c2 ON c1.number < c2.number
WHERE (LTRIM(RTRIM(c1.zip_code)) <> '' AND c1.zip_code = c2.zip_code)
   OR (LTRIM(RTRIM(c1.phone))    <> '' AND c1.phone    = c2.phone);

-- i) Lista ordenada por nome para inspeção visual de duplicados aproximados
SELECT number, name, taxpayer_number, address, clity, zip_code, phone, email, create_date
FROM customers
ORDER BY name;

-- j) Email com formato inválido
SELECT number, name, email
FROM customers
WHERE LTRIM(RTRIM(email)) <> ''
  AND email NOT LIKE '%_@_%._%';

-- k) Códigos postais fora do formato português NNNN-NNN CIDADE
SELECT number, name, zip_code, zone
FROM customers
WHERE LTRIM(RTRIM(zip_code)) <> ''
  AND zip_code NOT LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9] %';

-- l) Cidade embutida no zip_code vs localidade da coluna clity
SELECT number, clity,
       zip_code,
       LTRIM(SUBSTRING(zip_code, 9, 100)) AS cidade_extraida
FROM customers
WHERE zip_code LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9] %';

-- m) Telefones com formato diferente (espaços ou indicativo internacional)
SELECT number, name, phone, mobile
FROM customers
WHERE phone LIKE '% %[0-9]%' OR phone LIKE '+%' OR mobile LIKE '% %[0-9]%';

-- n) seller sem correspondência em employees (não existe FK declarada)
SELECT c.number, c.name, c.seller, e.name AS funcionario, e.[group]
FROM customers c
LEFT JOIN employees e ON e.number = c.seller
ORDER BY c.seller;

-- o) Distribuição do tipo de cliente
SELECT type, COUNT(*) AS n
FROM customers
GROUP BY type;

-- p) Datas de auditoria incoerentes (última alteração anterior à criação)
SELECT number, name, create_date, create_time, last_update_date, last_update_time
FROM customers
WHERE CAST(last_update_date AS datetime) + CAST(last_update_time AS datetime)
    < CAST(create_date AS datetime) + CAST(create_time AS datetime);

-- q) Faturas associadas a clientes duplicados (para remapear na carga dos factos)
SELECT i.invoice_stamp_id, i.invoice_date, i.customer, c.name
FROM invoices i
JOIN customers c ON c.number = i.customer
WHERE i.customer IN (18, 22, 26);
