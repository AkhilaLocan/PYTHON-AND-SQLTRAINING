-- QUESTION 1--
SELECT first_name,last_name,email,COUNT(*) AS duplicate_count
FROM sakila.customer
GROUP BY first_name, last_name, email
HAVING COUNT(*) > 1;

-- QUESTION 2--
SELECT film_id,title,
    (LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'a', ''))) AS a_count
FROM sakila.film
ORDER BY a_count DESC, title;

-- QUESTION 3--
SELECT film_id,title,
    (LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'a', ''))) AS a_cnt,
    (LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'e', ''))) AS e_cnt,
    (LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'i', ''))) AS i_cnt,
    (LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'o', ''))) AS o_cnt,
    (LENGTH(LOWER(description)) - LENGTH(REPLACE(LOWER(description), 'u', ''))) AS u_cnt
FROM sakila.film
ORDER BY (a_cnt + e_cnt + i_cnt + o_cnt + u_cnt) DESC, title;

-- QUESTION 4-- 
#1 
SELECT
    customer_id,
    MONTH(payment_date) AS pay_month,
    COUNT(*)            AS payments_count,
    SUM(amount)         AS total_amount
FROM sakila.payment
GROUP BY customer_id, YEAR(payment_date), MONTH(payment_date)
ORDER BY customer_id, pay_month;

#2 
SELECT
    customer_id,
    YEAR(payment_date)  AS pay_year,
    COUNT(*)            AS payments_count,
    SUM(amount)         AS total_amount
FROM sakila.payment
GROUP BY customer_id, YEAR(payment_date), MONTH(payment_date)
ORDER BY customer_id, pay_year;

#3
SELECT
    customer_id,
    YEAR(payment_date) AS pay_year,
    WEEK(payment_date, 1) AS pay_week,
    COUNT(*)           AS payments_count,
    SUM(amount)        AS total_amount
FROM sakila.payment
GROUP BY customer_id, YEAR(payment_date), WEEK(payment_date, 1)
ORDER BY customer_id, pay_year, pay_week;

-- QUESTION 5--
SELECT
  2024 AS year_checked,
  CASE
    WHEN DAYOFYEAR(CONCAT(2024, '-12-31')) = 366 THEN 'Leap Year'
    ELSE 'Not a Leap Year'
  END AS leap_result;
  
  -- QUESTION 6-- 
  SELECT 
  DATEDIFF(
    MAKEDATE(YEAR(CURDATE()), 1) + INTERVAL 1 YEAR, 
    CURDATE()
  ) AS days_remaining_in_year;
  
  -- QUESTION 7 -- 
  SELECT payment_date,
  CONCAT('Q', QUARTER(payment_date)) AS quarter
FROM sakila.payment;

-- QUESTION 8-- 
SET @dob = '2000-11-16';
SELECT CONCAT(
  TIMESTAMPDIFF(YEAR,@dob,CURDATE()), ' years, ',
  MOD(TIMESTAMPDIFF(MONTH,@dob,CURDATE()),12), ' months, ',
  DATEDIFF(CURDATE(), DATE_ADD(@dob, INTERVAL TIMESTAMPDIFF(MONTH,@dob,CURDATE()) MONTH)), ' days'
) AS age;