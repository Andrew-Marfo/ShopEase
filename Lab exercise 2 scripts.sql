USE shop_ease;

CREATE TABLE IF NOT EXISTS orders(
	order_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL
);

CREATE TABLE IF NOT EXISTS products(
	product_id INT NOT NULL,
    product_name VARCHAR(50) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS customers(
	customer_id INT NOT NULL,
    customer_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
	join_date DATE NOT NULL
);

-- Lab Exercise 2.1
USE shop_ease;
SELECT *
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
JOIN products ON orders.product_id = products.product_id
ORDER BY orders.order_id;

-- Lab Exercise 2.2
USE shop_ease;
SELECT product_name, SUM(total_revenue) AS total_sales
FROM sales_data
WHERE year = (SELECT MAX(year) FROM sales_data)
  AND month = (SELECT MAX(month) FROM sales_data WHERE year = (SELECT MAX(year) FROM sales_data))
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 5;

-- Lab Exercise 2.3
USE shop_ease;
SELECT 
    order_id,
    customer_id,
    total_revenue,
    CASE 
        WHEN total_revenue > 1000 THEN 'High'
        WHEN total_revenue BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_category
FROM sales_data;

-- Lab Exercise 2.3

-- Analyzing and optimizing the Joins Operations query
USE shop_ease_new;

EXPLAIN ANALYZE SELECT *
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
JOIN products ON orders.product_id = products.product_id
ORDER BY orders.order_id;
 
 -- Index creation for optimization
CREATE INDEX idx_customers_customer_id ON customers(customer_id);
CREATE INDEX idx_orders_order_id ON orders(customer_id);
CREATE INDEX idx_product_id ON products(product_id);
CREATE INDEX idx_orders_product_id ON orders(product_id);
CREATE INDEX idx_order_id ON orders(order_id);

EXPLAIN ANALYZE SELECT *
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
JOIN products ON orders.product_id = products.product_id
ORDER BY orders.order_id;


-- Analyzing and optimizing the subqueries

EXPLAIN ANALYZE SELECT product_name, SUM(total_revenue) as total_sales
FROM sales_data
WHERE year = (SELECT MAX(year) FROM sales_data)
AND month = (SELECT MAX(month) FROM sales_data WHERE year = (SELECT MAX(year) FROM sales_data))
GROUP BY product_name 
ORDER BY total_sales DESC
LIMIT 5;

-- Index creation for optimization
CREATE INDEX idx_year_month ON sales_data(year, month);
CREATE INDEX idx_sales_data_product_name ON sales_data(product_name);
CREATE INDEX idx_total_revenue ON sales_data(total_revenue);

EXPLAIN ANALYZE SELECT product_name, SUM(total_revenue) as total_sales
FROM sales_data
WHERE year = (SELECT MAX(year) FROM sales_data)
AND month = (SELECT MAX(month) FROM sales_data WHERE year = (SELECT MAX(year) FROM sales_data))
GROUP BY product_name 
ORDER BY total_sales DESC
LIMIT 5;

-- Analyzing and optimizing Case statements
EXPLAIN ANALYZE SELECT 
    order_id,
    customer_id,
    total_revenue,
    CASE 
        WHEN total_revenue > 1000 THEN 'High'
        WHEN total_revenue BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_category
FROM sales_data;

-- -- Index creation for optimization
CREATE INDEX idx_order_id_customer_id_total_revenue ON sales_data(order_id, customer_id, total_revenue);

EXPLAIN ANALYZE SELECT 
    order_id,
    customer_id,
    total_revenue,
    CASE 
        WHEN total_revenue > 1000 THEN 'High'
        WHEN total_revenue BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_category
FROM sales_data;



