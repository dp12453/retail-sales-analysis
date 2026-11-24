/*
====================================================
PROJECT: RETAIL SALES ANALYSIS
FILE: 03_sales_analysis.sql
DATABASE: retail_sales.db
SOURCE TABLE: superstore

DESCRIPTION:
Sales-focused SQL analysis of the Sample Superstore dataset.

OBJECTIVES:
1. Measure overall sales and order performance.
2. Analyse sales by category, sub-category and region.
3. Identify top and low-performing products.
4. Explore customer segments and shipping modes.
5. Analyse monthly and yearly sales trends.
6. Identify transactions and areas requiring further investigation.

NOTES:
- The source table contains transaction line items, not one row per order.
- COUNT(*) counts line items. Use COUNT(DISTINCT "Order ID") for orders.
- Sales and Profit are analysed at line-item level unless otherwise stated.
- The sample dataset includes dates after 2026-11-24. Treat 2026 as
  an incomplete/future-dated sample year, not a completed actual year.
====================================================
*/

-- ==================================================
-- 1. OVERALL SALES PERFORMANCE
-- ==================================================

SELECT
    COUNT(*) AS total_transaction_lines,
    COUNT(DISTINCT "Order ID") AS total_orders,
    COUNT(DISTINCT "Customer ID") AS total_customers,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Sales), 2) AS avg_line_item_sales,
    ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2)
        AS overall_profit_margin_percentage
FROM superstore;


-- ==================================================
-- 2. SALES AND PROFIT BY CATEGORY
-- ==================================================

SELECT
    Category,
    COUNT(*) AS transaction_lines,
    COUNT(DISTINCT "Order ID") AS orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2)
        AS profit_margin_percentage
FROM superstore
GROUP BY Category
ORDER BY total_sales DESC;


-- ==================================================
-- 3. SALES AND PROFIT BY SUB-CATEGORY
-- ==================================================

SELECT
    Category,
    "Sub-Category",
    COUNT(*) AS transaction_lines,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2)
        AS profit_margin_percentage
FROM superstore
GROUP BY Category, "Sub-Category"
ORDER BY total_sales DESC;


-- ==================================================
-- 4. REGIONAL SALES PERFORMANCE
-- ==================================================

SELECT
    Region,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2)
        AS profit_margin_percentage
FROM superstore
GROUP BY Region
ORDER BY total_sales DESC;


-- ==================================================
-- 5. STATE-LEVEL SALES PERFORMANCE
-- ==================================================

SELECT
    "State/Province",
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2)
        AS profit_margin_percentage
FROM superstore
GROUP BY "State/Province"
ORDER BY total_sales DESC
LIMIT 20;


-- ==================================================
-- 6. TOP 20 PRODUCTS BY SALES
-- ==================================================

SELECT
    "Product ID",
    "Product Name",
    Category,
    "Sub-Category",
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM superstore
GROUP BY "Product ID", "Product Name", Category, "Sub-Category"
ORDER BY total_sales DESC
LIMIT 20;


-- ==================================================
-- 7. TOP 20 PRODUCTS BY PROFIT
-- ==================================================

SELECT
    "Product ID",
    "Product Name",
    Category,
    "Sub-Category",
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM superstore
GROUP BY "Product ID", "Product Name", Category, "Sub-Category"
ORDER BY total_profit DESC
LIMIT 20;


-- ==================================================
-- 8. BOTTOM 20 PRODUCTS BY PROFIT
-- ==================================================

SELECT
    "Product ID",
    "Product Name",
    Category,
    "Sub-Category",
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM superstore
GROUP BY "Product ID", "Product Name", Category, "Sub-Category"
ORDER BY total_profit ASC
LIMIT 20;


-- ==================================================
-- 9. SALES AND PROFIT BY CUSTOMER SEGMENT
-- ==================================================

SELECT
    Segment,
    COUNT(DISTINCT "Customer ID") AS total_customers,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2)
        AS profit_margin_percentage
FROM superstore
GROUP BY Segment
ORDER BY total_sales DESC;


-- ==================================================
-- 10. SALES PERFORMANCE BY SHIPPING MODE
-- ==================================================

SELECT
    "Ship Mode",
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Sales), 2) AS avg_line_item_sales,
    ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2)
        AS profit_margin_percentage
FROM superstore
GROUP BY "Ship Mode"
ORDER BY total_sales DESC;


-- ==================================================
-- 11. YEARLY SALES AND PROFIT TRENDS
-- ==================================================

SELECT
    strftime('%Y', "Order Date") AS order_year,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2)
        AS profit_margin_percentage
FROM superstore
GROUP BY strftime('%Y', "Order Date")
ORDER BY order_year;


-- ==================================================
-- 12. MONTHLY SALES AND PROFIT TRENDS
-- ==================================================

SELECT
    strftime('%Y-%m', "Order Date") AS order_month,
    COUNT(DISTINCT "Order ID") AS total_orders,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM superstore
GROUP BY strftime('%Y-%m', "Order Date")
ORDER BY order_month;


-- ==================================================
-- 13. MONTH-OF-YEAR SALES SUMMARY
--     Combines the same calendar month across all years.
-- ==================================================

SELECT
    strftime('%m', "Order Date") AS month_number,
    CASE strftime('%m', "Order Date")
        WHEN '01' THEN 'January'
        WHEN '02' THEN 'February'
        WHEN '03' THEN 'March'
        WHEN '04' THEN 'April'
        WHEN '05' THEN 'May'
        WHEN '06' THEN 'June'
        WHEN '07' THEN 'July'
        WHEN '08' THEN 'August'
        WHEN '09' THEN 'September'
        WHEN '10' THEN 'October'
        WHEN '11' THEN 'November'
        WHEN '12' THEN 'December'
    END AS month_name,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit
FROM superstore
GROUP BY strftime('%m', "Order Date")
ORDER BY month_number;


-- ==================================================
-- 14. DISCOUNT IMPACT ON SALES AND PROFIT
-- ==================================================

SELECT
    Discount,
    COUNT(*) AS transaction_lines,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(AVG(Profit), 2) AS avg_profit_per_line,
    ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2)
        AS profit_margin_percentage
FROM superstore
GROUP BY Discount
ORDER BY Discount;


-- ==================================================
-- 15. LOSS-MAKING TRANSACTION LINE ANALYSIS
-- ==================================================

SELECT
    COUNT(*) AS loss_making_transaction_lines,
    ROUND(SUM(Sales), 2) AS sales_from_loss_lines,
    ROUND(SUM(Profit), 2) AS total_loss,
    ROUND(AVG(Profit), 2) AS avg_loss_per_line
FROM superstore
WHERE Profit < 0;


-- ==================================================
-- 16. FINAL SALES PERFORMANCE SUMMARY
-- ==================================================

SELECT
    COUNT(*) AS total_transaction_lines,
    COUNT(DISTINCT "Order ID") AS total_orders,
    COUNT(DISTINCT "Customer ID") AS total_customers,
    COUNT(DISTINCT "Product ID") AS unique_products,
    ROUND(SUM(Sales), 2) AS total_sales,
    ROUND(SUM(Profit), 2) AS total_profit,
    ROUND(SUM(Profit) * 100.0 / NULLIF(SUM(Sales), 0), 2)
        AS overall_profit_margin_percentage,
    SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END)
        AS loss_making_transaction_lines
FROM superstore;
