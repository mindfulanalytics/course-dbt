# Week 2 Project

## What is our user repeat rate?

Our user repeat rate, defined as total users with 2+ order divided by total users with 1+ orders, is 80%.

``` 
with cte as (

select 
    user_id,
    count(*) as total_purchases
from dev_db.dbt_diegomindfulanalyticsgmailcom.stg_postgres__orders
group by 1

)

select 
    count(
        case 
            when total_purchases >= 2 then user_id
           else null
        end
    )as numerator,
    count(user_id) as total_users,
    round( count(
        case 
            when total_purchases >= 2 then user_id
            else null
        end
    ) / count(user_id) 
    , 2) as repeat_rate
from cte

```

### What are good indicators of a user who will likely purchase again? What about indicators of users who are likely NOT to purchase again? If you had more data, what features would you want to look into to answer this question?

Leading indicators that come to mind include:
| Leading Indicator Name      | Why? Reasoning                                                                                                                                   | How?                                                                                                                                    |
|-----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| Order history               | User's who have placed multiple orders in the  past are more likely to place more orders.                                                        | select      user_id, Count(*)  from orders  group by 1                                                                                  |
| Product Category Preference | User's past product preference could be a  leading indicator for repeat purchases. If  they have bough roses before, they might  buy them again. | select      order_id,     product_id,     user_id,     sum(quantity) from orders left join order_items left join users group by 1, 2, 3 |
| User's Avg Order Size       | User's who have placed big orders, are  more likely to purchase again.                                                                           | select      order_id,     user_id,     avg(order_cost) from orders group by 1, 2                                                        |


## Explain the product mart models you added. WHy did you organize the models in the wayu you did?

I created three mart folders:
- core
- marketing
-users

The core mart folder contains our main models, including dim_products, dim_users, and fact_orders. While our marketing mart contains the fact_user_orders table. A wide table that marketing can use to identify users who have visited the website and segment them based on is_buyer, is_frequent_buyer fields, and other fields. Finally, we have the product mart, that contains the fact_page_views table that shows how user's product session converts from page_view, to add_to_cart, to checkout, and finally to packages_shipped. This informs how well products are converting on our website.

Each mart serves a different audience and purpose. This way, our stakeholders are not overwhelmed by the number of potential models available to them, and they can focus on their use case.

## What assumptions are you making about each model? why are you adding each test? Did you find any"bad" data?

Most of the tests I added where on a few stg_models. This is a part of my project I need to invest more time into, but I have not put in the effort to apply testing comprehensively yet.

## Did you find any"bad" data? How did you go about either cleaning it or adjusting your assumptions/tests?

I have not run into any "bad data" yet. As I implement more tests, I likely will. I would either have to reach out to the owner of the source system if I am capturing bad data at stg. If I am capturing bad data in my final models, I would then have to either refactor my code so the tests pass or change my assumptions.

## How would you ensure these tests are passing regularly and how would you alert stakeholders about bad data getting through?
I would ensure tests are passing regularly by scheduling tests to run daily before models are built on their daily schedule. I would receive a "test fail" notification via email or slack. Once I get an alert, I would be proactive in regards to addressing it and communicating with stakeholders the next steps required to fix it.

## Which products had their inventory change from week 1 to week 2?

4 products had inventory changes from week 1 to week 2:
- Photos, from 40 to 20
- Philodendron, from 51 to 25
- Monstera, from 77 to 64
- String of pearls, from 58 to 10

``` 
select 
    * 
from dev_db.dbt_diegomindfulanalyticsgmailcom.products_snapshot 
where product_id in ('4cda01b9-62e2-46c5-830f-b7f262a58fb1', '55c6a062-5f4a-4a8b-a8e5-05ea5e6715a3',
    'be49171b-9f72-4fc9-bf7a-9a52e259836b', 'fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80')
order by 2 asc 

```