# MySQL Data Analytics & Business Intelligence Portfolio
**Author:** Amit Amarnath Sharma ([@Catalyst097](https://github.com/Catalyst097))  
**Specialization:** Data Analytics, SQL Database Querying, Trend Analysis & Business Reporting

---

## 📌 Overview
This repository contains a comprehensive suite of production-grade **MySQL** scripts designed to solve real-world data analysis, business intelligence, and reporting challenges. It covers relational schema design, multi-table joins, Common Table Expressions (CTEs), and advanced Window Functions (`ROW_NUMBER`, `DENSE_RANK`, `LAG`, `LEAD`).

The projects simulate two industry domains:
1. **E-Commerce & Retail Analytics:** Customer Lifetime Value (LTV), monthly sales growth, product category performance, and repeat purchase retention.
2. **Agricultural Commodity (Mandi) Pricing:** Daily price trend monitoring, day-over-day price volatility, and regional market comparison.

---

## 🗂️ Repository Structure

```
├── 01_schema_and_seed_data.sql            # Database creation, normalized tables, and sample dataset
├── 02_intermediate_business_queries.sql   # Multi-table JOINs, aggregations, GROUP BY, HAVING
├── 03_advanced_window_functions_and_ctes.sql # CTEs, DENSE_RANK, LAG/LEAD price trends, Running Totals
└── 04_data_cleaning_and_validation.sql     # Deduplication, orphan record auditing, data integrity checks
```

---

## 🎯 Key SQL Concepts & Techniques Demonstrated

| Concept | Description / Business Use Case |
| :--- | :--- |
| **Relational Schema Design** | Primary keys, Foreign keys, `ON DELETE CASCADE`, indexed lookup columns. |
| **Multi-Table JOINs** | `INNER JOIN`, `LEFT JOIN` across customers, orders, items, and products. |
| **Aggregations & Filtering** | `GROUP BY`, `HAVING`, `SUM`, `AVG`, `COUNT(DISTINCT ...)`. |
| **Common Table Expressions (CTEs)** | Readable, modular multi-step analysis queries using `WITH`. |
| **Window Functions: Ranking** | `ROW_NUMBER()`, `DENSE_RANK()` for finding top N products per region/category. |
| **Window Functions: Time-Series** | `LAG()` & `LEAD()` to calculate day-over-day commodity price fluctuations and % change. |
| **Cumulative Analytics** | `SUM(...) OVER (PARTITION BY ... ORDER BY ...)` for running totals. |
| **Data Integrity Auditing** | Identifying orphaned foreign keys, duplicate records, and missing values. |

---

## 💻 Sample Query Highlights

### 1. Day-over-Day Commodity Price Volatility (using `LAG`):
```sql
WITH PriceChanges AS (
    SELECT 
        commodity_name,
        mandi_location,
        record_date,
        modal_price,
        LAG(modal_price, 1) OVER (
            PARTITION BY commodity_name, mandi_location 
            ORDER BY record_date
        ) AS previous_day_price
    FROM daily_mandi_prices
)
SELECT 
    commodity_name,
    mandi_location,
    record_date,
    modal_price,
    previous_day_price,
    ROUND(((modal_price - previous_day_price) / previous_day_price) * 100, 2) AS price_change_percentage
FROM PriceChanges
WHERE previous_day_price IS NOT NULL
ORDER BY record_date DESC;
```

### 2. Top 3 Revenue-Generating Products Per Category (using `DENSE_RANK`):
```sql
WITH RankedProducts AS (
    SELECT 
        p.category,
        p.product_name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY p.category 
            ORDER BY SUM(oi.quantity * oi.unit_price) DESC
        ) AS revenue_rank
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    GROUP BY p.category, p.product_name
)
SELECT category, product_name, total_revenue, revenue_rank
FROM RankedProducts
WHERE revenue_rank <= 3;
```

---

## 🚀 How to Run
1. Open **MySQL Workbench**, **DBeaver**, or the **MySQL CLI**.
2. Run `01_schema_and_seed_data.sql` to initialize the database and load seed data.
3. Execute scripts `02`, `03`, and `04` sequentially to inspect analysis outputs.
