-- Project 1: Retail Sales Analysis
-- File 02: Safe Data Preparation
-- Database: SQLite | Source table: superstore
-- Purpose: Create a separate analysis table while preserving the raw table.
-- IMPORTANT: Review the validation results before deciding whether to exclude records.
-- This script trims text fields and retains rows with essential identifiers and numeric values.
-- It does not remove future-dated records or negative-profit rows.

-- 1. Review candidate rows with missing essential fields.
SELECT COUNT(*) AS rows_missing_essential_fields
FROM superstore
WHERE "Order ID" IS NULL OR TRIM("Order ID") = ''
   OR "Order Date" IS NULL OR TRIM("Order Date") = ''
   OR "Customer ID" IS NULL OR TRIM("Customer ID") = ''
   OR "Product ID" IS NULL OR TRIM("Product ID") = ''
   OR Sales IS NULL
   OR Quantity IS NULL;

-- 2. Rebuild the analysis table safely.
-- Drop only the derived table, never the original superstore table.
DROP TABLE IF EXISTS superstore_cleaned;

CREATE TABLE superstore_cleaned AS
SELECT
    "Row ID",
    TRIM("Order ID") AS "Order ID",
    date("Order Date") AS "Order Date",
    date("Ship Date") AS "Ship Date",
    TRIM("Ship Mode") AS "Ship Mode",
    TRIM("Customer ID") AS "Customer ID",
    TRIM("Customer Name") AS "Customer Name",
    TRIM(Segment) AS Segment,
    TRIM("Country/Region") AS "Country/Region",
    TRIM(City) AS City,
    TRIM("State/Province") AS "State/Province",
    "Postal Code",
    TRIM(Region) AS Region,
    TRIM("Product ID") AS "Product ID",
    TRIM(Category) AS Category,
    TRIM("Sub-Category") AS "Sub-Category",
    TRIM("Product Name") AS "Product Name",
    Sales,
    Quantity,
    Discount,
    Profit
FROM superstore
WHERE "Order ID" IS NOT NULL AND TRIM("Order ID") <> ''
  AND "Order Date" IS NOT NULL AND TRIM("Order Date") <> ''
  AND "Customer ID" IS NOT NULL AND TRIM("Customer ID") <> ''
  AND "Product ID" IS NOT NULL AND TRIM("Product ID") <> ''
  AND Sales IS NOT NULL
  AND Quantity IS NOT NULL;

-- 3. Compare raw and prepared row counts.
SELECT
    (SELECT COUNT(*) FROM superstore) AS raw_rows,
    (SELECT COUNT(*) FROM superstore_cleaned) AS prepared_rows;

-- 4. Recheck essential missing values in the prepared table.
SELECT
    SUM(CASE WHEN "Order ID" IS NULL OR "Order ID" = '' THEN 1 ELSE 0 END) AS missing_order_id,
    SUM(CASE WHEN "Customer ID" IS NULL OR "Customer ID" = '' THEN 1 ELSE 0 END) AS missing_customer_id,
    SUM(CASE WHEN Sales IS NULL THEN 1 ELSE 0 END) AS missing_sales
FROM superstore_cleaned;

-- 5. Confirm the prepared date range.
SELECT
    MIN("Order Date") AS earliest_order_date,
    MAX("Order Date") AS latest_order_date
FROM superstore_cleaned;

-- Note: Negative profit is a valid business outcome, not a data error.
-- Future-dated records are retained and must be disclosed in reporting.
