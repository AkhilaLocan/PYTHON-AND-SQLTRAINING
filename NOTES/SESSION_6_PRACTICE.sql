 # CTE 
 - A Common Table Expression (CTE) is a temporary result set in SQL that you can reference within a single query.
 - CTEs simplify complex queries, make them easier to read that improves readability.
 -  A CTE can be referenced multiple times in the same statement, which helps with reusability
 - CTE exists only for the single SQL statement immediately following the WITH clause (SELECT/INSERT/UPDATE/DELETE).

------- # CTE VS SUBQUERY ----- 
-- SUBQUERY : customers with total rentals
SELECT
  t.customer_id,
  t.first_name,
  t.last_name,
  t.rental_count
FROM (
  SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS rental_count
  FROM sakila.customer c
  LEFT JOIN sakila.rental r
    ON r.customer_id = c.customer_id
  GROUP BY c.customer_id, c.first_name, c.last_name
) AS t
ORDER BY t.rental_count DESC;

# CTE 

WITH rental_counts AS (
  SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(r.rental_id) AS rental_count
  FROM sakila.customer c
  LEFT JOIN sakila.rental r
    ON r.customer_id = c.customer_id
  GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT
  customer_id, first_name, last_name, rental_count
FROM rental_counts
ORDER BY rental_count DESC;

----- # Recursive CTE-------
--  Use `WITH RECURSIVE` to mimic loops (e.g., generate numbers 1‑20). 
--  Executes as a single query; cannot be run independently.  
--  Helpful for date‑range generation, hierarchical data, or iterative calculations.

WITH RECURSIVE numbers AS (
  SELECT 1 AS n          -- anchor
  UNION ALL
  SELECT n + 1           -- recursive member
  FROM numbers
  WHERE n < 20
)
SELECT n FROM numbers;

------ # Temporary Tables -------
- Created with `CREATE TEMPORARY TABLE … AS SELECT …`.  
- Exist only for the session  
- Stored in server memory, not as permanent objects in the database.  
- Scope: session‑level - any query in the same session can read/write it.  

------ # Create a temp table of “top customers by rentals ------
CREATE TEMPORARY TABLE temp_top_customers AS
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  COUNT(r.rental_id) AS rental_count
FROM sakila.customer c
JOIN sakila.rental r
  ON r.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY rental_count DESC
LIMIT 10;

------ # VIEW -----
-- a view is a virtual table based on the result-set of an SQL statement
-- Defined with `CREATE VIEW view_name AS SELECT 
-- A view can be updated with the CREATE OR REPLACE VIEW statement. 
-- In Virtual table only the query definition is stored, not the data.
-- Provides *data abstraction* hide original column names, expose only needed columns.
-- Increases *security* (restricts sensitive columns) and *scope* (accessible to any user with permission). 
-- Ideal for exposing clean, read‑only data to BI tools (Power BI, Tableau) or external applications.

----- Active customers-----

CREATE VIEW sakila.vw_active_customers AS
SELECT customer_id, first_name, last_name
FROM sakila.customer
WHERE active = 1;

-- Film catalog view creation

CREATE OR REPLACE VIEW sakila.vw_film_catalog AS
SELECT
  f.film_id,
  f.title,
  l.name AS language,
  c.name AS category,
  f.rental_rate,
  f.length,
  f.rating
FROM sakila.film f
JOIN sakila.language l
  ON l.language_id = f.language_id
LEFT JOIN sakila.film_category fc
  ON fc.film_id = f.film_id
LEFT JOIN sakila.category c
  ON c.category_id = fc.category_id;


## Scope, Reusability, and Complexity
-- Subqueries - query‑level scope, high complexity, low reuse.  
-- CTEs - query‑level scope, lower complexity, moderate reuse.  
-- Temporary tables-  session‑level scope, higher memory use, good for repeated access within a session.  
-- Views - database‑level scope, no data duplication, best for cross‑session reuse and security. 

--  Execution time for a view is the same for creator and other users – the query runs each time.  
-- Views do not store data; they only store the query definition, reducing storage cost.  
-- Security through views: users see only the columns you expose, not underlying table structures. 
