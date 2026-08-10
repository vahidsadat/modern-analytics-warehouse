with orders as (
    select order_id, customer_id,order_date as  order_created_at, order_status, shipping_country, shipping_city, shipping_fee
    from {{ ref('stg_orders') }}
),

payments as (
    select order_id, payment_method, payment_status,
    case
            when payment_status = 'paid' then amount
            else 0
        end as paid_amount,

        case
            when payment_status = 'paid' then true
            else false
        end as is_paid_order,

        case
            when payment_status = 'refunded' then true
            else false
        end as is_refunded_order
    from {{ ref('stg_payments') }}
),

items as (
    select order_id, SUM(gross_revenue) as gross_revenue, SUM(discount_amount) as discount_amount,
     SUM(net_revenue) as net_revenue, SUM(total_cost) as total_cost, SUM(gross_margin) as gross_margin
    from {{ ref('int_order_items_enriched')}}
    group by order_id
),

joined as (
    select
        orders.order_id,
        orders.customer_id,
        orders.order_created_at,
        orders.order_status,
        orders.shipping_country, 
        orders.shipping_city, 
        orders.shipping_fee,
        payments.payment_method, 
        payments.payment_status, 
        payments.paid_amount,
        items.gross_revenue,
        items.discount_amount,
        items.net_revenue,
        items.total_cost,
        items.gross_margin,
        case
            when orders.order_status = 'completed' then true
            else false
        end as is_completed_order,

        case
            when orders.order_status = 'cancelled' then true
            else false
        end as is_cancelled_order,

        case
            when orders.order_status = 'returned' then true
            else false
        end as is_returned_order,
        payments.is_paid_order,
        payments.is_refunded_order

    from orders
    left join items
        on orders.order_id = items.order_id
    left join payments
        on orders.order_id = payments.order_id

)

select * from joined