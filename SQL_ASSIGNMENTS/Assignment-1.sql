USE sakila;
SHOW TABLES;

-- QUESTION 1--  Get all customers whose first name starts with 'J' and who are active.
SELECT customer_id,first_name,last_name,email,active FROM customer
WHERE first_name LIKE 'J%'
  AND active = 1;
  
-- QUESTION 2-- Find all films where the title contains the word 'ACTION' or the description contains 'WAR'.
SELECT film_id,title,description FROM film
WHERE title LIKE '%ACTION%'
   OR description LIKE '%WAR%';
   
-- QUESTION 3-- List all customers whose last name is not 'SMITH' and whose first name ends with 'a'.
SELECT customer_id,first_name,last_name,email FROM customer
WHERE last_name <> 'SMITH'
  AND first_name LIKE '%a';
  
-- QUESTION 4-- Get all films where the rental rate is greater than 3.0 and the replacement cost is not null.
SELECT film_id,title,rental_rate,replacement_cost FROM film
WHERE rental_rate > 3.0
  AND replacement_cost IS NOT NULL;
  
-- QUESTION 5--Count how many customers exist in each store who have active status = 1.
SELECT store_id, COUNT(*) AS active_customers FROM customer
WHERE active = 1
GROUP BY store_id;

-- QUESTION 6-- Show distinct film ratings available in the film table.
SELECT DISTINCT rating
FROM sakila.film
ORDER BY rating;

-- QUESTION 7-- Find the number of films for each rental duration where the average length is more than 100 minutes.
SELECT rental_duration,COUNT(*) AS film_count,
       AVG(length) AS avg_length FROM film
GROUP BY rental_duration
HAVING AVG(length) > 100;

-- QUESTION 8-- List payment dates and total amount paid per date, but only include days where more than 100 payments were made.
SELECT DATE(payment_date) AS pay_day,COUNT(*) AS payments_made,
       SUM(amount) AS total_amount FROM payment
GROUP BY DATE(payment_date)
HAVING COUNT(*) > 100
ORDER BY pay_day;

-- QUESTION 9-- Find customers whose email address is null or ends with '.org'.
SELECT customer_id, first_name, last_name, email FROM customer
WHERE email IS NULL
   OR email LIKE '%.org';
   
-- QUESTION 10--List all films with rating 'PG' or 'G', and order them by rental rate in descending order.
SELECT film_id, title, rating, rental_rate FROM film
WHERE rating IN ('PG', 'G')
ORDER BY rental_rate DESC;

-- QUESTION 11-- Count how many films exist for each length where the film title starts with 'T' and the count is more than 5.
SELECT length,COUNT(*) AS film_count FROM film
WHERE title LIKE 'T%'
GROUP BY length
HAVING COUNT(*) > 5
ORDER BY length;

-- QUESTION 12-- List all actors who have appeared in more than 10 films.
SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(*) AS film_count FROM actor, film_actor
WHERE actor.actor_id = film_actor.actor_id
GROUP BY actor.actor_id, actor.first_name, actor.last_name
HAVING COUNT(*) > 10
ORDER BY film_count;

-- QUESTION 13-- Find the top 5 films with the highest rental rates and longest lengths combined, ordering by rental rate first and length second.
SELECT film_id,title,rental_rate,length FROM film
ORDER BY rental_rate DESC, length DESC
LIMIT 5;

-- QUESTION 14--  Show all customers along with the total number of rentals they have made, ordered from most to least rentals.
SELECT customer_id, first_name, last_name,
       (SELECT COUNT(*) FROM rental WHERE rental.customer_id = customer.customer_id) AS total_rentals FROM customer
ORDER BY total_rentals DESC;

-- QUESTION 15-- List the film titles that have never been rented.
SELECT f.title FROM film f
WHERE NOT EXISTS (
    SELECT 1 FROM inventory i, rental r
    WHERE i.film_id = f.film_id
      AND r.inventory_id = i.inventory_id
);