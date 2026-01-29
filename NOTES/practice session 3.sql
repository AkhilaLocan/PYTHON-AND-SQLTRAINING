#'strings'
--- PADDING---
select title from sakila.film; 

SELECT title, LPAD(RPAD(title, 20, '*'),25,'*') AS left_padded
FROM sakila.film
LIMIT 5;

SELECT title, LPAD(title, 20, '*') AS left_padded
FROM sakila.film
LIMIT 5;

SELECT title,
       RPAD(title, 20, ' ') AS rpad_spaces,
       LPAD(title, 20, '0') AS lpad_zeros
FROM sakila.film
LIMIT 5;

-----------------------------------------
#Substring 
SELECT title, SUBSTRING(title, 1,9)  AS short_title 
FROM sakila.film;

# Extract the last word of the title (using SUBSTRING_INDEX)
SELECT title,SUBSTRING_INDEX(title, ' ', -1) AS last_word
FROM sakila.film
LIMIT 10;
----------------------
#concatination
SELECT CONCAT(first_name, '.', last_name) AS full_name 
FROM sakila.customer;
--------------------------
#Reverse 
SELECT title, REVERSE(title) AS reversed_title
FROM sakila.film
LIMIT 5;
------------------------------
#length 

SELECT title, LENGTH(title) AS title_length 
FROM sakila.film
WHERE LENGTH(title) =8;
-------------------------------------
#substring with locate 
select email from sakila.customer;

SELECT email,
       SUBSTRING(email, LOCATE('@', email) +1) AS domain
FROM sakila.customer;


SELECT 
  email,
  substring_index(SUBSTRING(email, LOCATE('@', email) + 1), '.', -1) AS domain
FROM 
  sakila.customer;

#substring_index
select substring_index(email,'@', 1) from sakila.customer;

--------------------------
SELECT title, UPPER(title),lower(title)
FROM sakila.film
WHERE UPPER(title) LIKE '%LOVELY%' or UPPER(title) LIKE '%MAN';

select title, lower(title) as lower_titles
FROM sakila.film;
--------------------------------------------------
SELECT LEFT(title, 2) AS first_letter, right(title,3) as last_letter,  COUNT(*) AS film_count
FROM sakila.film
GROUP BY LEFT(title, 2), right(title,3)
ORDER BY film_count DESC;
-----
SELECT LEFT(title,2) AS first_letter, right(title, 3) as last_letter, title 
from sakila.film;

-------------------
SELECT last_name,
       CASE 
           WHEN LEFT(last_name, 1) BETWEEN 'A' AND 'M' THEN 'Group A-M'
           WHEN LEFT(last_name, 1) BETWEEN 'N' AND 'Z' THEN 'Group N-Z'
           ELSE 'Other'
       END AS group_label
FROM sakila.customer;

---------------
#Replace
SELECT title, REPLACE(title, 'A', 'x') AS cleaned_title
FROM sakila.film
WHERE title LIKE '%' '%';
 
-----------------
-- not contains 3 consecutive vowels 
SELECT customer_id, last_name
FROM sakila.customer
WHERE last_name NOT REGEXP '[^aeiouAEIOU]{3}'; 

-- ends with vowel
SELECT lower(title)
FROM sakila.film
WHERE title REGEXP '[aeiouAEIOU]$';


select title, right(title,2)
FROM sakila.film
WHERE title REGEXP '[eE]$' 
;

-- count 

select right(title,1), count(*)
FROM sakila.film
WHERE title REGEXP '[aeiouAEIOU]$' 
group by right(title,1)
;

SELECT title AS ending, right(title,1)
FROM sakila.film
WHERE title REGEXP '[Ee]$';


--------------------------------
#math 

SELECT title, rental_rate, rental_rate ^ 3 AS double_rate   -- debug why its allwoing string + integer
FROM sakila.film;
------------------------
---------------
#math 

-- select amount,CAST(amount AS signed) AS amount_str from sakila.payment;  -- check type casting in mysql 


SELECT customer_id,
       COUNT(payment_id) AS payments,
       SUM(amount) AS total_paid,
       SUM(amount) / COUNT(payment_id) AS avg_payment
       
FROM sakila.payment
GROUP BY customer_id;
------------
select rental_duration,cost_efficiency_dup1 from sakila.film;

select rental_duration from sakila.film;


ALTER TABLE sakila.film
ADD COLUMN cost_efficiency_dup1 DECIMAL(6,2);


SET SQL_SAFE_UPDATES = 0;

UPDATE sakila.film
SET cost_efficiency_dup1 = rental_duration * 2
WHERE length IS NOT NULL;


select * from sakila.film;
---------------------------------

SELECT customer_id, (RAND() * 100), FLOOR(RAND() * 100) AS random_score
FROM sakila.customer
LIMIT 5;


----
SELECT film_id,rental_duration, POWER(rental_duration, 2) AS squared_duration
FROM sakila.film
LIMIT 5;

------
SELECT film_id,length, MOD(length, 60) AS minutes_over_hour
FROM sakila.film;
-------------
SELECT rental_rate, CEIL(rental_rate) AS ceil_value, FLOOR(rental_rate) AS floor_value
FROM sakila.film;
----------
SELECT rental_rate, ROUND(replacement_cost / rental_rate, 0),ROUND(replacement_cost / rental_rate, 1) AS ratio
FROM sakila.film;

---------------------------------
#date diff 

SELECT rental_id, return_date,rental_date, DATEDIFF(return_date, rental_date) AS days_rented
FROM sakila.rental
WHERE return_date IS NOT NULL;

#date time 

select last_update,dayname(last_update),monthname(last_update) from sakila.film;

SELECT 
    rental_date, year(rental_date)
FROM
   sakila.rental;


SELECT payment_date FROM sakila.payment;

SELECT payment_date, date(payment_date) AS pay_date, SUM(amount) AS total_paid
FROM sakila.payment
GROUP BY DATE(payment_date),payment_date
ORDER BY pay_date DESC;

#Find Customers Who Paid in the Last 24 Hours

select * from sakila.payment;

SELECT customer_id, amount, payment_date
FROM sakila.payment
WHERE payment_date >= NOW() - INTERVAL 1 DAY;

select max(payment_date) FROM sakila.payment;

SELECT customer_id, amount, payment_date
FROM sakila.payment
WHERE payment_date >= (
    SELECT MAX(payment_date) - INTERVAL 10 day
    FROM sakila.payment
);

select now()  - INTERVAL 1 DAY as yesterday;


SELECT CONCAT('Today is: ', CURDATE()) AS message;
SELECT CONCAT('Today is: ', now()) AS message;

SELECT NOW(), CURDATE(), CURRENT_TIME;

--------------------------------------------------------
#casting 

ALTER TABLE sakila.payment
ADD COLUMN amount_str VARCHAR(20);

SET SQL_SAFE_UPDATES = 0;

UPDATE sakila.payment
SET amount_str = CAST(amount AS CHAR);


select * from sakila.customer;

select * from sakila.payment;

ALTER TABLE sakila.payment
drop COLUMN amount_str;


----------------
SELECT amount, amount_Str, amount + 10 AS numeric_add,
       amount_str + 10 AS string_add
FROM sakila.payment
LIMIT 5;
-------------

SHOW COLUMNS FROM sakila.payment;
SELECT CAST('2017-08-25' AS datetime);
---------------


