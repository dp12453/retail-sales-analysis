-- Project 1: Retail Sales Analysis
-- File 09: Business Insights
-- Source table: superstore_cleaned
-- These queries support business recommendations; interpret results before making claims.

-- 1. Category and sub-category profitability.
SELECT Category, "Sub-Category",
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit,
       ROUND(100.0*SUM(Profit)/NULLIF(SUM(Sales),0),2) AS profit_margin_pct
FROM superstore_cleaned
GROUP BY Category, "Sub-Category"
ORDER BY profit ASC;

-- 2. Regions with comparatively low profit margins.
SELECT Region,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit,
       ROUND(100.0*SUM(Profit)/NULLIF(SUM(Sales),0),2) AS profit_margin_pct
FROM superstore_cleaned
GROUP BY Region
ORDER BY profit_margin_pct ASC;

-- 3. Customers with high sales but negative profit.
SELECT "Customer ID", "Customer Name",
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY "Customer ID", "Customer Name"
HAVING SUM(Profit) < 0
ORDER BY sales DESC
LIMIT 25;

-- 4. Products with high sales but negative profit.
SELECT "Product ID", "Product Name",
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY "Product ID", "Product Name"
HAVING SUM(Profit) < 0
ORDER BY sales DESC
LIMIT 25;

-- 5. Product/category combinations with the largest losses.
SELECT Category, "Sub-Category",
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY Category, "Sub-Category"
HAVING SUM(Profit) < 0
ORDER BY profit ASC;

-- 6. Discount levels associated with losses.
SELECT Discount,
       COUNT(*) AS transaction_lines,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY Discount
HAVING SUM(Profit) < 0
ORDER BY profit ASC;

-- 7. Create a concise KPI result for reporting.
SELECT
    COUNT(*) AS transaction_lines,
    COUNT(DISTINCT "Order ID") AS orders,
    COUNT(DISTINCT "Customer ID") AS customers,
    ROUND(SUM(Sales),2) AS total_sales,
    ROUND(SUM(Profit),2) AS total_profit,
    ROUND(100.0*SUM(Profit)/NULLIF(SUM(Sales),0),2) AS profit_margin_pct,
    SUM(CASE WHEN Profit < 0 THEN 1 ELSE 0 END) AS loss_making_lines
FROM superstore_cleaned;

-- Analyst note:
-- Do not claim that discount alone caused losses.
-- Validate patterns against product mix, region, customer segment, and dates.
-- Document that the sample dataset contains future-dated records beyond 2026-11-24.
