with customer as (
    select 
        customer_id,
        acquisition_channel
        from {{ ref('stg_customers')}}
),

orders as (
    select * 
    from {{ ref('int_orders_enriched')}}
),

revenue as (
    select 
        customer.acquisition_channel,
        orders.order_created_at::date as order_date,
        count(orders.order_id) as total_orders,
        sum(case when orders.is_completed_order then 1 else 0 end) as completed_orders,
        round(sum(case 
                    when orders.is_completed_order and orders.is_paid_order
                    then orders.net_revenue
                    else 0
                  end)::numeric, 2) as net_revenue,
        round(sum(
            case 
                when orders.is_paid_order
                then orders.paid_amount
                else 0
            end
        )::numeric, 2) as paid_revenue,
        round(sum(case 
                    when orders.is_completed_order and orders.is_paid_order
                    then orders.gross_margin
                    else 0
                  end)::numeric, 2) as gross_margin
        from orders
        left join customer
            on orders.customer_id = customer.customer_id
        group by orders.order_created_at::date,customer.acquisition_channel
)

select * from revenue