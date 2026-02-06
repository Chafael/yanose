-- =============================================
-- CampusCafe Database Indexes
-- =============================================

-- Index for filtering and sorting orders by date
CREATE INDEX idx_orders_date 
    ON orders(created_at);

-- Index for filtering products by category
CREATE INDEX idx_products_category 
    ON products(category_id);

-- Index for filtering orders by customer
CREATE INDEX idx_orders_customer 
    ON orders(customer_id);

-- =============================================
-- Additional Performance Indexes
-- Extra: Agregué estos índices adicionales para mejorar el rendimiento
-- en filtros comunes que usamos en las vistas analíticas
-- =============================================

-- Index for order status filtering (common query pattern)
CREATE INDEX idx_orders_status 
    ON orders(status);

-- Index for active products filtering
CREATE INDEX idx_products_active 
    ON products(active) 
    WHERE active = TRUE;

-- Composite index for order items lookups
CREATE INDEX idx_order_items_order_product 
    ON order_items(order_id, product_id);
