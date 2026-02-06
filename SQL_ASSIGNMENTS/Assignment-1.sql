USE sakila;
SHOW TABLES;

-- QUESTION 1--
SELECT customer_id,first_name,last_name,email,active FROM customer
WHERE first_name LIKE 'J%'
  AND active = 1;
  
-- QUESTION 2--
SELECT film_id,title,description FROM film
WHERE title LIKE '%ACTION%'
   OR description LIKE '%WAR%';
   
-- QUESTION 3--
SELECT customer_id,first_name,last_name,email FROM customer
WHERE last_name <> 'SMITH'
  AND first_name LIKE '%a';
  
-- QUESTION 4--
SELECT film_id,title,rental_rate,replacement_cost FROM film
WHERE rental_rate > 3.0
  AND replacement_cost IS NOT NULL;
  
-- QUESTION 5--
SELECT store_id, COUNT(*) AS active_customers FROM customer
WHERE active = 1
GROUP BY store_id;

-- QUESTION 6--
SELECT rating, COUNT(*) AS films FROM film
GROUP BY rating
ORDER BY rating;

-- QUESTION 7--
SELECT rental_duration,COUNT(*) AS film_count,
       AVG(length) AS avg_length FROM film
GROUP BY rental_duration
HAVING AVG(length) > 100;

-- QUESTION 8-- 
SELECT DATE(payment_date) AS pay_day,COUNT(*) AS payments_made,
       SUM(amount) AS total_amount FROM payment
GROUP BY DATE(payment_date)
HAVING COUNT(*) > 100
ORDER BY pay_day;

-- QUESTION 9--
SELECT customer_id, first_name, last_name, email FROM customer
WHERE email IS NULL
   OR email LIKE '%.org';
   
-- QUESTION 10--
SELECT film_id, title, rating, rental_rate FROM film
WHERE rating IN ('PG', 'G')
ORDER BY rental_rate DESC;

-- QUESTION 11--
SELECT length,COUNT(*) AS film_count FROM film
WHERE title LIKE 'T%'
GROUP BY length
HAVING COUNT(*) > 5
ORDER BY length;

-- QUESTION 12--
SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(*) AS film_count FROM actor, film_actor
WHERE actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
HAVING COUNT(*) > 10
ORDER BY film_count;

-- QUESTION 13--
SELECT film_id,title,rental_rate,length FROM film
ORDER BY rental_rate DESC, length DESC
LIMIT 5;

-- QUESTION 14--
SELECT customer_id, first_name, last_name,
       (SELECT COUNT(*) FROM rental WHERE rental.customer_id = customer.customer_id) AS total_rentals FROM customer
ORDER BY total_rentals DESC;

-- QUESTION 15--
SELECT f.title FROM film f
WHERE NOT EXISTS (
    SELECT 1 FROM inventory i, rental r
    WHERE i.film_id = f.film_id
      AND r.inventory_id = i.inventory_id
);