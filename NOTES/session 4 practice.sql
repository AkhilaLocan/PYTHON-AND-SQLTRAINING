#sub queries 

SELECT first_name, last_name
FROM sakila.customer
WHERE
    address_id IN (SELECT address_id FROM sakila.customer);
    
-- The subquery returns a list of all address_id values that exist in sakila.customer, and the outer query then 
   selects customers whose address_id is in that same list so it will usually return all customers
-----------------------------------
SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE actor_id IN (
    SELECT actor_id
    FROM sakila.film_actor
    GROUP BY actor_id
    HAVING COUNT(film_id) > 10
);

-- This query returns actors who have acted in more than 10 films: the subquery groups film_actor by actor_id 
and keeps only those with COUNT(film_id) > 10, and the outer query selects those actors’ details from sakila.actor.


------------------
#sub query in  select 

SELECT actor_id,
       first_name,
       last_name,
       (
           SELECT COUNT(*)
           FROM sakila.film_actor
           WHERE film_actor.actor_id = actor.actor_id
       ) AS film_count
FROM sakila.actor;

-- This query returns every actor and adds film_count, which is calculated by a correlated subquery that counts 
   how many rows in film_actor match the current actor’s actor_id so it shows how many films each actor appeared in.
------------------------
# Derived Tables

SELECT a.actor_id, a.first_name, a.last_name, fa.film_count
FROM sakila.actor a
JOIN (
    SELECT actor_id, COUNT(film_id) AS film_count
    FROM sakila.film_actor
    GROUP BY actor_id
    HAVING COUNT(film_id) > 10
) fa ON a.actor_id = fa.actor_id;

-- The first counts how many movies each actor has acted in and keeps only the actors with more than 10 movies. 
   Then it joins that list with the actor table to show the actor’s name along with their movie count.

SELECT customer_id, total_spent
FROM (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM sakila.payment
    GROUP BY customer_id
    ORDER BY total_spent DESC
    LIMIT 5
) AS top_customers;

-- This subquery first adds up how much each customer has paid and keeps only the top 5 customers who spent the most.
   Then the main query selects from that list to show each customer’s ID along with their total amount spent.

SELECT *
FROM (
    SELECT last_name,
           CASE 
               WHEN LEFT(last_name, 1) BETWEEN 'A' AND 'M' THEN 'Group A-M'
               WHEN LEFT(last_name, 1) BETWEEN 'N' AND 'Z' THEN 'Group N-Z'
               ELSE 'Other'
           END AS group_label
    FROM sakila.customer
) AS grouped_customers 
WHERE group_label = 'Group N-Z';

-- This subquery first takes each customer’s last_name and creates a group_label based on the first letter (A–M or N–Z).
   Then the main query filters that derived table and returns only the customers in Group N-Z.
   
   -- ANOTHER EXAMPLE -- 
   SELECT *
FROM (
    SELECT first_name,
           last_name,
           CASE
               WHEN active = 1 THEN 'Active'
               ELSE 'Inactive'
           END AS status_label
    FROM sakila.customer
) AS grouped_customers
WHERE status_label = 'Active';

-- The subquery creates a derived table and adds a status_label column by converting active into ‘Active’ or ‘Inactive’.
   Then the main query filters that derived table and returns only rows where status_label is ‘Active’.

# order of execution 
 -- FROM ---- > Where --->  select 

---------------------------------
-- Use subqueries when:
-- You need temporary results to build your main query
-- You are comparing against aggregate values

SELECT customer_id, amount
FROM sakila.payment
WHERE amount > (
    SELECT AVG(amount)
    FROM sakila.payment
);

-- The subquery first calculates the average payment amount from sakila.payment.
 Then the main query returns only the payments where amount is greater than that average, showing customer_id and amount.
 ------------------------------------
#when sub query fail 

SELECT first_name,
       (SELECT address_id FROM sakila.address WHERE district = 'California'  ) AS cali_address
FROM sakila.customer;

-- That subquery is in the SELECT clause, so it must return only one value per customer row.
   But district = 'California' can match many addresses, so the subquery returns multiple rows 
   and causes an error (“Subquery returns more than 1 row”).
------------------------------------------------
#co related subqueries 
-- A correlated subquery is a subquery that:
-- Refers to a column from the outer (main) query
-- Is executed once for each row in the outer query
SELECT title,
  (SELECT COUNT(*)
   FROM sakila.film_actor fa
   WHERE fa.film_id = f.film_id) AS actor_count
FROM sakila.film f;

-- The main query returns each film title from sakila.film. For every film row, the correlated subquery counts 
    matching rows in film_actor (same film_id) to get actor_count.
-------------------------------

SELECT payment_id, customer_id, amount, payment_date
FROM sakila.payment p1
WHERE amount > (
    SELECT AVG(amount)
    FROM sakila.payment p2
    WHERE p2.customer_id = p1.customer_id
);
select amount from sakila.customer;

--  The main query (p1) returns each payment row (payment_id, customer_id, amount, payment_date).
--   correlated subquery (p2) For each payment, the correlated subquery calculates that 
     customer’s average payment amount (p2 where p2.customer_id = p1.customer_id).
     The row is returned only if the payment amount is higher than that customer’s average.
----------------------------------------------
-- Limitations of Subqueries--
---- scope, complexity, resuability
- Scope limited to the single query; cannot be accessed later
- Complex nesting leads to hard‑to‑read, slower queries
- Reusability low – duplicate logic needed for multiple uses
- May return multiple rows causing “subquery returns more than one row” errors
-------------------------------
## Cardinality Relationships

- Define how tables relate via primary‑foreign keys
- There are Four types: one‑to‑one, one‑to‑many, many‑to‑one, many‑to‑many

## One‑to‑One Example

- user ↔ user_profile (each user has a single profile record)
- Join on user_id to fetch active/inactive status

## One‑to‑Many Example

- user → orders (one user can place many orders)
- user_id repeats in order table, order_id stays unique

## Many‑to‑One (Reverse View)

- orders → user (many orders point to one user)

## Many‑to‑Many Example

- users ↔ friendships (bridge table with user_id, friend_id)
- Self‑join on bridge table to list mutual friends

