with orders as (
    select order_id, customer_id, order_date, order_status,sales_channel
    from {{ ref('stg_orders') }}
),

products as (
    select product_id, product_name, category, brand, unit_cost
    from {{ ref('stg_products') }}
),

order_items as (
    select order_item_id, order_id, product_id,quantity,unit_price,discount_amount,gross_revenue,net_revenue
    from {{ ref('stg_order_items') }}
),

joined as (
    select
        
        order_items.order_item_id,
        order_items.order_id,
        orders.customer_id,
        order_items.product_id,
        orders.order_date,
        orders.order_status,
        orders.sales_channel,

        products.product_name,
        products.category,
        products.brand,

        order_items.quantity,
        order_items.unit_price,
        products.unit_cost,
        order_items.gross_revenue,
        order_items.discount_amount,
        order_items.net_revenue,

        order_items.quantity * products.unit_cost as total_cost,
        order_items.net_revenue - (order_items.quantity * products.unit_cost) as gross_margin

    from order_items
    left join orders 
        on order_items.order_id = orders.order_id
    left join products
        on order_items.product_id = products.product_id
)

select * from joined
