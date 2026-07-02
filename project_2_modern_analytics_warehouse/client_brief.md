# Project 2 — Modern Analytics Warehouse

## Client
Nordatlas Retail Demo is a mid-sized e-commerce company based in Hamburg. The company sells consumer products through web, mobile app, and marketplace channels in Germany, Austria, Switzerland, and the Netherlands.
This is a fully fictional portfolio project.
The company name, customers, products, orders, payments, sessions, and marketing data are synthetic.
This project is not affiliated with or endorsed by any real organization.

## Business problem
The company has valid operational data, but reporting is slow and inconsistent. Management wants a PostgreSQL-based analytics warehouse with dbt models, tests, documentation, and clear dimensional modeling.

## Your goal
Build a modern analytics warehouse that turns raw CSV source data into reliable marts for sales, customer, product, marketing, and web analytics.

## Source files
- customers.csv
- products.csv
- orders.csv
- order_items.csv
- payments.csv
- web_sessions.csv
- marketing_spend.csv

## Expected warehouse layers
1. raw: loaded source tables
2. staging: cleaned and renamed source models
3. intermediate: business logic joins and calculations
4. marts: final fact and dimension tables

## Expected final models
- dim_customers
- dim_products
- dim_dates
- fact_orders
- fact_order_items
- fact_payments
- fact_web_sessions
- fact_marketing_spend
- mart_daily_sales
- mart_customer_lifetime_value
- mart_product_performance
- mart_marketing_roi

## Important business definitions
- Gross revenue = quantity * unit_price
- Discount amount = order item discount_amount
- Net revenue = gross revenue - discount_amount
- Paid revenue = sum of payment amount where payment_status = 'paid'
- Cancelled orders should not count as completed sales
- Returned/refunded orders should be tracked separately
- Customer lifetime value should be based on completed paid orders
- Marketing ROI = net revenue attributed to a channel / spend_eur
- Attribution can initially use a simple rule: same-day channel-level revenue by customer acquisition channel or web session source_channel

## dbt expectations
- Define sources in sources.yml
- Add staging models for every source table
- Add generic tests: not_null, unique, accepted_values, relationships
- Add at least 5 custom data tests
- Add model and column documentation
- Use dbt exposures or metrics if you want an advanced version
- Generate dbt docs

## Acceptance criteria
The project is successful when:
- All CSV files can be loaded into PostgreSQL
- dbt run completes successfully
- dbt test completes successfully
- Final marts answer the requested business questions
- The README explains setup, architecture, assumptions, and example queries
