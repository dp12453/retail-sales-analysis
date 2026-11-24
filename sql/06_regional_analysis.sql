-- Project 1: Retail Sales Analysis
-- File 06: Regional Analysis
-- Source table: superstore_cleaned

-- 1. Overall region performance.
SELECT Region,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit,
       ROUND(100.0*SUM(Profit)/NULLIF(SUM(Sales),0),2) AS profit_margin_pct
FROM superstore_cleaned
GROUP BY Region
ORDER BY sales DESC;

-- 2. State performance within each region.
SELECT Region, "State/Province",
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY Region, "State/Province"
ORDER BY Region, profit DESC;

-- 3. Top 10 states by sales.
SELECT "State/Province", ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY "State/Province"
ORDER BY sales DESC
LIMIT 10;

-- 4. Bottom 10 states by profit.
SELECT "State/Province", ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY "State/Province"
ORDER BY profit ASC
LIMIT 10;

-- 5. City-level performance.
SELECT City, "State/Province", Region,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY City, "State/Province", Region
ORDER BY sales DESC
LIMIT 20;

-- 6. Region x category performance.
SELECT Region, Category,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY Region, Category
ORDER BY Region, profit DESC;

-- 7. Identify region-state combinations with losses.
SELECT Region, "State/Province",
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY Region, "State/Province"
HAVING SUM(Profit) < 0
ORDER BY profit ASC;
