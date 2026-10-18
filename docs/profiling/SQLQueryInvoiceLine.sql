-- a) quantidade × preço = total da linha?
SELECT invoice_line_stamp_id, product, quantity, unit_price, line_total,
       quantity * unit_price AS calculado
FROM invoices_lines
WHERE ABS(quantity * unit_price - line_total) > 0.01;

-- b) o IVA da linha é 23% do total?
SELECT invoice_line_stamp_id, line_total, line_vat, line_total * 0.23 AS iva_calculado
FROM invoices_lines
WHERE ABS(line_total * 0.23 - line_vat) > 0.01;

-- c) linhas com produto inexistente ou fatura inexistente
SELECT l.* FROM invoices_lines l
LEFT JOIN products p ON p.reference = l.product
LEFT JOIN invoices i ON i.invoice_stamp_id = l.invoice_stamp_id
WHERE p.reference IS NULL OR i.invoice_stamp_id IS NULL;

-- d) o preço da linha comparado com o preço atual do produto
SELECT l.invoice_stamp_id, l.product, l.unit_price,
       p.current_sell_price / 1000000 AS preco_produto
FROM invoices_lines l JOIN products p ON p.reference = l.product
WHERE ABS(l.unit_price) <> p.current_sell_price / 1000000;