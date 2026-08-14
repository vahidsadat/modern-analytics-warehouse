with marketing_spends as (
    select *
    from {{ ref('stg_marketing_spends')}}
)

select * from marketing_spends