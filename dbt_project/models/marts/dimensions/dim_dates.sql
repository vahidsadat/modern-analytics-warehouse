with orders_dates as (
    select cast(order_created_at as date) as date_key
    from {{ ref('fact_orders')}}
),

payments_dates as (
    select cast(paid_date as date) as date_key
    from {{ ref('fact_payments')}}
),

web_sessions as (
    select cast(session_date as date) as date_key
    from {{ ref('fact_web_sessions')}} 
),

marketing_spend as (
    select cast(spend_date as date) as date_key
    from {{ ref('fact_marketing_spends')}} 
),

combine_dates as (
    select date_key from orders_dates
    union
    select date_key from payments_dates
    union
    select date_key from web_sessions
    union
    select date_key from marketing_spend
)

select
    date_key::date as date_day,
    extract(year from date_key)::int as year,
    {{ dbt_date.date_part('quarter', 'date_key') }} as quarter_number,
    extract(month from date_key)::int as month,
    {{ dbt_date.month_name('date_key') }} as month_name,
    {{ dbt_date.iso_week_of_year('date_key') }} as week_of_year,
    {{ dbt_date.day_of_month('date_key') }} as day_of_month,
    {{ dbt_date.day_of_week('date_key') }} as day_of_week,
    {{ dbt_date.day_name('date_key') }} as day_name,
    case
        when {{ dbt_date.day_of_week('date_key') }} = 6 or {{ dbt_date.day_of_week('date_key') }} = 7
        then true
        else false
    end as is_weekend
from combine_dates
where date_key is not null
order by date_key