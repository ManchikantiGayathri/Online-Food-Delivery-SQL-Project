-- create database
create database online_food_delivery;
use online_food_delivery;

create table customers(
customer_id int primary key,
customer_name varchar(50),
email varchar(60),
city varchar(60),
signup_date date
);

create table restaurent(
restaurent_id int primary key,
rest_name varchar(60),
city varchar(60),
reg_date date
);

create table menu_item(
item_id int primary key,
restaurent_id int,
item_name varchar(20),
price decimal(10,2),
constraint fk_menu_rest
foreign key (restaurent_id)
references restaurent (restaurent_id)
);

-- DAY 1

create table orders(
order_id int primary key,
customer_id int,
restaurent_id int,
order_date date,
total_amount decimal(10,2),
order_status varchar(50),
constraint fk_orders_customer
foreign key (customer_id)
references customers (customer_id),
constraint fk_orders_rest
foreign key (restaurent_id)
references restaurent (restaurent_id)
);

create table order_details(
order_detail_id int primary key,
order_id int,
item_id int,
quantity int,
price decimal(10,2), -- Price of the item at the time of order
constraint fk_order_details_order
foreign key (order_id)
references orders (order_id),
constraint fk_order_details_item
foreign key (item_id)
references menu_item (item_id)
);

select item_name,price 
from menu_item
where price>300;

select item_name,price 
from menu_item
order by price asc
limit 5;

-- DAY 2

-- 1.List all restaurants located in Delhi

SELECT rest_name
FROM restaurent
WHERE city = 'Delhi';

-- 2.Show the top 3 most expensive menu items:

SELECT item_name, price
FROM menu_item
ORDER BY price DESC
LIMIT 3;

 -- 3.List all order IDs where quantity is greater than 2
 
 SELECT DISTINCT order_id
FROM order_details
WHERE quantity > 2;

-- DAY 3

 -- 1.List all customers along with their city who placed an order on or after '2023-01-01':

SELECT DISTINCT c.customer_name, c.city
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2023-01-01';

-- 2.Show restaurant names and order IDs for orders placed from restaurants in Mumbai:

SELECT r.rest_name, o.order_id
FROM restaurent r
JOIN orders o ON r.restaurent_id = o.restaurent_id
WHERE r.city = 'Mumbai';

-- 3.Customers who have ordered from a specific restaurant - ‘Spice Villa’:

SELECT DISTINCT c.customer_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN restaurent r ON o.restaurent_id = r.restaurent_id
WHERE r.rest_name = 'Spice Villa';

select count(o.order_id),c.customer_name
from customers c 
join orders o on
c.customer_id = o.customer_id
group by customer_name;

select sum(m.price*od.quantity) as total_revenue,r.city
from restaurent r
join menu_item m on r.restaurent_id = m.restaurent_id
join order_details od on od.item_id = m.item_id
group by r.city;

-- DAY 4

-- 1. Find the total number of times each food item was ordered:

SELECT mi.item_name, SUM(od.quantity) AS total_times_ordered
FROM order_details od
JOIN menu_item mi ON od.item_id = mi.item_id
GROUP BY mi.item_name
ORDER BY total_times_ordered DESC;

-- 2. Calculate the average order value for each customer city:

SELECT c.city, AVG(o.total_amount) AS average_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.city;

-- 3. Find how many different food items were ordered per restaurant:

SELECT r.rest_name, COUNT(DISTINCT od.item_id) AS number_of_different_items_ordered
FROM restaurent r
JOIN orders o ON r.restaurent_id = o.restaurent_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY r.rest_name
ORDER BY number_of_different_items_ordered DESC;

-- DAY 5

-- 1. List customers who placed more than 3 orders:

SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 3;

-- 2. Display menu items that were ordered more than 2 times:

SELECT mi.item_name, SUM(od.quantity) AS total_times_ordered
FROM menu_item mi
JOIN order_details od ON mi.item_id = od.item_id
GROUP BY mi.item_name
HAVING SUM(od.quantity) > 2;

