with source as (
    select * from warehouse.customers
),

renamed as (
    select
        customer_id as id,
        first_name,
        last_name
    
    from source
)

select * from renamed