-- =====================================================================
-- Data Profiling - tabela suplliers (base de dados MoreRhythm)
-- Consultas de verificação complementares à Data Profiling Task (SSIS)
-- =====================================================================
USE MoreRhythm;
GO

-- a) Visão geral da tabela
SELECT number, name, taxpayer_number, zone, zip_code, city, address, phone,
       contact, contact_position, email, nationality, type, create_date, last_update_date
FROM suplliers
ORDER BY number;

-- b) Zona em falta e zona vs localização (IDs 50 e 51)
SELECT s.number, s.name, s.zip_code, s.zone, z.zone AS nome_zona
FROM suplliers s
LEFT JOIN zones z ON z.code = s.zone
ORDER BY s.zone, s.number;

-- c) Fornecedores sem morada, código postal, telefone e tipo (ID 52)
SELECT number, name
FROM suplliers
WHERE LTRIM(RTRIM(ISNULL(address, ''))) = '' AND LTRIM(RTRIM(ISNULL(zip_code, ''))) = ''
  AND LTRIM(RTRIM(ISNULL(phone, '')))   = '' AND LTRIM(RTRIM(ISNULL(type, '')))     = '';

-- d) Localidade em falta (ID 53)
SELECT number, name, zip_code, city
FROM suplliers
WHERE LTRIM(RTRIM(ISNULL(city, ''))) = '';

-- e) NIF vazio ou de enchimento (ID 54)
SELECT number, name, taxpayer_number
FROM suplliers
WHERE LTRIM(RTRIM(ISNULL(taxpayer_number, ''))) = ''
   OR taxpayer_number = REPLICATE(LEFT(taxpayer_number, 1), 9);

-- f) NIF repetido e produtos associados (IDs 55 e 62)
SELECT s.number, s.name, s.taxpayer_number, s.phone,
       (SELECT COUNT(*) FROM products p WHERE p.supplyer = s.number) AS n_produtos
FROM suplliers s
WHERE s.taxpayer_number IN (SELECT taxpayer_number FROM suplliers
                            WHERE LTRIM(RTRIM(ISNULL(taxpayer_number, ''))) <> ''
                            GROUP BY taxpayer_number HAVING COUNT(*) > 1);

-- g) Contacto, cargo e email em falta: são os mesmos registos? (ID 56)
SELECT number, name,
       CASE WHEN LTRIM(RTRIM(ISNULL(contact, '')))          = '' THEN 'X' ELSE '' END AS sem_contact,
       CASE WHEN LTRIM(RTRIM(ISNULL(contact_position, ''))) = '' THEN 'X' ELSE '' END AS sem_cargo,
       CASE WHEN LTRIM(RTRIM(ISNULL(email, '')))            = '' THEN 'X' ELSE '' END AS sem_email
FROM suplliers
ORDER BY number;

-- h) Distribuição de nationality e contact_position (IDs 57 e 63)
SELECT nationality, COUNT(*) AS n FROM suplliers GROUP BY nationality;
SELECT contact_position, COUNT(*) AS n FROM suplliers GROUP BY contact_position;

-- i) Códigos postais fora do padrão português (ID 60)
SELECT number, name, zip_code, phone, address
FROM suplliers
WHERE LTRIM(RTRIM(ISNULL(zip_code, ''))) <> ''
  AND zip_code NOT LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9] %';

-- j) Datas de auditoria incoerentes: última alteração anterior à criação (ID 66)
SELECT number, name, create_date, create_time, last_update_date, last_update_time
FROM suplliers
WHERE CAST(last_update_date AS datetime) + CAST(last_update_time AS datetime)
    < CAST(create_date AS datetime) + CAST(create_time AS datetime);

-- k) Horas a 00:00:00 (ID 67)
SELECT number, name, create_date, create_time, last_update_date, last_update_time
FROM suplliers
WHERE create_time = '00:00:00' OR last_update_time = '00:00:00';

-- l) Validação do NIF pelo dígito de controlo (módulo 11) (Notas)
SELECT number, name, taxpayer_number,
       CASE WHEN LEN(t) = 9 AND t NOT LIKE '%[^0-9]%' THEN
            CASE WHEN CAST(RIGHT(t, 1) AS int) =
                      CASE WHEN 11 - (9*CAST(SUBSTRING(t,1,1) AS int) + 8*CAST(SUBSTRING(t,2,1) AS int)
                                    + 7*CAST(SUBSTRING(t,3,1) AS int) + 6*CAST(SUBSTRING(t,4,1) AS int)
                                    + 5*CAST(SUBSTRING(t,5,1) AS int) + 4*CAST(SUBSTRING(t,6,1) AS int)
                                    + 3*CAST(SUBSTRING(t,7,1) AS int) + 2*CAST(SUBSTRING(t,8,1) AS int)) % 11 >= 10
                           THEN 0
                           ELSE 11 - (9*CAST(SUBSTRING(t,1,1) AS int) + 8*CAST(SUBSTRING(t,2,1) AS int)
                                    + 7*CAST(SUBSTRING(t,3,1) AS int) + 6*CAST(SUBSTRING(t,4,1) AS int)
                                    + 5*CAST(SUBSTRING(t,5,1) AS int) + 4*CAST(SUBSTRING(t,6,1) AS int)
                                    + 3*CAST(SUBSTRING(t,7,1) AS int) + 2*CAST(SUBSTRING(t,8,1) AS int)) % 11
                      END
                 THEN 'Válido' ELSE 'Inválido' END
            ELSE 'Formato inválido' END AS modulo11
FROM (SELECT number, name, taxpayer_number, LTRIM(RTRIM(ISNULL(taxpayer_number, ''))) AS t
      FROM suplliers) x
ORDER BY number;
