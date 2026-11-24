-- Project 1: Retail Sales Analysis
-- File 05: Product Analysis
-- Source table: superstore_cleaned

-- 1. Overall product count and performance.
SELECT COUNT(DISTINCT "Product ID") AS unique_products,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned;

-- 2. Product performance by category and sub-category.
SELECT Category, "Sub-Category",
       COUNT(DISTINCT "Product ID") AS products,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY Category, "Sub-Category"
ORDER BY profit DESC;

-- 3. Top 20 products by sales.
SELECT "Product ID", "Product Name",
       ROUND(SUM(Sales),2) AS sales
FROM superstore_cleaned
GROUP BY "Product ID", "Product Name"
ORDER BY sales DESC
LIMIT 20;

-- 4. Top 20 products by profit.
SELECT "Product ID", "Product Name",
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY "Product ID", "Product Name"
ORDER BY profit DESC
LIMIT 20;

-- 5. Bottom 20 products by profit.
SELECT "Product ID", "Product Name",
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY "Product ID", "Product Name"
ORDER BY profit ASC
LIMIT 20;

-- 6. Products with negative total profit.
SELECT "Product ID", "Product Name",
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY "Product ID", "Product Name"
HAVING SUM(Profit) < 0
ORDER BY profit ASC;

-- 7. Product-level profit margin (only positive sales).
SELECT "Product ID", "Product Name",
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit,
       ROUND(100.0*SUM(Profit)/NULLIF(SUM(Sales),0),2) AS profit_margin_pct
FROM superstore_cleaned
GROUP BY "Product ID", "Product Name"
HAVING SUM(Sales) > 0
ORDER BY profit_margin_pct DESC
LIMIT 20;

-- 8. Quantity and sales by sub-category.
SELECT Category, "Sub-Category",
       SUM(Quantity) AS units_sold,
       ROUND(SUM(Sales),2) AS sales
FROM superstore_cleaned
GROUP BY Category, "Sub-Category"
ORDER BY units_sold DESC;

-- 9. Average discount by sub-category.
SELECT Category, "Sub-Category",
       ROUND(AVG(Discount),3) AS avg_discount,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY Category, "Sub-Category"
ORDER BY avg_discount DESC;

-- 10. Product contribution to total profit.
SELECT "Product Name",
       ROUND(SUM(Profit),2) AS profit,
       ROUND(100.0*SUM(Profit)/(SELECT SUM(Profit) FROM superstore_cleaned),2) AS profit_contribution_pct
FROM superstore_cleaned
GROUP BY "Product Name"
ORDER BY profit DESC
LIMIT 20;
