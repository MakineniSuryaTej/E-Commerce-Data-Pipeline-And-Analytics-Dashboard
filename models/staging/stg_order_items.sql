with source as (
    select * from {{ source('raw', 'ORDER_ITEMS') }}
),

renamed as (
    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        shipping_limit_date,
        price,
        freight_value
    from source
)

select * from renamed 