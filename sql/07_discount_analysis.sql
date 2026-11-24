-- Project 1: Retail Sales Analysis
-- File 07: Discount Analysis
-- Source table: superstore_cleaned
-- Observational analysis: association does not establish that discount caused a loss.

-- 1. Overall discount distribution.
SELECT Discount, COUNT(*) AS transaction_lines,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY Discount
ORDER BY Discount;

-- 2. Profit margin by discount level.
SELECT Discount,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit,
       ROUND(100.0*SUM(Profit)/NULLIF(SUM(Sales),0),2) AS profit_margin_pct
FROM superstore_cleaned
GROUP BY Discount
ORDER BY Discount;

-- 3. Compare no-discount and discounted lines.
SELECT
    CASE WHEN Discount = 0 THEN 'No Discount' ELSE 'Discount Applied' END AS discount_group,
    COUNT(*) AS transaction_lines,
    ROUND(SUM(Sales),2) AS sales,
    ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY discount_group;

-- 4. Discount performance by category.
SELECT Category, Discount,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY Category, Discount
ORDER BY Category, Discount;

-- 5. Discount performance by sub-category.
SELECT Category, "Sub-Category", Discount,
       ROUND(SUM(Sales),2) AS sales,
       ROUND(SUM(Profit),2) AS profit
FROM superstore_cleaned
GROUP BY Category, "Sub-Category", Discount
ORDER BY profit ASC;

-- 6. Higher discount bands.
SELECT
    CASE
        WHEN Discount = 0 THEN '0%'
        WHEN Discount <= 0.20 THEN 'Above 0% to 20%'
        WHEN Discount <= 0.40 THEN 'Above 20% to 40%'
        ELSE 'Above 40%'
    END AS discount_band,
    COUNT(*) AS transaction_lines,
    ROUND(SUM(Sales),2) AS sales,
    ROUND(SUM(Profit),2) AS profit,
    ROUND(100.0*SUM(Profit)/NULLIF(SUM(Sales),0),2) AS profit_margin_pct
FROM superstore_cleaned
GROUP BY discount_band
ORDER BY MIN(Discount);

-- 7. Loss-making lines by discount.
SELECT Discount, COUNT(*) AS loss_making_lines,
       ROUND(SUM(Sales),2) AS sales_on_loss_lines,
       ROUND(SUM(Profit),2) AS total_loss
FROM superstore_cleaned
WHERE Profit < 0
GROUP BY Discount
ORDER BY total_loss ASC;
