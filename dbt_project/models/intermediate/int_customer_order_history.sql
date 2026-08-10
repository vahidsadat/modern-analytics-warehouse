with customer as (
    select customer_id, 
    min(order_created_at) as first_order_date,
    max(order_created_at) as last_order_date,
    count(order_created_at) as total_orders,
    sum(case when is_completed_order then 1 else 0 end) as completed_orders,
    sum(case when is_cancelled_order then 1 else 0 end) as cancelled_orders,
    sum(case when is_returned_order then 1 else 0 end) as returned_order,
    sum(case when is_paid_order then 1 else 0 end) as paid_orders,
    round(sum(gross_revenue)::numeric, 2) as lifetime_gross_revenue,
    round(sum(discount_amount)::numeric, 2) as lifetime_discount_amount,
    round(sum(net_revenue)::numeric, 2) as lifetime_net_revenue,
    round(sum(paid_amount)::numeric, 2) as lifetime_paid_revenue,
    round(sum(gross_margin)::numeric, 2) as lifetime_gross_margin,
    round((sum(net_revenue) / sum(case when is_completed_order then 1 else 0 end))::numeric, 2) as average_order_value
    from {{ ref('int_orders_enriched')}}
    group by customer_id
)

select * from customer