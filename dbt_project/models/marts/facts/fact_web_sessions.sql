with web_sessions as (
    select *
    from {{ ref('stg_web_sessions')}}
)

select * from web_sessions