-- QUESTION1-- List all customers along with the films they have rented.
select c.customer_id, c.first_name, c.last_name, f.title
from customer c
join rental r    ON r.customer_id = c.customer_id
join inventory i  ON i.inventory_id = r.inventory_id
join film  f     ON f.film_id = i.film_id
order by c.customer_id, f.title;

-- QUESTION 2-- List all customers and show their rental count, including those who haven't rented any films.
select c.customer_id, c.first_name, c.last_name,
       COUNT(r.rental_id) as rental_count
from customer c
left join rental r on r.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name
order by rental_count desc, c.customer_id;

-- QUESTION 3-- Show all films along with their category. Include films that don't have a category assigned.
select f.film_id, f.title, c.name as category
from film f
left join film_category fc on fc.film_id = f.film_id
left join category c       on c.category_id = fc.category_id
order by f.title;

-- QUESTION 4-- Show all customers and staff emails from both customer and staff tables using a full outer join 
   (simulate using LEFT + RIGHT + UNION).
select c.customer_id as id, c.first_name, c.last_name, c.email, 'customer' as user
from customer c
left join staff s on s.email = c.email

union

select s.staff_id as id, s.first_name, s.last_name, s.email, 'staff' as user
from customer c
right join staff s on s.email = c.email;

-- QUESTION 5-- Find all actors who acted in the film "ACADEMY DINOSAUR".
select a.actor_id, a.first_name, a.last_name
from actor a
join film_actor fa on fa.actor_id = a.actor_id
join film f on f.film_id = fa.film_id
where f.title = 'ACADEMY DINOSAUR';

-- QUESTION 6-- List all stores and the total number of staff members working in each store, even if a store has no staff.
select s.store_id,
       COUNT(st.staff_id) as staff_count
from store s
left join staff st on st.store_id = s.store_id
group by s.store_id;

-- QUESTION 7-- List the customers who have rented films more than 5 times. Include their name and total rental count.
select c.customer_id, c.first_name, c.last_name,
 COUNT(r.rental_id) AS total_rentals
from customer c
join rental r on r.customer_id = c.customer_id
group by c.customer_id, c.first_name, c.last_name
having COUNT(r.rental_id) > 5
order by total_rentals desc;