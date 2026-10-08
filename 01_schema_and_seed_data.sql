-- =====================================================================
-- Script 01: Database Schema Creation & Seed Data Insertion
-- Author: Amit Sharma (github.com/Catalyst097)
-- =====================================================================

DROP DATABASE IF EXISTS analytics_portfolio_db;
CREATE DATABASE analytics_portfolio_db;
USE analytics_portfolio_db;

-- ---------------------------------------------------------------------
-- 1. Customers Table
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    state VARCHAR(50) NOT NULL,
    signup_date DATE NOT NULL
);

-- ---------------------------------------------------------------------
-- 2. Products Table
-- ---------------------------------------------------------------------
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(120) NOT NULL,
    category VARCHAR(60) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0
);

-- ---------------------------------------------------------------------
-- 3. Orders Table
-- ---------------------------------------------------------------------
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_status ENUM('Delivered', 'Cancelled', 'Returned', 'Processing') NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- 4. Order Items Table
-- ---------------------------------------------------------------------
CREATE TABLE order_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- 5. Daily Mandi Prices (Agricultural Commodities Domain)
-- ---------------------------------------------------------------------
CREATE TABLE daily_mandi_prices (
    record_id INT AUTO_INCREMENT PRIMARY KEY,
    commodity_name VARCHAR(80) NOT NULL,
    mandi_location VARCHAR(80) NOT NULL,
    state VARCHAR(50) NOT NULL,
    record_date DATE NOT NULL,
    min_price DECIMAL(10, 2) NOT NULL,
    max_price DECIMAL(10, 2) NOT NULL,
    modal_price DECIMAL(10, 2) NOT NULL,
    arrivals_tonnes DECIMAL(8, 2) NOT NULL
);

-- =====================================================================
-- POPULATE SAMPLE DATA
-- =====================================================================

INSERT INTO customers (customer_id, full_name, email, state, signup_date) VALUES
(1, 'Rahul Verma', 'rahul.v@gmail.com', 'Maharashtra', '2023-01-15'),
(2, 'Priya Nair', 'priya.n@gmail.com', 'Karnataka', '2023-02-10'),
(3, 'Amit Patel', 'amit.p@gmail.com', 'Gujarat', '2023-02-28'),
(4, 'Sneha Kulkarni', 'sneha.k@gmail.com', 'Maharashtra', '2023-03-05'),
(5, 'Vikram Singh', 'vikram.s@gmail.com', 'Punjab', '2023-04-12'),
(6, 'Ananya Sharma', 'ananya.s@gmail.com', 'Delhi', '2023-05-20'),
(7, 'Rohan Gupta', 'rohan.g@gmail.com', 'Maharashtra', '2023-06-01'),
(8, 'Deepak Rao', 'deepak.r@gmail.com', 'Karnataka', '2023-06-15');

INSERT INTO products (product_id, product_name, category, unit_price, stock_quantity) VALUES
(1, 'Wireless Optical Mouse', 'Electronics', 599.00, 150),
(2, 'Mechanical Gaming Keyboard', 'Electronics', 2499.00, 75),
(3, 'Type-C Fast Charging Cable', 'Electronics', 299.00, 300),
(4, 'Stainless Steel Water Bottle (1L)', 'Home & Kitchen', 450.00, 200),
(5, 'Electric Kettle 1.5L', 'Home & Kitchen', 1199.00, 90),
(6, 'Ceramic Coffee Mug Set (4pcs)', 'Home & Kitchen', 650.00, 120),
(7, 'Ergonomic Desk Chair Cushion', 'Furniture & Decor', 899.00, 60),
(8, 'Adjustable Laptop Stand', 'Furniture & Decor', 1299.00, 110);

INSERT INTO orders (order_id, customer_id, order_date, order_status, payment_method) VALUES
(101, 1, '2023-03-01', 'Delivered', 'UPI'),
(102, 2, '2023-03-05', 'Delivered', 'Credit Card'),
(103, 3, '2023-03-12', 'Delivered', 'Net Banking'),
(104, 1, '2023-04-02', 'Delivered', 'UPI'),
(105, 4, '2023-04-10', 'Cancelled', 'UPI'),
(106, 5, '2023-04-18', 'Delivered', 'Debit Card'),
(107, 2, '2023-05-04', 'Delivered', 'Credit Card'),
(108, 6, '2023-05-15', 'Delivered', 'UPI'),
(109, 7, '2023-06-02', 'Delivered', 'UPI'),
(110, 1, '2023-06-18', 'Delivered', 'UPI'),
(111, 8, '2023-06-25', 'Returned', 'Debit Card'),
(112, 3, '2023-07-02', 'Delivered', 'Net Banking');

INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 101, 1, 2, 599.00),
(2, 101, 3, 1, 299.00),
(3, 102, 2, 1, 2499.00),
(4, 103, 4, 3, 450.00),
(5, 104, 8, 1, 1299.00),
(6, 105, 5, 1, 1199.00),
(7, 106, 2, 1, 2499.00),
(8, 106, 1, 1, 599.00),
(9, 107, 7, 2, 899.00),
(10, 108, 6, 2, 650.00),
(11, 109, 5, 1, 1199.00),
(12, 110, 8, 2, 1299.00),
(13, 111, 4, 2, 450.00),
(14, 112, 1, 3, 599.00),
(15, 112, 3, 2, 299.00);

INSERT INTO daily_mandi_prices (record_id, commodity_name, mandi_location, state, record_date, min_price, max_price, modal_price, arrivals_tonnes) VALUES
(1, 'Onion', 'Lasalgaon', 'Maharashtra', '2023-09-01', 1400.00, 2200.00, 1850.00, 420.50),
(2, 'Onion', 'Lasalgaon', 'Maharashtra', '2023-09-02', 1450.00, 2300.00, 1920.00, 390.00),
(3, 'Onion', 'Lasalgaon', 'Maharashtra', '2023-09-03', 1500.00, 2450.00, 2050.00, 350.20),
(4, 'Onion', 'Lasalgaon', 'Maharashtra', '2023-09-04', 1480.00, 2380.00, 1980.00, 410.00),
(5, 'Onion', 'Lasalgaon', 'Maharashtra', '2023-09-05', 1520.00, 2500.00, 2100.00, 310.80),
(6, 'Tomato', 'Kolar', 'Karnataka', '2023-09-01', 800.00, 1500.00, 1200.00, 280.00),
(7, 'Tomato', 'Kolar', 'Karnataka', '2023-09-02', 850.00, 1600.00, 1280.00, 260.50),
(8, 'Tomato', 'Kolar', 'Karnataka', '2023-09-03', 900.00, 1750.00, 1400.00, 220.00),
(9, 'Tomato', 'Kolar', 'Karnataka', '2023-09-04', 880.00, 1700.00, 1350.00, 245.00),
(10, 'Wheat', 'Khanna', 'Punjab', '2023-09-01', 2125.00, 2350.00, 2250.00, 650.00),
(11, 'Wheat', 'Khanna', 'Punjab', '2023-09-02', 2130.00, 2360.00, 2260.00, 620.00),
(12, 'Wheat', 'Khanna', 'Punjab', '2023-09-03', 2140.00, 2380.00, 2280.00, 590.00);
