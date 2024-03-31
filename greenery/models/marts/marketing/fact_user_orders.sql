with users as (

    select * from {{ ref('stg_postgres__users') }}

),

user_orders as (

    select 
        *
    from {{ ref('int_user_orders') }}

),

products_purchased as (

    select 
        o.user_id,
        count(oi.product_id) as products_purchased
    from {{ ref('stg_postgres__order_items') }} oi 
    left join {{ ref('stg_postgres__orders') }} o
        on oi.order_id = o.order_id
    group by 1

)

select 
    u.user_id,
    o.total_orders,
    coalesce(o.total_spend, 0) as total_spend,
    coalesce(p.products_purchased, 0) as products_purchased,
    o.total_orders is not null as is_buyer,
    coalesce(o.total_orders, 0) >= 2 as is_frequent_buyer,
    o.first_order_created_at,
    o.last_order_created_at
from users u 
left join user_orders o
    on u.user_id = o.user_id 
left join products_purchased p 
    on u.user_id = p.user_id 