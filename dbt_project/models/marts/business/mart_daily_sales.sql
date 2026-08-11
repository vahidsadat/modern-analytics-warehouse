with orders as(
    select
        order_date,
        count(order_id) as total_orders,
        sum(
            case
                when is_completed_order
                then 1
                else 0
            end
        ) as completed_orders,
        sum(
            case
                when is_cancelled_order
                then 1
                else 0
            end
        ) as cancelled_orders,
        sum(
            case
                when is_returned_order
                then 1
                else 0
            end
        ) as returned_orders,
        sum(
            case
                when is_paid_order
                then 1
                else 0
            end
        ) as paid_orders,
        round(sum(gross_revenue)::numeric, 2) as gross_revenue,
        round(sum(discount_amount)::numeric, 2) as discount_amount,
        round(sum(net_revenue)::numeric, 2) as net_revenue,
        round(sum(total_cost)::numeric, 2) as total_cost,
        round(sum(gross_margin)::numeric, 2) as gross_margin,
        round((sum(
            case    
                when is_completed_order
                then net_revenue
                else 0
            end
        ) / nullif(sum(
            case
                when is_completed_order
                then 1
                else 0
            end
        ), 0))::numeric, 2) as average_order_value,
        round((sum(
            case
                when is_returned_order
                then 1
                else 0
            end
        )*100.0 / nullif(count(order_id),0) )::numeric, 2) as refund_rate,
        round((sum(
            case
                when is_cancelled_order
                then 1
                else 0
            end
        )*100.0 / nullif(count(order_id),0) )::numeric, 2) as cancellation_rate
    from {{ ref('fact_orders')}}
    group by order_date
)

select * from orders