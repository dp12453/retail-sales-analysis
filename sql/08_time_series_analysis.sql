-- Project 1: Retail Sales Analysis
-- File 08: Time-Series Analysis
-- Source table: superstore_cleaned
-- Important: The sample data includes order dates after 2026-11-24.
-- Treat 2026 as incomplete/future-contaminated; disclose the date limitation.

-- 1. First and last order date.
SELECT MIN(date("Order Date")) AS first_order_date,
       MAX(date("Order Date")) AS last_order_date
FROM superstore_cleaned;

-- 2. Yearly sales and profit.
SELECT strftime('%Y', "Order Date") AS order_year,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY order_year
ORDER BY order_year;

-- 3. Quarterly sales and profit.
SELECT strftime('%Y', "Order Date") AS order_year,
       'Q' || ((CAST(strftime('%m', "Order Date") AS INTEGER)-1)/3 + 1) AS quarter,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY order_year, quarter
ORDER BY order_year, quarter;

-- 4. Monthly sales and profit.
SELECT strftime('%Y-%m', "Order Date") AS order_month,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY order_month
ORDER BY order_month;

-- 5. Year-over-year sales change.
WITH yearly AS (
    SELECT CAST(strftime('%Y', "Order Date") AS INTEGER) AS order_year,
           SUM(Sales) AS sales
    FROM superstore_cleaned
    GROUP BY order_year
),
with_previous AS (
    SELECT order_year, sales,
           LAG(sales) OVER (ORDER BY order_year) AS previous_year_sales
    FROM yearly
)
SELECT order_year,
       ROUND(sales,2) AS sales,
       ROUND(previous_year_sales,2) AS previous_year_sales,
       ROUND(100.0*(sales-previous_year_sales)/NULLIF(previous_year_sales,0),2) AS yoy_sales_change_pct
FROM with_previous
ORDER BY order_year;

-- 6. Year-over-year profit change.
WITH yearly AS (
    SELECT CAST(strftime('%Y', "Order Date") AS INTEGER) AS order_year,
           SUM(Profit) AS profit
    FROM superstore_cleaned
    GROUP BY order_year
),
with_previous AS (
    SELECT order_year, profit,
           LAG(profit) OVER (ORDER BY order_year) AS previous_year_profit
    FROM yearly
)
SELECT order_year,
       ROUND(profit,2) AS profit,
       ROUND(previous_year_profit,2) AS previous_year_profit,
       ROUND(100.0*(profit-previous_year_profit)/NULLIF(previous_year_profit,0),2) AS yoy_profit_change_pct
FROM with_previous
ORDER BY order_year;

-- 7. Month-of-year totals across all years.
-- This is an aggregate by calendar month, not a year-by-year seasonal comparison.
SELECT strftime('%m', "Order Date") AS month_number,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY month_number
ORDER BY month_number;

-- 8. Sales and profit by weekday.
SELECT strftime('%w', "Order Date") AS weekday_number,
       COUNT(*) AS transaction_lines,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY weekday_number
ORDER BY weekday_number;

-- 9. Current-date cutoff summary (cutoff fixed to 2026-11-24 for this project).
SELECT
    CASE WHEN date("Order Date") <= date('2026-11-24')
         THEN 'On or before 2026-11-24'
         ELSE 'After 2026-11-24'
    END AS date_group,
    COUNT(*) AS transaction_lines,
    ROUND(SUM(Sales),2) AS sales,
    ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY date_group;
