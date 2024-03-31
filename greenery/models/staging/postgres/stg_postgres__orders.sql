select 
    ----------    ids
    ORDER_ID, 
    USER_ID, 
    PROMO_ID, 
    ADDRESS_ID, 
    TRACKING_ID,
    ----------    strings
    STATUS as ORDER_STATUS,
    SHIPPING_SERVICE, 
    ----------    numerics
    ORDER_COST, 
    SHIPPING_COST, 
    ORDER_TOTAL, 
    ----------    booleans
    ----------    timestamps
    CREATED_AT, 
    ESTIMATED_DELIVERY_AT, 
    DELIVERED_AT
from {{ source('postgres', 'orders') }}