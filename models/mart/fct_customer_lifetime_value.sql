with customer_orders as (
    select * from {{ ref('fct_customer_orders') }}
),

int_customer_orders as (
    select * from {{ ref('int_customer_orders') }}
),

order_items as (
    select * from {{ ref('int_order_items_products') }}
),

customer_order_values as (
    select
        co.customer_id,
        co.unique_id,
        co.city,
        co.state,
        co.number_of_orders,
        co.number_of_delivered_orders,
        co.first_order_date,
        co.most_recent_order_date,
        sum(oi.price) as total_order_value
    from customer_orders co
    left join int_customer_orders ico on co.customer_id = ico.customer_id
    left join order_items oi on ico.order_id = oi.order_id
    group by 1, 2, 3, 4, 5, 6, 7, 8
),

customer_value as (
    select
        customer_id,
        unique_id,
        city,
        state,
        number_of_orders,
        number_of_delivered_orders,
        total_order_value,
        total_order_value / nullif(number_of_orders, 0) as average_order_value,
        datediff('day', first_order_date, most_recent_order_date) as customer_lifetime_days,
        total_order_value / nullif(datediff('day', first_order_date, current_date()), 0) as daily_customer_value
    from customer_order_values
),

final as (
    select
        *,
        daily_customer_value * 365 as annual_customer_value,
        daily_customer_value * 365 * 3 as predicted_customer_lifetime_value  -- Assuming 3 years as the prediction window
    from customer_value
)

select * from final 