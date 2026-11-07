-- =====================================================================
-- Data Profiling - tabela products (base de dados MoreRhythm)
-- Consultas de verificação complementares à Data Profiling Task (SSIS)
-- =====================================================================
USE MoreRhythm;
GO

-- a) Visão geral da tabela
SELECT reference, designation, family, category, supplyer, classification,
       current_sell_price, last_cost_price, stock, minimum_stock, vat_rate,
       create_date, last_update_date
FROM products
ORDER BY reference;

-- b) Produtos sem atributos (ID 43): só têm a reference
SELECT reference, designation, family, category, supplyer, create_date
FROM products
WHERE designation IS NULL AND family IS NULL AND category IS NULL;

-- c) Os produtos vazios aparecem em vendas, compras ou movimentos de stock? (ID 43)
SELECT p.reference,
       (SELECT COUNT(*) FROM invoices_lines  il WHERE RTRIM(il.product) = RTRIM(p.reference)) AS linhas_fatura,
       (SELECT COUNT(*) FROM purchases_lines pl WHERE RTRIM(pl.product) = RTRIM(p.reference)) AS linhas_compra,
       (SELECT COUNT(*) FROM stocks_movements sm WHERE RTRIM(sm.product) = RTRIM(p.reference)) AS movimentos_stock
FROM products p
WHERE p.designation IS NULL AND p.family IS NULL AND p.category IS NULL;

-- d) Produtos válidos sem fornecedor, por família (ID 44)
SELECT p.family, p.reference, p.designation
FROM products p
WHERE p.supplyer IS NULL AND p.designation IS NOT NULL
ORDER BY p.family, p.reference;

-- e) Integridade referencial: fornecedor inexistente
SELECT p.reference, p.supplyer
FROM products p
LEFT JOIN suplliers s ON s.number = p.supplyer
WHERE p.supplyer IS NOT NULL AND s.number IS NULL;

-- f) Escala dos preços e das quantidades (ID 45)
SELECT MIN(current_sell_price) AS preco_min, MAX(current_sell_price) AS preco_max,
       MIN(stock) AS stock_min, MAX(stock) AS stock_max
FROM products;

-- g) Referências com espaços internos (ID 47)
SELECT reference
FROM products
WHERE CHARINDEX(' ', RTRIM(reference)) > 0;

-- h) Grafia inconsistente na designation (ID 48)
SELECT reference, designation
FROM products
WHERE designation LIKE '%Fusivel%' OR designation LIKE '%audio%'
   OR designation LIKE '%4 ias%' OR designation LIKE '% p/ %' OR designation LIKE '% c/ %';

-- i) Datas de auditoria incoerentes: última alteração anterior à criação (ID 49)
SELECT reference, create_date, create_time, last_update_date, last_update_time
FROM products
WHERE CAST(last_update_date AS datetime) + CAST(last_update_time AS datetime)
    < CAST(create_date AS datetime) + CAST(create_time AS datetime);

-- j) Cargas em lote: datas repetidas (Notas)
SELECT create_date, COUNT(*) AS n_produtos FROM products GROUP BY create_date ORDER BY n_produtos DESC;
SELECT last_update_date, COUNT(*) AS n_produtos FROM products GROUP BY last_update_date ORDER BY n_produtos DESC;

-- k) Margem negativa: custo superior ao preço de venda (Notas)
SELECT reference, designation, last_cost_price, current_sell_price
FROM products
WHERE last_cost_price > current_sell_price;

-- l) Stock abaixo do mínimo (Notas: informação de negócio)
SELECT reference, designation, stock, minimum_stock
FROM products
WHERE stock < minimum_stock;