-- 3. Find restaurants where the average item price is greater than ₹300:

SELECT r.rest_name, AVG(mi.price) AS average_item_price
FROM restaurent r
JOIN menu_item mi ON r.restaurent_id = mi.restaurent_id
GROUP BY r.rest_name
HAVING AVG(mi.price) > 300;

-- DAY 6

-- 1. Show each food item and how much more it costs than the average:

SELECT
    item_name,
    price,
    price - (SELECT AVG(price) FROM menu_item) AS price_difference_from_average
FROM
    menu_item;

-- 2. List food items that cost more than the average price:

SELECT
    item_name,
    price
FROM
    menu_item
WHERE
    price > (SELECT AVG(price) FROM menu_item);

-- 3. Show customers who haven’t placed any orders:

SELECT
    customer_id,
    customer_name
FROM
    customers
WHERE
    customer_id NOT IN (SELECT DISTINCT customer_id FROM orders);
    
-- DAY 7

-- total orders per city

SELECT
    r.city,
    COUNT(o.order_id) AS total_orders
FROM
    orders o
JOIN
    restaurent r ON o.restaurent_id = r.restaurent_id
GROUP BY
    city
ORDER BY
    total_orders DESC;

-- revenue generated by each food item

select m.item_name,sum(m.price*od.quantity) as total_revenue
from menu_item m
join order_details od on 
m.item_id=od.item_id
group by m.item_name
order by total_revenue desc;

-- 1. Top 5 Spending Customers:

SELECT
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS total_spent
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id, c.customer_name
ORDER BY
    total_spent DESC
LIMIT 5;

-- 2. Restaurant-wise Order Count:

SELECT
    r.rest_name,
    COUNT(o.order_id) AS order_count
FROM
    restaurent r
LEFT JOIN
    orders o ON r.restaurent_id = o.restaurent_id
GROUP BY
    r.rest_name
ORDER BY
    order_count DESC;

-- 3. Average Order Value by City:

SELECT
    c.city,
    AVG(o.total_amount) AS average_order_value
FROM
    customers c
JOIN
    orders o ON c.customer_id = o.customer_id
GROUP BY
    c.city
ORDER BY
    average_order_value DESC;
    
-- DAY 8

-- monthly order trends

select month(order_date) as month_number, monthname(order_date) as order_month, count(order_id) as total_orders
from orders
group by month(order_date), monthname(order_date)
order by month_number;

-- top 3 cities by revenue 

select c.city,sum(m.price*od.quantity) as total_revenue
from customers c
join orders o on c.customer_id=o.customer_id
join order_details od on o.order_id=od.order_id
join menu_item m on od.item_id=m.item_id
group by c.city
order by total_revenue desc
limit 3;

-- 1. Number of Unique Customers Per City:

SELECT
    city,
    COUNT(DISTINCT customer_id) AS unique_customer_count
FROM
    customers
GROUP BY
    city
ORDER BY
    unique_customer_count DESC;

-- 2. Most Frequently Ordered Items:

SELECT
    mi.item_name,
    SUM(od.quantity) AS total_quantity_ordered
FROM
    menu_item mi
JOIN
    order_details od ON mi.item_id = od.item_id
GROUP BY
    mi.item_name
ORDER BY
    total_quantity_ordered DESC
LIMIT 1;

-- 3. Restaurants with Low Order Counts (less than 30):

SELECT
    r.rest_name,
    COUNT(o.order_id) AS order_count
FROM
    restaurent r
LEFT JOIN
    orders o ON r.restaurent_id = o.restaurent_id
GROUP BYs
    r.rest_name
HAVING
    COUNT(o.order_id) < 30
ORDER BY
    order_count DESC;select r.city, count(o.order_id) as total_orders from orders o join restaurant r on o.restaurant_id= r.restaurant_id group by city order by total_orders desc LIMIT 0, 50000
