with orders as (
    select *
    from {{ ref('int_orders_enriched')}}
)

select * from orders