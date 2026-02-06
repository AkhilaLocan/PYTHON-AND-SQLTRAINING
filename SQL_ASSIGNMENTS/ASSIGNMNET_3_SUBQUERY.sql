-- QUESTION 1-- display all customer details who have made more than 5 payments.
select customer_id, first_name, last_name from customer
where customer_id IN (
select customer_id from payment
group by customer_id
having COUNT(*) > 5
);

-- QUESTION 2-- Find the names of actors who have acted in more than 10 films.
select a.first_name, a.last_name from actor a
where actor_id IN (
select fa.actor_id
from film_actor fa 
group by actor_id
having count(*) >10
);
   
-- QUESTION 3-- Find the names of customers who never made a payment.
select customer_id, first_name, last_name from customer
 where customer_id NOT In(
select customer_id from payment
);

-- QUESTION 4-- List all films whose rental rate is higher than the average rental rate of all films.
select film_id, title, rental_rate from film
where rental_rate > (
select avg(rental_rate) 
from film
);
   
-- QUESTION 5--  List the titles of films that were never rented.
select title from film
where film_id not in (
select film_id from inventory
where inventory_id in(
select inventory_id from rental
)
);

-- QUESTION 6--  Display the customers who rented films in the same month as customer with ID 5.
select customer_id, first_name, last_name 
from customer
where customer_id in (
select distinct customer_id 
from rental 
where (year(rental_date), month(rental_date)) in (
select distinct year(rental_date), month (rental_date)
from rental
where rental.customer_id = 5
)
);

-- QUESTION 7--  Find all staff members who handled a payment greater than the average payment amount.
select staff_id, first_name, last_name
from staff
where staff_id in (
select staff_id
from payment
where amount > (
select avg(amount)
from payment
)
);

-- QUESTION 8--  Show the title and rental duration of films whose rental duration is greater than the average.
select title, rental_duration from film
where rental_duration > (
select avg(rental_duration)
from film 
);

-- QUESTION 9--  Find all customers who have the same address as customer with ID 1.
select customer_id, first_name, last_name from customer
where address_id= (
select address_id from customer
where customer_id= 1
);

-- QUESTION 10--  List all payments that are greater than the average of all payments.
select payment_id, customer_id, amount, payment_date
from payment
where amount > (
select avg(amount)
from payment
);

  
