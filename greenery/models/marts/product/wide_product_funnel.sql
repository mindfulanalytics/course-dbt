with 

events as (

    select 
        *
    from {{ ref('fact_page_views') }}
),

dim_users as (

    select 
        user_id,
        address_id,
        user_state
    from {{ ref('dim_users') }}
   
),

products as (

    select 
        product_id,
        product_name,
        product_price as current_product_price
    from {{ ref('dim_products') }}

)

select 
    e.session_id,
    e.user_id,
    e.product_id,
    session_started_at,
    session_ended_at,
    product_name,
    user_state,
    page_views,
    add_to_carts,
    checkouts,
    package_shippeds,
    datediff('minute', session_started_at, session_ended_at) as session_length_minutes
from events e 
left join dim_users du 
    on e.user_id = du.user_id
left join products p
    on e.product_id = p.product_id
