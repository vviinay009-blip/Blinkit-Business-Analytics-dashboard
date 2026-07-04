CREATE DATABASE `blinkit` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
CREATE TABLE `blinkit_customer_feedback` (
  `feedback_id` varchar(30) DEFAULT NULL,
  `order_id` varchar(30) DEFAULT NULL,
  `customer_id` varchar(30) DEFAULT NULL,
  `rating` int DEFAULT NULL,
  `feedback_text` varchar(100) DEFAULT NULL,
  `feedback_category` varchar(20) DEFAULT NULL,
  `sentiment` varchar(20) DEFAULT NULL,
  `feedback_date` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `blinkit_customers` (
  `customer_id` text,
  `customer_name` text,
  `email` text,
  `phone` text,
  `address` text,
  `area` text,
  `pincode` int DEFAULT NULL,
  `registration_date` text,
  `customer_segment` text,
  `total_orders` int DEFAULT NULL,
  `avg_order_value` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `blinkit_delivery_performance` (
  `order_id` text,
  `delivery_partner_id` text,
  `promised_time` datetime DEFAULT NULL,
  `actual_time` datetime DEFAULT NULL,
  `delivery_time_minutes` double DEFAULT NULL,
  `distance_km` double DEFAULT NULL,
  `delivery_status` text,
  `reasons_if_delayed` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `blinkit_inventory` (
  `product_id` varchar(30) DEFAULT NULL,
  `date` varchar(20) DEFAULT NULL,
  `stock_received` int DEFAULT NULL,
  `damaged_stock` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `blinkit_marketing_performance` (
  `campaign_id` text,
  `campaign_name` text,
  `date` text,
  `target_audience` text,
  `channel` text,
  `impressions` int DEFAULT NULL,
  `clicks` int DEFAULT NULL,
  `conversions` int DEFAULT NULL,
  `spend` double DEFAULT NULL,
  `revenue_generated` double DEFAULT NULL,
  `roas` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `blinkit_order_items` (
  `order_id` text,
  `product_id` text,
  `quantity` int DEFAULT NULL,
  `unit_price` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `blinkit_orders` (
  `order_id` text,
  `customer_id` text,
  `order_date` datetime DEFAULT NULL,
  `promised_delivery_time` datetime DEFAULT NULL,
  `actual_delivery_time` datetime DEFAULT NULL,
  `delivery_status` text,
  `order_total` double DEFAULT NULL,
  `payment_method` text,
  `delivery_partner_id` text,
  `store_id` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `blinkit_products` (
  `product_id` text,
  `product_name` text,
  `category` text,
  `brand` text,
  `price` double DEFAULT NULL,
  `mrp` double DEFAULT NULL,
  `margin_percentage` double DEFAULT NULL,
  `shelf_life_days` int DEFAULT NULL,
  `min_stock_level` int DEFAULT NULL,
  `max_stock_level` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
