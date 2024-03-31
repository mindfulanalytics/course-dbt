# Week 2 Project

## What is our user repeat rate?

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
