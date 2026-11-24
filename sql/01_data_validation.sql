-- Project 1: Retail Sales Analysis
-- File 01: Data Validation
-- Database: SQLite | Source table: superstore
-- Purpose: Understand the table and check data quality before analysis.
-- Run these queries in order. This file does not modify the source table.

-- 1. Check the number of transaction lines.
SELECT COUNT(*) AS total_transaction_lines
FROM superstore;

-- 2. Inspect the table structure.
PRAGMA table_info(superstore);

-- 3. Check missing values in important columns.
SELECT
    SUM(CASE WHEN "Order ID" IS NULL OR TRIM("Order ID") = '' THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN "Order Date" IS NULL OR TRIM("Order Date") = '' THEN 1 ELSE 0 END) AS missing_order_date,
    SUM(CASE WHEN "Customer ID" IS NULL OR TRIM("Customer ID") = '' THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN "Product ID" IS NULL OR TRIM("Product ID") = '' THEN 1 ELSE 0 END) AS missing_product_id,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS missing_sales,
    SUM(CASE WHEN Profit IS NULL THEN 1 ELSE 0 END) AS missing_profit
FROM superstore;

-- 4. Check exact duplicate rows.
SELECT COUNT(*) AS duplicate_row_groups
FROM (
    SELECT "Row ID", COUNT(*) AS row_count
    FROM superstore
    GROUP BY "Row ID"
    HAVING COUNT(*) > 1
);

-- 5. Check duplicate transaction-line identifiers.
SELECT "Row ID", COUNT(*) AS occurrences
FROM superstore
GROUP BY "Row ID"
HAVING COUNT(*) > 1;

-- 6. Check distinct orders, customers, and products.
SELECT
    COUNT(DISTINCT "Order ID") AS total_orders,
    COUNT(DISTINCT "Customer ID") AS total_customers,
    COUNT(DISTINCT "Product ID") AS total_products
FROM superstore;

-- 7. Check numeric anomalies.
SELECT
    SUM(CASE WHEN Sales < 0 THEN 1 ELSE 0 END) AS negative_sales_rows,
    SUM(CASE WHEN Sales = 0 THEN 1 ELSE 0 END) AS zero_sales_rows,
    SUM(CASE WHEN Quantity <= 0 THEN 1 ELSE 0 END) AS nonpositive_quantity_rows,
    SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) AS loss_making_rows
FROM superstore;

-- 8. Check date range. Dates are stored as text in this dataset.
SELECT
    MIN(date("Order Date")) AS earliest_order_date,
    MAX(date("Order Date")) AS latest_order_date,
    MIN(date("Ship Date")) AS earliest_ship_date,
    MAX(date("Ship Date")) AS latest_ship_date
FROM superstore;

-- 9. Identify orders dated after 2026-11-24.
-- The sample dataset contains future-dated records; do not silently delete them.
SELECT COUNT(*) AS future_order_lines
FROM superstore
WHERE date("Order Date") > date('2026-11-24');

-- 10. Check for shipping dates earlier than order dates.
SELECT COUNT(*) AS ship_before_order_rows
FROM superstore
WHERE date("Ship Date") < date("Order Date");
