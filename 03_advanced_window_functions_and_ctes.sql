-- =====================================================================
-- Script 03: Advanced SQL Analytics, Window Functions & CTEs
-- Author: Amit Sharma (github.com/Catalyst097)
-- =====================================================================

USE analytics_portfolio_db;

-- ---------------------------------------------------------------------
-- Q1: Top Revenue Product per Category using DENSE_RANK()
-- Demonstrates: Window Ranking, CTEs
-- ---------------------------------------------------------------------
WITH ProductSalesRanked AS (
    SELECT 
        p.category,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS product_revenue,
        DENSE_RANK() OVER (
            PARTITION BY p.category 
            ORDER BY SUM(oi.quantity * oi.unit_price) DESC
        ) AS sales_rank
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY p.category, p.product_name
)
SELECT 
    category,
    product_name,
    product_revenue,
    sales_rank
FROM ProductSalesRanked
WHERE sales_rank = 1;

-- ---------------------------------------------------------------------
-- Q2: Day-over-Day Commodity Price Change Percentage using LAG()
-- Demonstrates: Time-series analytics on Agri-Mandi data
-- ---------------------------------------------------------------------
WITH DailyMandiTrends AS (
    SELECT 
        commodity_name,
        mandi_location,
        record_date,
        modal_price,
        LAG(modal_price, 1) OVER (
            PARTITION BY commodity_name, mandi_location 
            ORDER BY record_date ASC
        ) AS prev_day_price,
        arrivals_tonnes
    FROM daily_mandi_prices
)
SELECT 
    commodity_name,
    mandi_location,
    record_date,
    modal_price AS current_modal_price,
    prev_day_price,
    ROUND(((modal_price - prev_day_price) / prev_day_price) * 100, 2) AS price_change_percentage,
    arrivals_tonnes
FROM DailyMandiTrends
WHERE prev_day_price IS NOT NULL
ORDER BY commodity_name, record_date ASC;

-- ---------------------------------------------------------------------
-- Q3: Running Cumulative Revenue Over Time using SUM() OVER()
-- Demonstrates: Running total / moving cumulative window calculation
-- ---------------------------------------------------------------------
WITH DailyOrderRevenue AS (
    SELECT 
        o.order_date,
        SUM(oi.quantity * oi.unit_price) AS daily_revenue
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.order_status = 'Delivered'
    GROUP BY o.order_date
)
SELECT 
    order_date,
    daily_revenue,
    SUM(daily_revenue) OVER (ORDER BY order_date ASC) AS cumulative_running_total_inr
FROM DailyOrderRevenue
ORDER BY order_date ASC;

-- ---------------------------------------------------------------------
-- Q4: Customer Order Recency & Order Sequence using ROW_NUMBER()
-- Demonstrates: Tracking customer journey and sequence of purchases
-- ---------------------------------------------------------------------
SELECT 
    c.full_name,
    o.order_id,
    o.order_date,
    o.payment_method,
    ROW_NUMBER() OVER (
        PARTITION BY c.customer_id 
        ORDER BY o.order_date ASC
    ) AS purchase_order_number
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'Delivered'
ORDER BY c.customer_id, purchase_order_number;
