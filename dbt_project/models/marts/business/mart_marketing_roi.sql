with marketing_spends as (
    select
        spend_date::date as spend_date,
        channel,
        round(sum(spend_eur)::numeric, 2) as spend_eur,
        round(sum(impressions)::numeric, 2) as impressions,
        round(sum(clicks)::numeric, 2) as clicks
    from {{ ref('fact_marketing_spends')}}
    group by spend_date, channel
),

orders as (
    select
        customer_id,
        order_date,
        net_revenue,
        is_paid_order,
        gross_margin,
        paid_amount,
        is_completed_order
    from {{ ref('fact_orders')}}
),

customers as (
    select
        customer_id,
        acquisition_channel
    from {{ ref('dim_customers')}}
),

orders_with_channel as (
    select
        orders.customer_id,
        orders.order_date,
        orders.net_revenue,
        orders.is_completed_order,
        orders.is_paid_order,
        orders.gross_margin,
        orders.paid_amount,
        customers.acquisition_channel
    from orders
    left join customers
        on customers.customer_id = orders.customer_id
),

revenue_by_date_channel as (
    select
        order_date,
        acquisition_channel,
        round(sum(case when is_completed_order then net_revenue else 0 end)::numeric, 2) as revenue,
        sum(case when is_completed_order then 1 else 0 end) as completed_orders,
        round(sum(case when is_completed_order then gross_margin else 0 end)::numeric, 2) as gross_margin,
        round(sum(case when is_paid_order then paid_amount else 0 end)::numeric, 2) as paid_revenue
    from orders_with_channel
    group by order_date, acquisition_channel
),

mart_marketing_roi as (
    select
        marketing_spends.channel,
        marketing_spends.spend_date,
        coalesce(marketing_spends.spend_eur,0) as spend_eur,
        coalesce(marketing_spends.impressions,0) as impressions,
        coalesce(marketing_spends.clicks,0) as clicks,

        coalesce(revenue_by_date_channel.completed_orders, 0) as completed_orders,
        coalesce(revenue_by_date_channel.revenue, 0) as net_revenue,
        coalesce(revenue_by_date_channel.paid_revenue, 0) as paid_revenue,
        coalesce(revenue_by_date_channel.gross_margin, 0) as gross_margin,
        round((marketing_spends.spend_eur / nullif(marketing_spends.clicks, 0))::numeric, 2) as cost_per_click,
        coalesce(round((revenue_by_date_channel.completed_orders * 100.0/ nullif(marketing_spends.clicks, 0))::numeric, 2), 0) as conversion_rate,
        coalesce(round((revenue_by_date_channel.revenue/ nullif(marketing_spends.spend_eur, 0))::numeric, 2), 0) as roas,
        coalesce(round(((revenue_by_date_channel.gross_margin-marketing_spends.spend_eur) * 100.0/ nullif(marketing_spends.spend_eur, 0))::numeric, 2), 0) as marketing_roi
    from marketing_spends
    left join revenue_by_date_channel
     on marketing_spends.spend_date = revenue_by_date_channel.order_date and
     marketing_spends.channel = revenue_by_date_channel.acquisition_channel

)
select * from mart_marketing_roi