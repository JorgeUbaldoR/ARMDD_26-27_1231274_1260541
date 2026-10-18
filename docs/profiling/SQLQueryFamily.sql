-- =====================================================================
-- Data Profiling - tabela families (base de dados MoreRhythm)
-- Consultas de verificação complementares à Data Profiling Task (SSIS)
-- =====================================================================
USE MoreRhythm;
GO

-- a) Visão geral da tabela
SELECT reference, name, classification, create_date, last_update_date
FROM families
ORDER BY reference;

-- b) Classification em falta (NULL, vazio ou só espaços)
SELECT reference, name, DATALENGTH(classification) AS bytes
FROM families
WHERE classification IS NULL OR LTRIM(RTRIM(classification)) = '';

-- c) Unicidade da reference e do name
SELECT COUNT(*) AS total,
       COUNT(DISTINCT reference) AS references_distintas,
       COUNT(DISTINCT name)      AS nomes_distintos
FROM families;

-- d) Famílias sem nenhum produto
SELECT f.reference, f.name
FROM families f
LEFT JOIN products p ON p.family = f.reference
WHERE p.reference IS NULL;

-- e) Famílias pedidas na análise 10: existem e têm produtos?
SELECT f.reference, f.name, COUNT(p.reference) AS n_produtos
FROM families f
LEFT JOIN products p ON p.family = f.reference
WHERE f.name IN ('Acessórios', 'Amplificadores', 'Teclados')
GROUP BY f.reference, f.name;

-- f) Classification da família vs classification dos produtos dessa família
SELECT f.reference, f.classification AS class_familia,
       p.classification AS class_produto, COUNT(*) AS n_produtos
FROM families f
JOIN products p ON p.family = f.reference
GROUP BY f.reference, f.classification, p.classification
ORDER BY f.reference;

-- g) Produtos cuja família não existe (ou está vazia)
SELECT p.reference, p.designation, p.family
FROM products p
LEFT JOIN families f ON f.reference = p.family
WHERE f.reference IS NULL;

-- h) Comprimento do name (nomes curtos vs descrições longas)
SELECT reference, name, LEN(name) AS comprimento
FROM families
ORDER BY LEN(name) DESC;

-- i) Datas de auditoria incoerentes (última alteração anterior à criação)
SELECT reference, create_date, create_time, last_update_date, last_update_time
FROM families
WHERE CAST(last_update_date AS datetime) + CAST(last_update_time AS datetime)
    < CAST(create_date AS datetime) + CAST(create_time AS datetime);
