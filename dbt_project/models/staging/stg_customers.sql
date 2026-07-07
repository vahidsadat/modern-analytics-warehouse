with source as (
    select * from warehouse.customers
),

renamed as (
    select
        customer_id,
        first_name,
        last_name,
        concat(first_name , ' ' , last_name) as full_name,
        email,
        signup_date,
        city,
        country,
        acquisition_channel,
        is_business_customer
    
    from source
)

select * from renamed