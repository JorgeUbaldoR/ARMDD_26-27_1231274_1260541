-- =====================================================================
-- Data Profiling - tabela invoices (base de dados MoreRhythm)
-- Consultas de verificação complementares à Data Profiling Task (SSIS)
-- =====================================================================
USE MoreRhythm;
GO

-- a) products_total da fatura vs soma das linhas
SELECT i.invoice_stamp_id, i.products_total, SUM(l.line_total) AS soma_linhas
FROM invoices i
JOIN invoices_lines l ON l.invoice_stamp_id = i.invoice_stamp_id
GROUP BY i.invoice_stamp_id, i.products_total
HAVING ABS(i.products_total - SUM(l.line_total)) > 0.01;

-- b) vat_value da fatura vs soma do IVA das linhas
SELECT i.invoice_stamp_id, i.vat_value, SUM(l.line_vat) AS soma_iva_linhas
FROM invoices i
JOIN invoices_lines l ON l.invoice_stamp_id = i.invoice_stamp_id
GROUP BY i.invoice_stamp_id, i.vat_value
HAVING ABS(i.vat_value - SUM(l.line_vat)) > 0.01;

-- c) Regra dos portes: shipping_cost = 2,5% do products_total
SELECT invoice_stamp_id, products_total, shipping_cost,
       products_total * 0.025          AS portes_esperados,
       shipping_cost / products_total AS taxa_real
FROM invoices
WHERE ABS(shipping_cost - products_total * 0.025) > 0.001;

-- d) Coerência dos totais: total_for_vat = products_total + shipping_cost
SELECT invoice_stamp_id, products_total, shipping_cost, total_for_vat,
       products_total + shipping_cost AS esperado
FROM invoices
WHERE ABS(total_for_vat - (products_total + shipping_cost)) > 0.001;

-- e) Coerência dos totais: final_total = total_for_vat + vat_value
SELECT invoice_stamp_id, total_for_vat, vat_value, final_total
FROM invoices
WHERE ABS(final_total - (total_for_vat + vat_value)) > 0.001;

-- f) O IVA incide sobre os portes? (compara com 23% de products_total e de total_for_vat)
SELECT invoice_stamp_id, vat_value,
       products_total * 0.23 AS iva_so_produtos,
       total_for_vat  * 0.23 AS iva_com_portes
FROM invoices;

-- g) Data da fatura diferente da data de criação do registo
SELECT invoice_stamp_id, invoice_date, create_date, create_time
FROM invoices
WHERE invoice_date <> create_date;

-- h) Pagamento antes da fatura e prazo de pagamento
SELECT invoice_stamp_id, invoice_date, payment_date,
       DATEDIFF(DAY, invoice_date, payment_date) AS dias_pagamento
FROM invoices
ORDER BY dias_pagamento;

-- i) Cliente ou funcionário inexistente
SELECT i.invoice_stamp_id, i.customer, i.employee
FROM invoices i
LEFT JOIN customers c ON c.number = i.customer
LEFT JOIN employees e ON e.number = i.employee
WHERE c.number IS NULL OR e.number IS NULL;

-- j) Faturas sem linhas
SELECT i.invoice_stamp_id
FROM invoices i
LEFT JOIN invoices_lines l ON l.invoice_stamp_id = i.invoice_stamp_id
WHERE l.invoice_stamp_id IS NULL;

-- k) Moedas usadas (código fora do padrão ISO 4217)
SELECT currency, COUNT(*) AS n
FROM invoices
GROUP BY currency;

-- l) Distribuição das datas de faturação (dia da semana e semana do ano)
SELECT invoice_date, DATENAME(WEEKDAY, invoice_date) AS dia_semana,
       DATEPART(ISO_WEEK, invoice_date) AS semana_iso, COUNT(*) AS n
FROM invoices
GROUP BY invoice_date
ORDER BY invoice_date;

-- m) Identificadores com prefixo diferente de 'ADM'
SELECT invoice_stamp_id, invoice_date, customer
FROM invoices
WHERE invoice_stamp_id NOT LIKE 'ADM%';

-- n) Datas de auditoria: última alteração = data de pagamento; hora nunca atualizada
SELECT invoice_stamp_id, payment_date, create_date, create_time, last_update_date, last_update_time,
       CASE WHEN last_update_date = payment_date THEN 'sim' ELSE 'não' END AS lu_igual_pagamento,
       CASE WHEN last_update_time = create_time  THEN 'sim' ELSE 'não' END AS hora_nao_atualizada
FROM invoices;

-- o) Valores monetários com mais de 2 casas decimais
SELECT invoice_stamp_id, shipping_cost, total_for_vat, final_total
FROM invoices
WHERE final_total * 100 <> ROUND(final_total * 100, 0)
   OR shipping_cost * 100 <> ROUND(shipping_cost * 100, 0);

-- p) Faturas emitidas por funcionário e grupo
SELECT e.number, e.name, e.[group], COUNT(*) AS n_faturas
FROM invoices i
JOIN employees e ON e.number = i.employee
GROUP BY e.number, e.name, e.[group];
