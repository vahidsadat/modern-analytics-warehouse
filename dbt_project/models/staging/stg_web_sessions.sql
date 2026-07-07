with source as (
    select * from warehouse.web_sessions
),

renamed as (
    select
        session_id,
        customer_id,
        started_at,
        started_at::date as session_date,
        source_channel,
        device_type,
        landing_page,
        pageviews,
        duration_seconds
    
    from source
)

select * from renamed