-- Задача: Найти "преданных" клиентов, которые совершали покупки 2 месяца подряд
WITH monthly_activity AS (
    SELECT 
        customer_email,
        DATE_TRUNC('month', created_at) as order_month
    FROM orders
    GROUP BY 1, 2
)
SELECT 
    curr.customer_email,
    curr.order_month as second_month
FROM monthly_activity curr
JOIN monthly_activity prev ON 
    curr.customer_email = prev.customer_email AND 
    curr.order_month = prev.order_month + INTERVAL '1 month'
ORDER BY 2 DESC;
