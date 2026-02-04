-- =============================================
-- CampusCafe Database Schema
-- =============================================

-- Drop existing tables in reverse dependency order
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;

-- =============================================
-- Categories Table
-- =============================================
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- =============================================
-- Products Table
-- =============================================
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category_id INTEGER NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    
    -- Foreign Key
    CONSTRAINT fk_products_category 
        FOREIGN KEY (category_id) 
        REFERENCES categories(id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_products_price_positive 
        CHECK (price > 0),
    CONSTRAINT chk_products_stock_non_negative 
        CHECK (stock >= 0)
);

-- =============================================
-- Customers Table
-- =============================================
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

-- =============================================
-- Orders Table
-- =============================================
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50) NOT NULL DEFAULT 'Pendiente',
    channel VARCHAR(50) NOT NULL DEFAULT 'Presencial',
    
    -- Foreign Key
    CONSTRAINT fk_orders_customer 
        FOREIGN KEY (customer_id) 
        REFERENCES customers(id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE
);

-- =============================================
-- Order Items Table
-- =============================================
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    qty INTEGER NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    
    -- Foreign Keys
    CONSTRAINT fk_order_items_order 
        FOREIGN KEY (order_id) 
        REFERENCES orders(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    CONSTRAINT fk_order_items_product 
        FOREIGN KEY (product_id) 
        REFERENCES products(id) 
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_order_items_qty_positive 
        CHECK (qty > 0)
);

-- =============================================
-- Payments Table
-- =============================================
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    method VARCHAR(50) NOT NULL,
    paid_amount DECIMAL(10, 2) NOT NULL,
    
    -- Foreign Key
    CONSTRAINT fk_payments_order 
        FOREIGN KEY (order_id) 
        REFERENCES orders(id) 
        ON DELETE CASCADE 
        ON UPDATE CASCADE,
    
    -- Check Constraints
    CONSTRAINT chk_payments_amount_positive 
        CHECK (paid_amount > 0)
);

-- =============================================
-- Comments
-- =============================================
COMMENT ON TABLE categories IS 'Product categories for the cafe';
COMMENT ON TABLE products IS 'Products available for sale';
COMMENT ON TABLE customers IS 'Customer information';
COMMENT ON TABLE orders IS 'Customer orders';
COMMENT ON TABLE order_items IS 'Individual items within an order';
COMMENT ON TABLE payments IS 'Payment records for orders';
