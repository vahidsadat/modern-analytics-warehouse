with marketing_spends as (
    select *
    from {{ ref('stg_marketing_spend')}}
)

select * from marketing_spends