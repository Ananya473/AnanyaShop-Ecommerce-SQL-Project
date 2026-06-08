-- SELECT * FROM customers;
-- SELECT * FROM order_items;
-- SELECT * FROM orders;
-- SELECT * FROM payments;
-- SELECT * FROM products;
-- Total Revenue
SELECT SUM(amount) AS total_revenue
FROM payments;

-- revenue by product
SELECT p.product_name,
       SUM(oi.quantity * p.price) AS revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY p.product_name
ORDER BY revenue DESC;

-- Top Customers by Spend
SELECT c.name,
       SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.name
ORDER BY total_spent DESC;

-- Best Selling Products
SELECT p.product_name,
       SUM(oi.quantity) AS total_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

-- Cancelled Orders Count
SELECT COUNT(*) AS cancelled_orders
FROM orders
WHERE order_status = 'Cancelled';

-- Revenue by City
SELECT c.city,
       SUM(p.amount) AS revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN payments p ON o.order_id = p.order_id
GROUP BY c.city
ORDER BY revenue DESC;

-- Revenue by Product Category
SELECT pr.category,
       SUM(oi.quantity * pr.price) AS revenue
FROM order_items oi
JOIN products pr ON oi.product_id = pr.product_id
JOIN orders o ON oi.order_id = o.order_id
WHERE o.order_status = 'Delivered'
GROUP BY pr.category
ORDER BY revenue DESC;

-- Average Order Value (AOV)
SELECT ROUND(AVG(amount),2) AS avg_order_value
FROM payments;

-- Most Popular Payment Method
SELECT payment_mode,
       COUNT(*) AS total_transactions
FROM payments
GROUP BY payment_mode
ORDER BY total_transactions DESC;

-- Monthly Revenue Trend
SELECT MONTH(payment_date) AS month,
       SUM(amount) AS revenue
FROM payments
GROUP BY MONTH(payment_date)
ORDER BY month;

-- Customers with Highest Number of Orders
SELECT c.name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY total_orders DESC;

-- Products Never Ordered
SELECT product_name
FROM products
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM order_items
);

-- Top 5 Revenue Generating Products
SELECT p.product_name,
       SUM(oi.quantity * p.price) AS revenue
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;