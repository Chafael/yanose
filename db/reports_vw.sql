-- =============================================
-- CampusCafe Analytical Views
-- =============================================

-- =============================================
-- View: Daily Sales Report
-- =============================================
CREATE OR REPLACE VIEW vw_sales_daily AS
SELECT 
    DATE(o.created_at) AS sale_date,
    COUNT(DISTINCT o.id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(oi.qty * oi.unit_price) AS total_revenue,
    SUM(oi.qty) AS total_items_sold,
    o.channel
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
WHERE o.status = 'Finalizado'
GROUP BY DATE(o.created_at), o.channel
ORDER BY sale_date DESC;

-- =============================================
-- View: Top Selling Products
-- =============================================
CREATE OR REPLACE VIEW vw_top_products AS
SELECT 
    p.id AS product_id,
    p.name AS product_name,
    c.name AS category_name,
    p.price AS unit_price,
    SUM(oi.qty) AS total_sold,
    SUM(oi.qty * oi.unit_price) AS total_revenue,
    COUNT(DISTINCT oi.order_id) AS order_count
FROM products p
JOIN categories c ON p.category_id = c.id
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id AND o.status = 'Finalizado'
GROUP BY p.id, p.name, c.name, p.price
ORDER BY total_sold DESC NULLS LAST;

-- =============================================
-- View: Inventory Risk (Low Stock Alert)
-- =============================================
CREATE OR REPLACE VIEW vw_inventory_risk AS
SELECT 
    p.id AS product_id,
    p.name AS product_name,
    c.name AS category_name,
    p.stock AS current_stock,
    p.active,
    CASE 
        WHEN p.stock = 0 THEN 'Sin Stock'
        WHEN p.stock < 5 THEN 'Crítico'
        WHEN p.stock < 10 THEN 'Bajo'
        ELSE 'Normal'
    END AS stock_status,
    COALESCE(SUM(oi.qty), 0) AS total_sold_last_30_days
FROM products p
JOIN categories c ON p.category_id = c.id
LEFT JOIN order_items oi ON p.id = oi.product_id
LEFT JOIN orders o ON oi.order_id = o.id 
    AND o.status = 'Finalizado'
    AND o.created_at >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY p.id, p.name, c.name, p.stock, p.active
ORDER BY p.stock ASC, total_sold_last_30_days DESC;

-- =============================================
-- View: Customer Lifetime Value
-- =============================================
CREATE OR REPLACE VIEW vw_customer_value AS
SELECT 
    cu.id AS customer_id,
    cu.name AS customer_name,
    cu.email,
    COUNT(DISTINCT o.id) AS total_orders,
    COALESCE(SUM(oi.qty * oi.unit_price), 0) AS total_spent,
    COALESCE(AVG(oi.qty * oi.unit_price), 0) AS avg_order_value,
    MIN(o.created_at) AS first_order,
    MAX(o.created_at) AS last_order
FROM customers cu
LEFT JOIN orders o ON cu.id = o.customer_id AND o.status = 'Finalizado'
LEFT JOIN order_items oi ON o.id = oi.order_id
GROUP BY cu.id, cu.name, cu.email
ORDER BY total_spent DESC;

-- =============================================
-- View: Sales by Channel
-- Extra: Agregué esta vista para analizar el rendimiento por canal de venta
-- Útil para comparar Presencial vs App Móvil vs Web
-- =============================================
CREATE OR REPLACE VIEW vw_sales_channel AS
SELECT 
    o.channel,
    COUNT(DISTINCT o.id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS unique_customers,
    SUM(oi.qty * oi.unit_price) AS total_revenue,
    AVG(oi.qty * oi.unit_price) AS avg_order_value,
    SUM(oi.qty) AS total_items
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
WHERE o.status = 'Finalizado'
GROUP BY o.channel
ORDER BY total_revenue DESC;
