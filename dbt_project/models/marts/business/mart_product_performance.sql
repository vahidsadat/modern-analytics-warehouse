with products as (
    select
        product_id,
        sku,
        product_name,
        category,
        brand,
        is_active,
        list_price,
        unit_cost
    from {{ ref('dim_products') }}
),

order_items as (
    select
        product_id,
        order_id,
        quantity,
        gross_revenue,
        discount_amount,
        net_revenue,
        total_cost,
        gross_margin
    from {{ ref('fact_order_items') }}
),

orders as (
    select
        order_id,
        order_status,
        is_completed_order,
        is_cancelled_order,
        is_returned_order
    from {{ ref('fact_orders') }}
),

order_items_with_orders as (
    select
        order_items.product_id,
        order_items.order_id,
        order_items.quantity,
        order_items.gross_revenue,
        order_items.discount_amount,
        order_items.net_revenue,
        order_items.total_cost,
        order_items.gross_margin,
        orders.order_status,
        orders.is_completed_order,
        orders.is_cancelled_order,
        orders.is_returned_order
    from order_items
    left join orders
        on order_items.order_id = orders.order_id
),

product_metrics as (
    select
        product_id,

        sum(
            case
                when is_completed_order then quantity
                else 0
            end
        ) as total_quantity_sold,

        count(distinct order_id) as total_orders,

        sum(
            case
                when is_completed_order then gross_revenue
                else 0
            end
        ) as gross_revenue,

        sum(
            case
                when is_completed_order then discount_amount
                else 0
            end
        ) as discount_amount,

        sum(
            case
                when is_completed_order then net_revenue
                else 0
            end
        ) as net_revenue,

        sum(
            case
                when is_completed_order then total_cost
                else 0
            end
        ) as total_cost,

        sum(
            case
                when is_completed_order then gross_margin
                else 0
            end
        ) as gross_margin,

        count(
            case
                when is_returned_order then order_id
            end
        ) as return_count

    from order_items_with_orders
    group by product_id
)

select
    products.product_id,
    products.sku,
    products.product_name,
    products.category,
    products.brand,
    products.is_active,
    products.list_price,
    products.unit_cost,

    coalesce(product_metrics.total_quantity_sold, 0) as total_quantity_sold,
    coalesce(product_metrics.total_orders, 0) as total_orders,
    coalesce(product_metrics.gross_revenue, 0) as gross_revenue,
    coalesce(product_metrics.discount_amount, 0) as discount_amount,
    coalesce(product_metrics.net_revenue, 0) as net_revenue,
    coalesce(product_metrics.total_cost, 0) as total_cost,
    coalesce(product_metrics.gross_margin, 0) as gross_margin,

    round(
        coalesce(product_metrics.gross_margin, 0)::numeric
        / nullif(product_metrics.net_revenue, 0)
        * 100,
        2
    ) as gross_margin_percentage,

    coalesce(product_metrics.return_count, 0) as return_count,

    round(
        coalesce(product_metrics.return_count, 0)::numeric
        / nullif(product_metrics.total_orders, 0)
        * 100,
        2
    ) as return_rate

from products
left join product_metrics
    on products.product_id = product_metrics.product_id