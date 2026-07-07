with source as (
    select * from warehouse.payments
),

renamed as (
    select
        payment_id,
        order_id,
        payment_method,
        payment_status,
        amount,
        paid_at,
        paid_at::date as paid_date
    
    from source
)

select * from renamed