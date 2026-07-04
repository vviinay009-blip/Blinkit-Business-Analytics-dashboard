/* 
================================
CUSTOMER SATISFACTION ANALYSIS
================================ */

-- CUSTOMER RATING DISTRIBUTION

SELECT rating, COUNT(*) AS rating_distribution FROM blinkit_customer_feedback
GROUP BY rating
ORDER BY rating DESC;

-- FEEDBACK CATEGORY DISTRIBUTION

SELECT feedback_category, COUNT(*) AS feedback_category_distribution
FROM blinkit_customer_feedback
GROUP BY feedback_category;

-- CUSTOMER SATISFACTION BY SEGMENT
SELECT customer_segment, sentiment, COUNT(*) AS `no. of customers`
FROM blinkit_customers c
INNER JOIN
blinkit_customer_feedback f ON
c.customer_id = f.customer_id
GROUP BY customer_segment, sentiment
ORDER BY customer_segment, sentiment;

/*
=====================================
CUSTOMER AND SALES ANALYSIS
===================================== */

-- ORDERS BY CUSTOMER SEGMENT
SELECT customer_segment, SUM(total_orders) AS total_orders
FROM blinkit_customers
GROUP BY customer_segment;

-- AVG ORDER VALUE BY SEGMENT
SELECT customer_segment, ROUND(AVG(avg_order_value),2) AS avg_order_value
FROM blinkit_customers
GROUP BY customer_segment;

-- REVENUE DISTRIBUTION BY SEGMENT
SELECT customer_segment, ROUND(SUM(order_total),2) AS revenue, DENSE_RANK() OVER (ORDER BY SUM(order_total) DESC) AS rnk
FROM blinkit_customers c
LEFT JOIN
blinkit_orders o ON
c.customer_id = o.customer_id
GROUP BY customer_segment;

/*
=======================
GEOGRAPHIC ANALYSIS
=======================*/

-- TOP 10 AREAS BY NUMBER OF ORDERS
SELECT area, SUM(total_orders) AS total_orders
FROM blinkit_customers
GROUP BY area
ORDER BY total_orders DESC
LIMIT 10;

-- BOTTOM 10 AREAS BY NUMBER OF ORDERS
SELECT area, SUM(total_orders) AS total_orders
FROM blinkit_customers
GROUP BY area
ORDER BY total_orders
LIMIT 10;

-- AREA GENERATING HIGHEST REVENUE
WITH CTE AS(
SELECT Area, ROUND(SUM(order_total),2) AS total_revenue, DENSE_RANK() OVER (ORDER BY ROUND(SUM(order_total),2) DESC) AS rnk
FROM blinkit_customers C
INNER JOIN 
blinkit_orders O ON
c.customer_id = o.customer_id
GROUP BY area
ORDER BY total_revenue DESC)
SELECT *
FROM CTE
WHERE rnk = 1;

/*
=============================== 
DELIVERY PERFORMANCE ANALYSIS
===============================*/

-- DELIVERY STATUS ACROSS TIME SLOTS
SELECT 
	CASE
		WHEN HOUR(actual_time) BETWEEN 6 AND 11 THEN 'MORNING'
        WHEN HOUR(actual_time) BETWEEN 12 AND 16 THEN 'AFTERNOON'
        WHEN HOUR(actual_time) BETWEEN 17 AND 21 THEN 'EVENING'
        ELSE 'NIGHT'
        END AS time_slot,
delivery_status,
COUNT(*) AS total_deliveries
FROM blinkit_delivery_performance
GROUP BY delivery_status, time_slot
ORDER BY FIELD(time_slot, 'MORNING', 'AFTERNOON', 'EVENING', 'NIGHT'),
total_deliveries;

-- DELIVERY STATUS DISTRIBUTION
SELECT delivery_status, COUNT(*) AS total_deliveries
FROM blinkit_delivery_performance
GROUP BY delivery_status;

-- DELIVERY FEEDBACK VS DELIVERY STATUS
WITH CTE AS (
SELECT feedback_category, sentiment, delivery_status
FROM blinkit_customer_feedback f
INNER JOIN
blinkit_delivery_performance d ON
f.order_id = d.order_id
WHERE feedback_category = 'delivery' AND sentiment = 'negative')
SELECT COUNT(feedback_category) AS `negative delivery feedbacks`, delivery_status
FROM CTE
GROUP BY delivery_status;

/* 
=============================
INVENTORY ANALYSIS
=============================*/

-- INVENTORY RECEIVED VS DAMAGED STOCK
SELECT 
	YEAR(STR_TO_DATE(`date`, '%d-%m-%Y')) AS `year`,
    SUM(stock_received) AS total_stock_received, SUM(damaged_stock) AS total_damaged_stock,
    ROUND(SUM(damaged_stock)/SUM(stock_received),2) AS `percentage of damaged stock`
FROM blinkit_inventory
GROUP BY `year`;
SELECT * FROM blinkit_marketing_performance;

/*
============================
MARKETING CAMPAIGN ANALYSIS
============================*/

-- BEST CAMPAIGN BY CUSTOMER SEGMENT (TOP 5)
WITH CTE AS (
SELECT 
	target_audience, campaign_name,`channel`, 
	ROUND(SUM(revenue_generated),2) AS total_revenue,
    ROUND(SUM(spend),2) AS total_spend, 
    ROUND(SUM(revenue_generated)/SUM(spend),2) AS roas,
    DENSE_RANK() OVER (PARTITION BY target_audience ORDER BY ROUND(SUM(revenue_generated)/SUM(spend),2)DESC) AS `campaign_rank`
FROM blinkit_marketing_performance
GROUP BY target_audience, channel, campaign_name
ORDER BY target_audience, roas desc)
SELECT 
target_audience, 
campaign_name, 
`channel`,
total_revenue, 
total_spend, roas, 
`campaign_rank`
FROM CTE
WHERE `campaign_rank` <= 5;

-- BEST MARKETING CHANNEL FOR EACH CAMPAIGN
WITH CTE AS (
SELECT 
	campaign_name,
    `channel`,
    ROUND(SUM(revenue_generated),2) AS total_revenue,
    ROUND(SUM(spend),2) AS total_spend, 
    ROUND(SUM(revenue_generated)/SUM(spend),2) AS roas,
    DENSE_RANK() OVER (PARTITION BY `campaign_name` ORDER BY ROUND(SUM(revenue_generated)/SUM(spend),2)DESC) AS `campaign_rank`
FROM blinkit_marketing_performance 
GROUP BY campaign_name, `channel`)
SELECT 
`channel`,
campaign_name,
total_revenue,
total_spend,
roas,
`campaign_rank`
FROM CTE
WHERE campaign_rank = 1;

/*
==================
PAYMENT ANALYSIS
==================*/

-- PAYMENT METHOD USAGE
SELECT payment_method, COUNT(*) AS customer_usage
FROM blinkit_orders
GROUP BY payment_method;

/* 
=========================
PRODUCT ANALYSIS
=========================*/

-- TOP 5 SELLING PRODUCTS BY CATEGORY
WITH CTE AS (
SELECT product_name ,category, 
brand, 
SUM(quantity) as quantity_sold,
DENSE_RANK() OVER (PARTITION BY category ORDER BY SUM(quantity)DESC) as rnk
FROM blinkit_products p
INNER JOIN 
blinkit_order_items o ON
p.product_id = o.product_id
GROUP BY category,brand, product_name)
SELECT 
category,
product_name, 
brand,
quantity_sold,
rnk
FROM CTE
WHERE rnk <= 5 ; 













