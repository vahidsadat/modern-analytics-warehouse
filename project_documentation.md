# Project Documentation

## Purpose

The purpose of this project is to build a modern analytics warehouse for a fictional e-commerce business.

The warehouse transforms raw operational data into clean and trusted analytics models. These models help answer business questions about sales, customers, products, payments, website traffic, and marketing performance.

## Transformation Flow

The data transformation flow is:

```text
raw PostgreSQL tables
→ staging models
→ intermediate models
→ dimensions and facts
→ business marts
```

Each layer has a clear responsibility.

## Staging Layer

The staging layer prepares the raw data.

Responsibilities:

- select source columns
- rename columns
- cast data types
- create simple calculated columns
- standardize source data

The staging layer should stay simple and should not contain heavy business logic.

## Intermediate Layer

The intermediate layer applies reusable business logic.

Responsibilities:

- join related staging models
- calculate revenue, cost, and margin
- create order status flags
- prepare customer order history
- prepare daily channel revenue

Intermediate models make the final marts easier to read and maintain.

## Marts Layer

The marts layer contains the final business-ready models.

It is divided into:

- dimensions
- facts
- business marts

Dimensions describe business entities.

Facts store measurable business events.

Business marts summarize data for reporting and analysis.

## Main Business Definitions

### Gross Revenue

Gross revenue is revenue before discounts.

Formula:

```text
gross_revenue = quantity × unit_price
```

### Net Revenue

Net revenue is revenue after discounts.

Formula:

```text
net_revenue = gross_revenue - discount_amount
```

### Total Cost

Total cost is the product cost for sold items.

Formula:

```text
total_cost = quantity × unit_cost
```

### Gross Margin

Gross margin is revenue after product cost.

Formula:

```text
gross_margin = net_revenue - total_cost
```

### Paid Revenue

Paid revenue is the money actually received from successful payments.

Formula:

```text
paid_revenue = sum of paid_amount from paid orders
```

### Average Order Value

Average order value shows average revenue per completed order.

Formula:

```text
average_order_value = net_revenue / completed_orders
```

### Refund Rate

Refund rate shows the percentage of returned orders.

Formula:

```text
refund_rate = returned_orders / total_orders × 100
```

### Cancellation Rate

Cancellation rate shows the percentage of cancelled orders.

Formula:

```text
cancellation_rate = cancelled_orders / total_orders × 100
```

### ROAS

ROAS means return on advertising spend.

Formula:

```text
ROAS = net_revenue / marketing_spend
```

### Marketing ROI

Marketing ROI compares gross margin with marketing spend.

Formula:

```text
marketing_roi = (gross_margin - spend_eur) / spend_eur × 100
```

## Final Models

### dim_customers

Customer dimension table.

Grain:

```text
one row per customer
```

Purpose:

describes customers and includes lifetime customer metrics.

### dim_products

Product dimension table.

Grain:

```text
one row per product
```

Purpose:

describes product catalogue information.

### dim_dates

Calendar dimension table.

Grain:

```text
one row per date
```

Purpose:

supports date-based reporting and filtering.

### fact_orders

Order fact table.

Grain:

```text
one row per order
```

Purpose:

stores order-level revenue, payment, cost, margin, and status information.

### fact_order_items

Order item fact table.

Grain:

```text
one row per order item
```

Purpose:

stores product-level sales details for each order.

### fact_payments

Payment fact table.

Grain:

```text
one row per payment
```

Purpose:

stores payment method, payment status, and payment amount.

### fact_web_sessions

Web session fact table.

Grain:

```text
one row per web session
```

Purpose:

stores website traffic and engagement information.

### fact_marketing_spend

Marketing spend fact table.

Grain:

```text
one row per date, channel, and campaign
```

Purpose:

stores marketing spend, impressions, and clicks.

### mart_daily_sales

Daily sales mart.

Grain:

```text
one row per order date
```

Purpose:

shows daily business performance.

### mart_customer_lifetime_value

Customer lifetime value mart.

Grain:

```text
one row per customer
```

Purpose:

shows customer value, order history, and customer segment.

### mart_product_performance

Product performance mart.

Grain:

```text
one row per product
```

Purpose:

shows product sales, revenue, margin, and return metrics.

### mart_marketing_roi

Marketing ROI mart.

Grain:

```text
one row per spend date and marketing channel
```

Purpose:

compares marketing spend with revenue, paid revenue, and gross margin.

## Testing Strategy

The project uses dbt tests to validate data quality.

Main test types:

- not_null
- unique
- relationships
- accepted_values

The most important tests are applied to:

- primary keys
- foreign keys
- business statuses
- sales channels
- acquisition channels
- final mart grain columns

## Notes

This project is designed as a portfolio project for data engineering and analytics engineering roles.

It demonstrates practical skills in:

- SQL
- dbt
- PostgreSQL
- dimensional modeling
- business KPI calculation
- data testing
- analytics warehouse design
