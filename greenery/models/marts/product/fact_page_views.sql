with events as (

    select 
        event_id,
        session_id,
        user_id,
        order_id,
        product_id,
        event_type,
        page_url,
        created_at
    from {{ ref('stg_postgres__events') }}
),

order_items as (

    select 
        order_id,
        product_id,
        quantity
    from {{ ref('stg_postgres__order_items') }}
   
),

session_timing_agg as (

    select 
        session_id,
        session_started_at,
        session_ended_at
    from {{ ref('int_session_timings') }}

)


select 
    e.session_id,
    e.user_id,
    coalesce(e.product_id, oi.product_id) as product_id,
    session_started_at,
    session_ended_at,
    sum(case when e.event_type = 'page_view' then 1 else 0 end) as page_views,
    sum(case when e.event_type = 'add_to_cart' then 1 else 0 end) as add_to_carts,
    sum(case when e.event_type = 'checkout' then 1 else 0 end) as checkouts,
    sum(case when e.event_type = 'package_shipped' then 1 else 0 end) as packages_shipped,
    datediff('minute', session_started_at, session_ended_at) as session_length_minutes
from events e 
left join order_items oi 
    on e.order_id = oi.order_id
left join session_timing_agg s
    on e.session_id = s.session_id
group by 1, 2, 3, 4, 5