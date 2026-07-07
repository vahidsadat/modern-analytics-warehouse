with source as (
    select * from warehouse.order_items
),

renamed as (
    select
        order_item_id,
        order_id,
        product_id,
        quantity,
        unit_price,
        discount_amount,
        quantity * unit_price as gross_revenue,
        (quantity * unit_price) - discount_amount as net_revenue
    
    from source
)

select * from renamed