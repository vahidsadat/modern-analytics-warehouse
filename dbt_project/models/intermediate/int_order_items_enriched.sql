with order_items as (
    select order_item_id, order_id, product_id,quantity,unit_price,discount_amount,gross_revenue,net_revenue, (quantity * products.unit_cost) as total_cost,
    net_revenue - (quantity * products.unit_cost) as gross_margin
    from {{ ref('stg_order_items') }}
),

orders as (
    select order_id, customer_id, order_date, order_status,sales_channel
    from {{ ref('stg_orders') }}
),

products as (
    select product_id, product_name, category, brand, unit_cost
    from {{ ref('stg_products') }}
)

select
    order_id,
    product_id
from order_items
left join orders 
    on order_items.order_id = orders.order_id
left join products
    on order_items.product_id = products.product_id
