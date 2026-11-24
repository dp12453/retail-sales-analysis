# Retail Sales Analysis — SQL Files

These nine SQLite scripts are a project starter pack.

## Run order
1. `01_data_validation.sql`
2. `02_data_cleaning.sql`
3. `03_sales_analysis.sql`
4. `04_customer_analysis.sql`
5. `05_product_analysis.sql`
6. `06_regional_analysis.sql`
7. `07_discount_analysis.sql`
8. `08_time_series_analysis.sql`
9. `09_business_insights.sql`

## Requirements
- Database Browser for SQLite
- A database containing the source table named `superstore`
- Expected source columns are the Tableau Sample Superstore columns used in this project.

## Important
- Run file 01 first to inspect data quality.
- File 02 creates `superstore_cleaned` and preserves the original `superstore` table.
- Files 03–09 use `superstore_cleaned`.
- File 04 creates `customer_summary`.
- Review query outputs and adjust the scripts if your imported table differs.
- The dataset contains dates after 2026-11-24. Do not present those records as completed historical performance.
- Negative profit is a valid business outcome, not automatically a data-quality error.
- These are prepared project scripts; they should be executed and validated against your database before being described as fully tested.
