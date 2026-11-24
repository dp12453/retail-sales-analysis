/*
====================================================
PROJECT: RETAIL SALES ANALYSIS
FILE: 04_customer_analysis.sql
DATABASE: retail_sales.db

DESCRIPTION:
Customer-level sales and profitability analysis.

OBJECTIVES:
1. Analyse customer sales and profit.
2. Identify profitable and loss-making customers.
3. Analyse customer segments.
4. Understand customer purchasing behaviour.
5. Identify customer retention opportunities.
====================================================
*/

-- ==================================================
-- 1. OVERALL CUSTOMER PERFORMANCE
-- ==================================================

SELECT
    COUNT(*) AS total_customers,
    ROUND(SUM(total_sales), 2) AS total_sales,
    ROUND(SUM(total_profit), 2) AS total_profit,
    ROUND(AVG(total_sales), 2) AS avg_customer_sales,
    ROUND(AVG(total_profit), 2) AS avg_customer_profit
FROM customer_summary;

-- ==================================================
-- 2. TOP 20 MOST PROFITABLE CUSTOMERS
-- ==================================================

SELECT
    "Customer Name",
    Segment,
    total_orders,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit
FROM customer_summary
ORDER BY total_profit DESC
LIMIT 20;

-- ==================================================
-- 3. TOP 20 LOSS-MAKING CUSTOMERS
-- ==================================================

SELECT
    "Customer Name",
    Segment,
    total_orders,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit
FROM customer_summary
WHERE total_profit < 0
ORDER BY total_profit ASC
LIMIT 20;

-- ==================================================
-- 4. CUSTOMER PROFITABILITY BY SEGMENT
-- ==================================================

SELECT
    Segment,
    COUNT(*) AS total_customers,
    ROUND(SUM(total_sales), 2) AS total_sales,
    ROUND(SUM(total_profit), 2) AS total_profit,
    ROUND(AVG(total_sales), 2) AS avg_customer_sales,
    ROUND(AVG(total_profit), 2) AS avg_customer_profit
FROM customer_summary
GROUP BY Segment
ORDER BY total_profit DESC;

-- ==================================================
-- 5. CUSTOMER PROFITABILITY CLASSIFICATION
-- ==================================================

SELECT
    CASE
        WHEN total_profit > 2000 THEN 'High Profit'
        WHEN total_profit >= 500 THEN 'Medium Profit'
        ELSE 'Low Profit'
    END AS customer_category,

    COUNT(*) AS total_customers,
    ROUND(SUM(total_profit), 2) AS total_profit,
    ROUND(AVG(total_profit), 2) AS avg_customer_profit

FROM customer_summary

GROUP BY customer_category
ORDER BY total_profit DESC;

-- ==================================================
-- 6. CUSTOMER PROFIT CONTRIBUTION PERCENTAGE
-- ==================================================

WITH customer_classification AS (
    SELECT
        total_profit,

        CASE
            WHEN total_profit > 2000 THEN 'High Profit'
            WHEN total_profit >= 500 THEN 'Medium Profit'
            ELSE 'Low Profit'
        END AS customer_category

    FROM customer_summary
),

profit_summary AS (
    SELECT
        customer_category,
        SUM(total_profit) AS total_profit
    FROM customer_classification
    GROUP BY customer_category
)

SELECT
    customer_category,
    ROUND(total_profit, 2) AS total_profit,

    ROUND(
        total_profit * 100.0 /
        SUM(total_profit) OVER (),
        2
    ) AS profit_contribution_percentage

FROM profit_summary
ORDER BY total_profit DESC;

-- ==================================================
-- 7. LOSS-MAKING CUSTOMER ANALYSIS
-- ==================================================

SELECT
    COUNT(*) AS loss_making_customers,
    ROUND(SUM(total_sales), 2) AS total_sales,
    ROUND(SUM(total_profit), 2) AS total_customer_loss,
    ROUND(AVG(total_profit), 2) AS avg_loss_per_customer
FROM customer_summary
WHERE total_profit < 0;

-- ==================================================
-- 8. LOSS-MAKING CUSTOMERS BY SEGMENT
-- ==================================================

