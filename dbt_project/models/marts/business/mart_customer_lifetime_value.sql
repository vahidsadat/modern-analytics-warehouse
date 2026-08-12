with orders as (
    select 
        customer_id,
        count(order_id) as total_orders,
        sum(case when is_completed_order then 1 else 0 end) as completed_orders,
        sum(case when is_returned_order then 1 else 0 end) as returned_orders,
        sum(case when is_cancelled_order then 1 else 0 end) as cancelled_orders,
        round(sum(case when is_completed_order and is_paid_order then net_revenue else 0 end)::numeric, 2) as lifetime_net_revenue,
        round(sum(case when is_paid_order then paid_amount else 0 end)::numeric, 2) as lifetime_paid_revenue,
        round(sum(case when is_completed_order then gross_margin else 0 end)::numeric, 2) as lifetime_gross_margin,
        round((sum(case when is_completed_order and is_paid_order then net_revenue else 0 end)/NULLIF(sum(case when is_completed_order and is_paid_order then 1 else 0 end),0))::numeric, 2) as average_order_value,
        case
            when round(sum(case when is_completed_order and is_paid_order then net_revenue else 0 end)::numeric, 2) = 0 then 'No Purchase'
            when round(sum(case when is_completed_order and is_paid_order then net_revenue else 0 end)::numeric, 2) >= 1000 then 'VIP'
            when round(sum(case when is_completed_order and is_paid_order then net_revenue else 0 end)::numeric, 2) >= 500 then 'High Value'
            when round(sum(case when is_completed_order and is_paid_order then net_revenue else 0 end)::numeric, 2) >= 100 then 'Regular'
            else 'Low Value'
        end as customer_segment
            
    from {{ ref('fact_orders')}}
    group by customer_id
),

customers as (
    select
        customer_id,
        full_name,
        email,
        city,
        country,
        acquisition_channel,
        signup_date,
        first_order_date,
        last_order_date as latest_order_date
    from {{ ref('dim_customers') }}
),


joined as (
    select 
        customers.customer_id,
        customers.full_name,
        customers.email,
        customers.city,
        customers.country,
        customers.acquisition_channel,
        customers.signup_date,
        customers.first_order_date,
        customers.latest_order_date,
        coalesce(orders.total_orders,0) as total_orders,
        coalesce(orders.completed_orders,0) as completed_orders,
        coalesce(orders.returned_orders,0) as returned_orders,
        coalesce(orders.cancelled_orders,0) as cancelled_orders,
        coalesce(orders.lifetime_net_revenue,0) as lifetime_net_revenue,
        coalesce(orders.lifetime_paid_revenue,0) as lifetime_paid_revenue,
        coalesce(orders.lifetime_gross_margin,0) as lifetime_gross_margin,
        coalesce(orders.average_order_value,0) as average_order_value,
        coalesce(orders.customer_segment,'No Purchase') as customer_segment
    from customers
    left join orders
        on customers.customer_id = orders.customer_id
)

select * from joined