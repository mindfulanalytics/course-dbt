with users as (

    select * from {{ ref('stg_postgres__users') }}

),


addresses as (

    select * from {{ ref('stg_postgres__addresses') }}

),

int_user_orders as (

    select * from {{ ref('int_user_orders') }}

)

select 
    u.user_id,
    u.address_id,
    first_name,
    last_name,
    full_name,
    email,
    phone_number,
    address as user_address,
    zipcode as user_zipcode,
    state as user_state,
    country as user_country,
    total_spend,
    total_orders,
    created_at,
    updated_at,
    first_order_created_at,
    last_order_created_at
from users u 
left join addresses a 
    on u.address_id = a.address_id
left join int_user_orders iuo 
    on u.user_id = iuo.user_id