SELECT
    Segment,

    COUNT(*) AS total_customers,

    SUM(
        CASE
            WHEN total_profit < 0 THEN 1
            ELSE 0
        END
    ) AS loss_making_customers,

    ROUND(
        SUM(
            CASE
                WHEN total_profit < 0 THEN 1.0
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS loss_customer_percentage

FROM customer_summary
GROUP BY Segment
ORDER BY loss_customer_percentage DESC;

-- ==================================================
-- 9. CUSTOMER LOSSES BY SEGMENT
-- ==================================================

SELECT
    Segment,
    COUNT(*) AS loss_making_customers,
    ROUND(SUM(total_sales), 2) AS total_sales,
    ROUND(SUM(total_profit), 2) AS total_loss,
    ROUND(AVG(total_profit), 2) AS avg_loss_per_customer
FROM customer_summary
WHERE total_profit < 0
GROUP BY Segment
ORDER BY total_loss ASC;

-- ==================================================
-- 10. CUSTOMER LOYALTY ANALYSIS
-- ==================================================

SELECT
    CASE
        WHEN total_orders >= 8 THEN 'High Frequency'
        WHEN total_orders >= 4 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS loyalty_category,

    COUNT(*) AS total_customers,
    ROUND(AVG(total_orders), 2) AS avg_orders,
    ROUND(SUM(total_sales), 2) AS total_sales,
    ROUND(SUM(total_profit), 2) AS total_profit,
    ROUND(AVG(total_profit), 2) AS avg_customer_profit

FROM customer_summary

GROUP BY loyalty_category
ORDER BY avg_customer_profit DESC;

-- ==================================================
-- 11. TOP 5 CUSTOMERS IN EACH LOYALTY CATEGORY
-- ==================================================

WITH customer_loyalty AS (
    SELECT
        "Customer Name",
        total_orders,
        total_sales,
        total_profit,

        CASE
            WHEN total_orders >= 8 THEN 'High Frequency'
            WHEN total_orders >= 4 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS loyalty_category

    FROM customer_summary
),

ranked_customers AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY loyalty_category
            ORDER BY total_profit DESC
        ) AS customer_rank

    FROM customer_loyalty
)

SELECT
    loyalty_category,
    customer_rank,
    "Customer Name",
    total_orders,
    ROUND(total_profit, 2) AS total_profit

FROM ranked_customers
WHERE customer_rank <= 5
ORDER BY loyalty_category, customer_rank;

-- ==================================================
-- 12. TOP 20 CUSTOMERS BY PROFIT MARGIN
-- ==================================================

SELECT
    "Customer Name",
    Segment,
    total_orders,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,

    ROUND(
        total_profit * 100.0 /
        NULLIF(total_sales, 0),
        2
    ) AS profit_margin_percentage

FROM customer_summary

WHERE total_sales > 0
  AND total_profit > 0

ORDER BY profit_margin_percentage DESC
LIMIT 20;

-- ==================================================
-- 13. BOTTOM 20 CUSTOMERS BY PROFIT MARGIN
-- ==================================================

SELECT
    "Customer Name",
    Segment,
    total_orders,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,

    ROUND(
        total_profit * 100.0 /
        NULLIF(total_sales, 0),
        2
    ) AS profit_margin_percentage

FROM customer_summary

WHERE total_sales > 0

ORDER BY profit_margin_percentage ASC
LIMIT 20;

-- ==================================================
-- 14. CUSTOMER SALES AND PROFIT CONTRIBUTION
-- ==================================================

SELECT
    "Customer Name",
    Segment,

    ROUND(total_sales, 2) AS total_sales,
    ROUND(total_profit, 2) AS total_profit,

    ROUND(
        total_sales * 100.0 /
        SUM(total_sales) OVER (),
        2
    ) AS sales_contribution_percentage,

    ROUND(
        total_profit * 100.0 /
        SUM(total_profit) OVER (),
        2
    ) AS profit_contribution_percentage

FROM customer_summary

ORDER BY total_sales DESC

LIMIT 20;

-- ==================================================
-- 15. FINAL CUSTOMER PERFORMANCE SUMMARY
-- ==================================================

SELECT
    COUNT(*) AS total_customers,

    COUNT(
        CASE WHEN total_profit > 0 THEN 1 END
    ) AS profitable_customers,

    COUNT(
        CASE WHEN total_profit < 0 THEN 1 END
    ) AS loss_making_customers,

    COUNT(
        CASE WHEN total_profit = 0 THEN 1 END
    ) AS zero_profit_customers,

    ROUND(SUM(total_sales), 2) AS total_sales,

    ROUND(SUM(total_profit), 2) AS total_profit,

    ROUND(AVG(total_sales), 2) AS avg_customer_sales,

    ROUND(AVG(total_profit), 2) AS avg_customer_profit

FROM customer_summary;
