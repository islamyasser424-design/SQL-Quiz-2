-- =============================================================================
-- SQL QUIZ 02: INTERMEDIATE RELATIONAL QUERIES, JOINS & HAVING AGGREGATIONS
-- Customer Segmentation, Category Stock Auditing, Order Status Pipelines
-- Author: Islam Yasser (Data Analyst & BI Specialist)
-- Target RDBMS: MySQL 8.0+
-- Database: online_store
-- =============================================================================

USE online_store;

-- =============================================================================
-- SECTION 1: CUSTOMER PREFIX FILTERING
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q1: Display all customers whose names start with the letter 'A'.
-- Concept: Case-insensitive character prefix matching using LIKE wildcard.
-- Business Application: Targeted alphabetical marketing campaigns and CRM lookup.
-- -----------------------------------------------------------------------------
SELECT 
    customer_id,
    full_name,
    email,
    city,
    joined_at
FROM customers
WHERE full_name LIKE 'A%'
ORDER BY full_name ASC;

-- =============================================================================
-- SECTION 2: RELATIONAL INNER JOINS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q2: Display all products that belong to the 'Electronics' category.
-- Concept: Two-table INNER JOIN on surrogate foreign key catgory_id.
-- Business Application: Category merchandising views and departmental stock lists.
-- -----------------------------------------------------------------------------
SELECT 
    p.product_id,
    p.product_name,
    p.price,
    p.stock,
    cat.catgory_name AS category_name
FROM products p
INNER JOIN catgories cat 
    ON p.catgory_id = cat.catgory_id
WHERE cat.catgory_name = 'Electronics'
ORDER BY p.price DESC;

-- =============================================================================
-- SECTION 3: GROUP BY OPERATIONAL AGGREGATIONS
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q3: Display the total number of orders for each order fulfillment status.
-- Concept: Categorical aggregation using COUNT() with GROUP BY.
-- Business Application: Supply chain bottleneck monitoring (Pending vs Shipped vs Delivered).
-- -----------------------------------------------------------------------------
SELECT 
    status,
    COUNT(order_id) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;

-- -----------------------------------------------------------------------------
-- Q4: Display the total stock available across each product category.
-- Concept: Aggregation over relational join using SUM(stock).
-- Business Application: Warehouse capacity planning and category inventory depth assessment.
-- -----------------------------------------------------------------------------
SELECT 
    cat.catgory_id,
    cat.catgory_name AS category_name,
    SUM(p.stock) AS total_available_stock
FROM products p
INNER JOIN catgories cat 
    ON p.catgory_id = cat.catgory_id
GROUP BY cat.catgory_id, cat.catgory_name
ORDER BY total_available_stock DESC;

-- =============================================================================
-- SECTION 4: POST-AGGREGATION FILTERING (HAVING CLAUSE)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Q5: Display customers who have purchased more than 2 items in total.
-- Concept: Multi-table aggregation with post-grouping filter using HAVING SUM() > 2.
-- Business Application: VIP / Repeat customer segmentation for retention programs.
-- -----------------------------------------------------------------------------
SELECT 
    c.customer_id,
    c.full_name,
    c.city,
    SUM(o.quantity) AS total_items_purchased
FROM customers c
INNER JOIN orders o 
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name, c.city
HAVING SUM(o.quantity) > 2
ORDER BY total_items_purchased DESC;
