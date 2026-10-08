-- =====================================================================
-- Script 02: Intermediate Business Analysis & Aggregation Queries
-- Author: Amit Sharma (github.com/Catalyst097)
-- =====================================================================

USE analytics_portfolio_db;

-- ---------------------------------------------------------------------
-- Q1: Total Revenue and Order Count per Customer (Customer Lifetime Value - LTV)
-- Business Goal: Identify highest value customers for VIP rewards.
-- ---------------------------------------------------------------------
SELECT 
    c.customer_id,
    c.full_name,
    c.state,
    COUNT(DISTINCT o.order_id) AS total_orders,
    COALESCE(SUM(oi.quantity * oi.unit_price), 0.00) AS total_spend_inr
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id AND o.order_status = 'Delivered'
LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.full_name, c.state
ORDER BY total_spend_inr DESC;

-- ---------------------------------------------------------------------
-- Q2: Monthly Sales Performance & Revenue Trend
-- Business Goal: Track month-over-month sales progression.
-- ---------------------------------------------------------------------
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS sales_month,
    COUNT(DISTINCT o.order_id) AS completed_orders,
    SUM(oi.quantity) AS total_units_sold,
    SUM(oi.quantity * oi.unit_price) AS monthly_revenue_inr,
    ROUND(AVG(oi.quantity * oi.unit_price), 2) AS average_order_value_inr
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Delivered'
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY sales_month ASC;

-- ---------------------------------------------------------------------
-- Q3: Best-Selling Product Categories with Revenue Contribution
-- Business Goal: Analyze which product categories drive majority revenue.
-- ---------------------------------------------------------------------
SELECT 
    p.category,
    COUNT(DISTINCT p.product_id) AS distinct_products_offered,
    SUM(oi.quantity) AS units_sold,
    SUM(oi.quantity * oi.unit_price) AS category_revenue_inr
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.category
HAVING category_revenue_inr > 2000.00
ORDER BY category_revenue_inr DESC;

-- ---------------------------------------------------------------------
-- Q4: Customer Repeat Purchase Rate
-- Business Goal: Measure retention by filtering customers with > 1 completed order.
-- ---------------------------------------------------------------------
SELECT 
    c.state,
    COUNT(c.customer_id) AS customers_with_repeat_orders
FROM (
    SELECT customer_id
    FROM orders
    WHERE order_status = 'Delivered'
    GROUP BY customer_id
    HAVING COUNT(order_id) > 1
) repeat_buyers
JOIN customers c ON repeat_buyers.customer_id = c.customer_id
GROUP BY c.state
ORDER BY customers_with_repeat_orders DESC;
