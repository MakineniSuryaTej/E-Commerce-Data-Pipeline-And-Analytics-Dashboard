with customer_orders as (
    select * from {{ ref('int_customer_orders') }}
),

final as (
    select
        customer_id,
        unique_id,
        city,
        state,
        count(distinct order_id) as number_of_orders,
        min(order_purchase_timestamp) as first_order_date,
        max(order_purchase_timestamp) as most_recent_order_date,
        sum(case when order_status = 'delivered' then 1 else 0 end) as number_of_delivered_orders
    from customer_orders
    group by 1, 2, 3, 4
)

select * from final 