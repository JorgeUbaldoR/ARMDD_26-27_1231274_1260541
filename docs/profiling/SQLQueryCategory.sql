-- =====================================================================
-- Data Profiling - tabela categories (base de dados MoreRhythm)
-- Consultas de verificação complementares à Data Profiling Task (SSIS)
-- Nota: [Code] é o nome da coluna do código mostrado pelo Data Profile Viewer.
-- =====================================================================
USE MoreRhythm;
GO

-- a) Visão geral da tabela
SELECT * FROM categories ORDER BY [Code];

-- b) Unicidade, valores em falta e intervalo dos códigos
SELECT COUNT(*) AS total,
       COUNT(DISTINCT [Code])   AS codigos_distintos,
       COUNT(DISTINCT Category) AS nomes_distintos,
       SUM(CASE WHEN Category IS NULL OR LTRIM(RTRIM(Category)) = '' THEN 1 ELSE 0 END) AS nomes_vazios,
       MIN([Code]) AS codigo_min, MAX([Code]) AS codigo_max
FROM categories;

-- c) Categorias sem nenhum produto
SELECT c.*
FROM categories c
LEFT JOIN products p ON p.category = c.[Code]
WHERE p.reference IS NULL;

-- d) Produtos com categoria inexistente (ou vazia)
SELECT p.reference, p.designation, p.category
FROM products p
LEFT JOIN categories c ON c.[Code] = p.category
WHERE c.[Code] IS NULL;

-- e) Categorias da análise 9: existem e têm vendas?
SELECT c.Category, COUNT(l.invoice_line_stamp_id) AS n_linhas_vendidas
FROM categories c
LEFT JOIN products p ON p.category = c.[Code]
LEFT JOIN invoices_lines l ON LTRIM(RTRIM(l.product)) = LTRIM(RTRIM(p.reference))
WHERE c.Category IN ('Ar', 'Cordas', 'Membranas')
GROUP BY c.Category;

-- f) Relação entre família e categoria (é hierárquica?)
SELECT p.family, c.Category, COUNT(*) AS n_produtos
FROM products p
JOIN categories c ON c.[Code] = p.category
GROUP BY p.family, c.Category
ORDER BY p.family;

-- g) Número de categorias por família e de famílias por categoria
SELECT p.family, COUNT(DISTINCT p.category) AS n_categorias
FROM products p WHERE p.category IS NOT NULL
GROUP BY p.family;

SELECT c.Category, COUNT(DISTINCT p.family) AS n_familias
FROM products p JOIN categories c ON c.[Code] = p.category
GROUP BY c.Category;

-- h) Nomes repetidos entre categoria, família e classification
SELECT c.Category AS valor, 'categoria = família/classificação' AS ocorrencia
FROM categories c
WHERE c.Category IN (SELECT reference FROM families
                     UNION SELECT name FROM families
                     UNION SELECT classification FROM families
                     UNION SELECT classification FROM products);
