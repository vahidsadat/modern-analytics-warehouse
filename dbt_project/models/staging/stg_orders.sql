with source as (
    select * from warehouse.orders
),

renamed as (
    select
        order_id,
        customer_id,
        order_created_at as order_date,
        order_status,
        shipping_country,
        shipping_city,
        sales_channel,
        discount_code,
        shipping_fee
    
    from source
)

select * from renamed