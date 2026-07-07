with source as (
    select * from warehouse.products
),

renamed as (
    select
        product_id,
        sku,
        product_name,
        category,
        brand,
        unit_cost,
        list_price,
        is_active,
        created_at
    
    from source
)

select * from renamed