with customers as (
    select * 
    from {{ ref('stg_customers')}}
),

customer_order_history as (
    select
        customer_id,
        first_order_date::date,
        last_order_date::date,
        completed_orders,
        lifetime_net_revenue,
        lifetime_paid_revenue
    from {{ ref('int_customer_order_history')}}
),

joined as (
    select 
        customers.first_name,
        customers.last_name,
        customers.full_name,
        customers.email,
        customers.signup_date,
        customers.city,
        customers.country,
        customers.acquisition_channel,
        customers.is_business_customer,
        customer_order_history.customer_id,
        customer_order_history.first_order_date::date,
        customer_order_history.last_order_date::date,
        customer_order_history.completed_orders,
        customer_order_history.lifetime_net_revenue,
        customer_order_history.lifetime_paid_revenue
    from customer_order_history
    left join customers
        on customer_order_history.customer_id = customers.customer_id

)

select * from joined