with customer as (
    select customer_id, 
    min(order_created_at) as first_order_date,
    max(order_created_at) as last_order_date,
    count(order_created_at) as total_orders,
    from {{ ref('int_orders_enriched')}}
    group by customer_id
),