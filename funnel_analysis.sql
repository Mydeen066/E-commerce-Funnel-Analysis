SELECT * FROM user_events;

SELECT DISTINCT COUNT(user_id) AS users FROM user_events;

SELECT event_type, COUNT(DISTINCT user_id) AS users  FROM user_events GROUP BY event_type ORDER BY users DESC;

-- funnel stages, conversion rate
WITH stages AS(
SELECT 

	COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS cart,
    COUNT(DISTINCT CASE WHEN event_type = 'checkout_start' THEN user_id END) AS checkout,
    COUNT(DISTINCT CASE WHEN event_type = 'payment_info' THEN user_id END) AS payment,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchase
FROM user_events
)
SELECT 
	views,
    ROUND(cart * 100 / views) AS views_to_cart_rate,
    ROUND(checkout * 100 / cart) AS cart_to_checkout_rate,
    ROUND(payment * 100 / checkout) AS checkout_to_payment_rate,
    ROUND(purchase * 100 / payment) AS payment_to_purchase_rate,
    ROUND(purchase * 100 / views) AS overall_rate
FROM stages ;

-- conversion rate by source
    
WITH sources AS(
SELECT 
	traffic_source,
	COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS views,
    COUNT(DISTINCT CASE WHEN event_type = 'add_to_cart' THEN user_id END) AS cart,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS purchase
FROM user_events GROUP BY traffic_source
)

SELECT 
	traffic_source,
	views,
    ROUND(cart * 100 / views) AS views_to_cart_rate,
    ROUND(purchase * 100 / cart) AS cart_to_purchase_rate,
    ROUND(purchase * 100 / views) AS purchase_conversion_rate
FROM sources ORDER BY purchase_conversion_rate DESC;


-- user journey analysis

WITH user_journey AS(
SELECT 
	user_id,
    MIN(CASE WHEN event_type = 'page_view' THEN event_date END) AS view_time,
    MIN(CASE WHEN event_type = 'add_to_cart' THEN event_date END) AS cart_time,
    MIN(CASE WHEN event_type = 'purchase' THEN event_date END) AS purchase_time
FROM user_events
GROUP BY user_id 
HAVING MIN(CASE WHEN event_type = 'purchase' THEN event_date END) IS NOT NULL
)

SELECT 
	COUNT(user_id) AS users,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, view_time, cart_time)),2) AS avg_view_to_cart_minutes,
	ROUND(AVG(TIMESTAMPDIFF(MINUTE, cart_time, purchase_time)),2) AS avg_cart_to_purchase_minutes,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE, view_time, purchase_time)),2) AS avg_total_minutes
FROM user_journey;

-- funnel revenue analysis

WITH revenue AS(
SELECT 
	COUNT(DISTINCT CASE WHEN event_type = 'page_view' THEN user_id END) AS visitors,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN user_id END) AS total_buyers,
    ROUND(SUM(CASE WHEN event_type = 'purchase' THEN amount END), 2) AS total_revenue,
    SUM(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_orders

FROM user_events
)

SELECT
	visitors,
    total_buyers,
    total_revenue,
    total_orders,
    ROUND(total_revenue / total_buyers, 2) AS revenue_per_buyer,
    ROUND(total_revenue / total_orders, 2) AS avg_order_value,
    ROUND(total_revenue / visitors, 2) AS revenue_per_visitor
FROM revenue;




    
    
