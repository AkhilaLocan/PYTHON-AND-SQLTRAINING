SQL Join Types

- **INNER JOIN** – returns only rows with matching keys in both tables.
- **LEFT JOIN** – all rows from left table + matching rows from right; non‑matches get NULL.
- **RIGHT JOIN** – all rows from right table + matching rows from left; non‑matches get NULL.
- **FULL OUTER JOIN** – all rows from both tables; use UNION in MySQL to simulate.
- **CROSS JOIN** – Cartesian product of every row from each table.
- **SELF JOIN** – a table joined to itself to relate rows within the same entity.

-- INNER JOIN--

SELECT f.title, l.name AS language
FROM sakila.film f
INNER JOIN sakila.language l ON f.language_id = l.language_id;

-- Returns only films that have a matching language_id in the language table.
   You get each film title along with the language name (matched rows only).

-- SELECT f.title, l.name AS language
-- FROM sakila.film f
-- INNER JOIN sakila.language l ON f.language_id = l.language_id;

-- Show each payment with the customer name.
SELECT p.payment_id, p.amount, p.payment_date, c.first_name, c.last_name
FROM payment p
INNER JOIN customer c ON p.customer_id = c.customer_id
LIMIT 10;

-- Returns only payments that belong to an existing customer_id in the customer table.
   Shows payment details + customer first/last name; LIMIT 10 shows only 10 rows.

-- LEFT JOIN -- 

SELECT f.title, c.name AS category
FROM sakila.film f
LEFT JOIN sakila.film_category fc ON f.film_id = fc.film_id
LEFT JOIN sakila.category c ON fc.category_id = c.category_id;

-- Returns all films, even if a film has no category.
   If no match exists in film_category/category, the category column becomes NULL.


SELECT c.customer_id, c.first_name, r.rental_id
FROM sakila.customer c
LEFT JOIN sakila.rental r ON c.customer_id = r.customer_id;

-- Returns all customers, even if they have never rented anything.
   Customers without rentals will show rental_id = NULL.

-- Find films that were never rented.
SELECT f.film_id, f.title
FROM film f
LEFT JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE r.rental_id IS NULL
LIMIT 20;

-- Gets all films, joins to inventory and rental, then filters WHERE r.rental_id IS NULL to keep films with no rentals.
This finds movies that were never rented; LIMIT 20 shows 20 results.

----------------------------------------------------------
-- RIGHT JOIN-- 
-- Show ALL categories + number of films in each category
SELECT c.category_id, c.name AS category, COUNT(fc.film_id) AS film_count
FROM film_category fc
RIGHT JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id, c.name
ORDER BY film_count ASC, c.name;

-- Returns all categories even if no films are assigned to them.
   COUNT(fc.film_id) counts films per category; categories with no films show count as 0.


-- FULL OUTTER JOIN-- 
-- MySQL doesn’t support FULL OUTER JOIN directly, so UNION combines LEFT JOIN + RIGHT JOIN results.

# List all actors and the films they’ve acted in (even if unmatched on either side

SELECT a.actor_id, a.first_name, fa.film_id
FROM sakila.actor a
LEFT JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id

UNION

SELECT a.actor_id, a.first_name, fa.film_id
FROM sakila.actor a
RIGHT JOIN sakila.film_actor fa ON a.actor_id = fa.actor_id;

------------------------
#  List all customers and all rentals, including those without each other

SELECT c.customer_id, r.rental_id
FROM sakila.customer c
LEFT JOIN sakila.rental r ON c.customer_id = r.customer_id

UNION

SELECT c.customer_id, r.rental_id
FROM sakila.customer c
RIGHT JOIN sakila.rental r ON c.customer_id = r.customer_id;

-- LEFT JOIN keeps all customers, RIGHT JOIN keeps all rentals, and UNION merges them.
   You get customers without rentals and rentals that don’t match a customer

-------------------------------

-- Full list of actor–film relationships, including actors with no films AND films with no actors.
SELECT a.actor_id, a.first_name, a.last_name, f.film_id, f.title
FROM actor a
LEFT JOIN film_actor fa ON a.actor_id = fa.actor_id
LEFT JOIN film f ON fa.film_id = f.film_id

UNION

SELECT a.actor_id, a.first_name, a.last_name, f.film_id, f.title
FROM film f
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
LIMIT 50;

-- First query keeps all actors, then joins to film_actor and film (actors with no films become NULL).
   Second query keeps all films, then joins back to film_actor and actor; UNION merges both sets.

-- 

-- SELF JOIN

#SELF JOIN

-- Joins staff table to itself to find staff members working in the same store_id.
SELECT s1.staff_id, s2.staff_id, s1.store_id
FROM sakila.staff s1
JOIN sakila.staff s2 ON s1.store_id = s2.store_id
WHERE s1.staff_id <> s2.staff_id;

-----------------

select * from sakila.staff;

------------------------

-- 1. Create the staff_demo table
CREATE TABLE sakila.staff_demo (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    store_id INT
);

-- 2. Insert sample data
INSERT INTO sakila.staff_demo (staff_id, first_name, store_id) VALUES
(1, 'Alice', 1),
(2, 'Bob', 1),
(3, 'Charlie', 2),
(4, 'Diana', 2),
(5, 'Ethan', 1);

-- 3. Run a self join: find staff pairs working in the same store
SELECT 
    s1.staff_id AS staff_1_id,
    s1.first_name AS staff_1_name,
    s2.staff_id AS staff_2_id,
    s2.first_name AS staff_2_name,
    s1.store_id
FROM sakila.staff_demo s1
JOIN sakila.staff_demo s2
  ON s1.store_id = s2.store_id
  AND s1.staff_id <> s2.staff_id
ORDER BY s1.store_id, s1.staff_id;

-- Creates a demo table and inserts sample staff data for testing self-joins.
   The query returns pairs of staff in the same store, excluding self-pairs, and orders the output.


-----------------------------------------------

-- Actors with the same last name
SELECT
  a1.actor_id AS actor1_id, a1.first_name AS actor1_first,
  a2.actor_id AS actor2_id, a2.first_name AS actor2_first,
  a1.last_name
FROM actor a1
JOIN actor a2
  ON a1.last_name = a2.last_name
 AND a1.actor_id < a2.actor_id
ORDER BY a1.last_name;

------------------------------------
# Normalization Overview

- 1NF – each column holds atomic (indivisible) values; no comma‑separated lists.
- 2NF – eliminate partial dependencies; non‑key columns depend on the whole primary key.
- 3NF – remove transitive dependencies; non‑key columns depend only on the primary key.

## Benefits of Normalization

- Reduces data duplication (e.g., one customer record, many orders).
- Speeds up queries on large tables (e.g., 1 billion rows → fetch unique customers in seconds).
- Simplifies maintenance and enforces data integrity via primary/foreign keys.
