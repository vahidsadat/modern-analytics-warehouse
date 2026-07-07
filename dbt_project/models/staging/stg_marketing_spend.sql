with source as (
    select * from {{ source('raw', 'marketing_spend') }}
),

renamed as (
    select
        spend_date,
        channel,
        campaign_name,
        spend_eur,
        impressions,
        clicks
    
    from source
)

select * from renamed