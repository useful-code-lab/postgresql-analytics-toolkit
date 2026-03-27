WITH monthly_users AS (
    SELECT 
        DISTINCT customer_email,
        DATE_TRUNC('month', created_at) AS active_month
    FROM orders
)
SELECT 
    prev.active_month AS cohort_month,
    COUNT(prev.customer_email) AS total_customers,
    COUNT(curr.customer_email) AS returned_customers,
    ROUND(COUNT(curr.customer_email)::numeric / COUNT(prev.customer_email) * 100, 2) AS retention_pct
FROM monthly_users prev
LEFT JOIN monthly_users curr ON 
    prev.customer_email = curr.customer_email AND 
    curr.active_month = prev.active_month + INTERVAL '1 month' 
GROUP BY 1
ORDER BY 1;


WITH product_revenue AS (
    SELECT 
        title,
        SUM(price) as total_sales
    FROM products
    JOIN orders ON items @> jsonb_build_array(jsonb_build_object('p_id', products.id))
    GROUP BY title
),
running_sales AS (
    SELECT 
        title,
        total_sales,
        SUM(total_sales) OVER(ORDER BY total_sales DESC) / SUM(total_sales) OVER() as cumulative_share
    FROM product_revenue
)
SELECT 
    title,
    total_sales,
    CASE 
        WHEN cumulative_share <= 0.80 THEN 'A (High Value)'
        WHEN cumulative_share <= 0.95 THEN 'B (Medium)'
        ELSE 'C (Low Value)'
    END as abc_category
FROM running_sales;


SELECT 
    category_id,
    JSONB_AGG(
        JSONB_BUILD_OBJECT('name', title, 'price', price) 
        ORDER BY price DESC
    ) FILTER (WHERE price > 1000) AS premium_items
FROM products
GROUP BY category_id
HAVING COUNT(*) > 1;



