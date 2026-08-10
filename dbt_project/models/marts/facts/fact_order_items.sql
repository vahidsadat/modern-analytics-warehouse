with order_item as (
    select
        order_item_id,
        order_id,
        customer_id,
        product_id,
        order_date,
        order_status,
        sales_channel,
        quantity,
        unit_price,
        unit_cost,
        gross_revenue,
        discount_amount,
        net_revenue,
        total_cost,
        gross_margin
    from {{ ref('int_order_items_enriched')}}
)

select * from order_item