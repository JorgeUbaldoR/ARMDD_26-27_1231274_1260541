-- =====================================================================
-- Data Profiling - tabela employees (base de dados MoreRhythm)
-- Consultas de verificação complementares à Data Profiling Task (SSIS)
-- =====================================================================
USE MoreRhythm;
GO

-- a) Visão geral da tabela (group é palavra reservada: usar parênteses retos)
SELECT number, code, name, [group], departament, email, chief, create_date, last_update_date
FROM employees
ORDER BY number;

-- b) Emails com mais de um "@" (ID 68)
SELECT number, code, email
FROM employees
WHERE LEN(email) - LEN(REPLACE(email, '@', '')) > 1;

-- c) Funcionários sem chefe (ID 69)
SELECT number, code, name, [group]
FROM employees
WHERE chief IS NULL;

-- d) Integridade referencial da hierarquia: chefe inexistente
SELECT e.number, e.name, e.chief
FROM employees e
LEFT JOIN employees c ON c.number = e.chief
WHERE e.chief IS NOT NULL AND c.number IS NULL;

-- e) Capitalização do code (ID 70): comparação sensível a maiúsculas
SELECT number, code
FROM employees
WHERE code COLLATE Latin1_General_CS_AS
      <> UPPER(LEFT(code, 1)) + LOWER(SUBSTRING(code, 2, LEN(code))) COLLATE Latin1_General_CS_AS;

-- f) Comprimento do name face ao máximo da coluna (ID 71)
SELECT number, name, LEN(name) AS comprimento
FROM employees
ORDER BY LEN(name) DESC;

-- g) Datas de auditoria iguais em todos os registos (Notas)
SELECT create_date, last_update_date, COUNT(*) AS n
FROM employees
GROUP BY create_date, last_update_date;

-- h) Funcionários que emitiram faturas, por grupo (Notas, invoices)
SELECT e.number, e.name, e.[group], COUNT(i.invoice_stamp_id) AS n_faturas
FROM employees e
LEFT JOIN invoices i ON i.employee = e.number
GROUP BY e.number, e.name, e.[group]
ORDER BY e.number;
