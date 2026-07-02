# Data Dictionary — Project 2 Modern Analytics Warehouse

## customers.csv
- customer_id: unique customer identifier
- first_name, last_name, email
- signup_date: date when customer registered
- city, country
- acquisition_channel: original customer acquisition source
- is_business_customer: boolean

## products.csv
- product_id: unique product identifier
- sku
- product_name
- category
- brand
- unit_cost
- list_price
- is_active
- created_at

## orders.csv
- order_id: unique order identifier
- customer_id: FK to customers
- order_created_at
- order_status: completed, cancelled, returned
- shipping_country, shipping_city
- sales_channel: web, mobile_app, marketplace
- discount_code
- shipping_fee

## order_items.csv
- order_item_id: unique order line identifier
- order_id: FK to orders
- product_id: FK to products
- quantity
- unit_price
- discount_amount

## payments.csv
- payment_id: unique payment identifier
- order_id: FK to orders
- payment_method
- payment_status: paid, failed, refunded
- amount
- paid_at

## web_sessions.csv
- session_id: unique session identifier
- customer_id: optional FK to customers; blank means anonymous
- started_at
- source_channel
- device_type
- landing_page
- pageviews
- duration_seconds

## marketing_spend.csv
- spend_date
- channel
- campaign_name
- spend_eur
- impressions
- clicks
