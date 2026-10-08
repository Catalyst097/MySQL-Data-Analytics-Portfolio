-- =====================================================================
-- Script 04: Data Cleaning, Validation & Anomaly Detection Queries
-- Author: Amit Sharma (github.com/Catalyst097)
-- =====================================================================

USE analytics_portfolio_db;

-- ---------------------------------------------------------------------
-- Q1: Audit Orphan Records (Integrity Check)
-- Business Goal: Identify any order items without a valid master order.
-- ---------------------------------------------------------------------
SELECT 
    oi.item_id,
    oi.order_id,
    oi.product_id
FROM order_items oi
LEFT JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- ---------------------------------------------------------------------
-- Q2: Identify Inconsistent Pricing / Negative Values
-- Business Goal: Financial audit check for negative quantities or prices.
-- ---------------------------------------------------------------------
SELECT 
    item_id,
    order_id,
    quantity,
    unit_price
FROM order_items
WHERE quantity <= 0 OR unit_price <= 0.00;

-- ---------------------------------------------------------------------
-- Q3: Duplicate Customer Account Detection (Fuzzy or Exact)
-- Business Goal: Detect potential duplicate signups by lower-case email.
-- ---------------------------------------------------------------------
SELECT 
    LOWER(TRIM(email)) AS normalized_email,
    COUNT(*) AS account_count
FROM customers
GROUP BY LOWER(TRIM(email))
HAVING account_count > 1;

-- ---------------------------------------------------------------------
-- Q4: Mandi Price Anomaly Check (Min Price > Max Price)
-- Business Goal: Quality check on data ingestion pipelines.
-- ---------------------------------------------------------------------
SELECT 
    record_id,
    commodity_name,
    mandi_location,
    record_date,
    min_price,
    max_price,
    modal_price
FROM daily_mandi_prices
WHERE min_price > max_price 
   OR modal_price < min_price 
   OR modal_price > max_price;
