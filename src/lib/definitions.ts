/**
 * CampusCafe TypeScript Type Definitions
 * Interfaces for database views and data transfer objects
 */

// =============================================
// View Interfaces
// =============================================

/**
 * Daily Sales Report (vw_sales_daily)
 */
export interface SalesDaily {
    sale_date: Date;
    total_orders: number;
    unique_customers: number;
    total_revenue: number;
    total_items_sold: number;
    channel: string;
}

/**
 * Top Selling Products (vw_top_products)
 */
export interface TopProduct {
    product_id: number;
    product_name: string;
    category_name: string;
    unit_price: number;
    total_sold: number;
    total_revenue: number;
    order_count: number;
}

/**
 * Inventory Risk Alert (vw_inventory_risk)
 */
export interface InventoryRisk {
    product_id: number;
    product_name: string;
    category_name: string;
    current_stock: number;
    active: boolean;
    stock_status: 'Sin Stock' | 'Crítico' | 'Bajo' | 'Normal';
    total_sold_last_30_days: number;
}

/**
 * Customer Lifetime Value (vw_customer_value)
 */
export interface CustomerValue {
    customer_id: number;
    customer_name: string;
    email: string;
    total_orders: number;
    total_spent: number;
    avg_order_value: number;
    first_order: Date | null;
    last_order: Date | null;
}

/**
 * Sales by Channel (vw_sales_channel)
 */
export interface SalesChannel {
    channel: string;
    total_orders: number;
    unique_customers: number;
    total_revenue: number;
    avg_order_value: number;
    total_items: number;
}

// =============================================
// Pagination Types
// Extra: Agregué estos tipos porque los necesitaba para tipar las respuestas paginadas en data.ts
// =============================================

export interface PaginatedResult<T> {
    data: T[];
    total: number;
    page: number;
    limit: number;
    totalPages: number;
}

// =============================================
// Filter Types
// =============================================

export interface DateRangeFilter {
    from: Date;
    to: Date;
}

export interface PaginationParams {
    page: number;
    limit: number;
}
