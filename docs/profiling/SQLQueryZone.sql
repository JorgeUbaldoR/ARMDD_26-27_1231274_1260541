-- =====================================================================
-- Data Profiling - tabela zones (base de dados MoreRhythm)
-- Consultas de verificação complementares à Data Profiling Task (SSIS)
-- =====================================================================
USE MoreRhythm;
GO

-- a) Visão geral da tabela
SELECT * FROM zones ORDER BY code;

-- b) Unicidade e valores em falta
SELECT COUNT(*) AS total,
       COUNT(DISTINCT code) AS codigos_distintos,
       COUNT(DISTINCT zone) AS nomes_distintos,
       SUM(CASE WHEN zone IS NULL OR LTRIM(RTRIM(zone)) = '' THEN 1 ELSE 0 END) AS nomes_vazios
FROM zones;

-- c) Número de clientes e de fornecedores por zona (inclui zonas sem utilização)
SELECT z.code, z.zone,
       (SELECT COUNT(*) FROM customers c WHERE c.zone = z.code) AS n_clientes,
       (SELECT COUNT(*) FROM suplliers s WHERE s.zone = z.code) AS n_fornecedores
FROM zones z
ORDER BY z.code;

-- d) Clientes e fornecedores sem zona ou com zona inexistente
SELECT 'cliente' AS tipo, c.number, c.name, c.zone
FROM customers c LEFT JOIN zones z ON z.code = c.zone
WHERE z.code IS NULL
UNION ALL
SELECT 'fornecedor', s.number, s.name, s.zone
FROM suplliers s LEFT JOIN zones z ON z.code = s.zone
WHERE z.code IS NULL;

-- e) Coerência da zona com a localização dos clientes (cidade extraída do código postal)
SELECT z.zone, LEFT(c.zip_code, 4) AS cp4, LTRIM(SUBSTRING(c.zip_code, 9, 100)) AS cidade,
       c.number, c.name
FROM customers c
JOIN zones z ON z.code = c.zone
ORDER BY cidade, z.zone;

-- f) Cidades de clientes que aparecem em mais do que uma zona
SELECT LTRIM(SUBSTRING(zip_code, 9, 100)) AS cidade, COUNT(DISTINCT zone) AS n_zonas
FROM customers
WHERE zip_code LIKE '[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9] %'
GROUP BY LTRIM(SUBSTRING(zip_code, 9, 100))
HAVING COUNT(DISTINCT zone) > 1;

-- g) Coerência da zona com a localização dos fornecedores
SELECT z.zone, s.number, s.name, s.zip_code, s.nationality
FROM suplliers s
LEFT JOIN zones z ON z.code = s.zone
ORDER BY z.zone;
