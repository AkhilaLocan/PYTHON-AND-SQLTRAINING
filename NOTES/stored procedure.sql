 ## Stored Procedures – Why & How
- Reusable “functions” inside the database, similar to Python/Java methods.  
- Replace hard‑coded repeated queries with a single procedure that accepts parameters.  
- Two parameter types: **input** (values you pass in) and **output** (values the procedure returns).  
- Syntax starts with `CREATE PROCEDURE … BEGIN … END` and is wrapped by a delimiter.  

---

## Input‑Only Example: Get Customer Payments
- Procedure takes a **customer_id** (int) as input.   
- Call with `CALL get_customer_payments(6);` – returns all payments for that customer.  
- Changing the input (e.g., to 7) automatically fetches that customer’s data – no hard‑coding needed.  

DROP PROCEDURE IF EXISTS sakila.GetCustomerPayments;

-- IN parameter only
DELIMITER //
CREATE PROCEDURE sakila.GetCustomerPayments(IN cid INT)
BEGIN
    SELECT payment_id, amount, payment_date
    FROM sakila.payment
    WHERE customer_id = cid;
END;
//

DROP PROCEDURE IF EXISTS sakila.TotalPaid;


---

## Input + Output Example: Total Paid per Customer
- Input: `customer_id` (int).  
- Output: `total` (decimal) to hold the sum of amounts.  
- After `CALL total_paid(6, @total);` the variable `@total` holds the sum (e.g., 93.72).  
- Output can be used in further calculations or as a filter (e.g., customers who paid > 150).  

-- OUT parameter
//
CREATE PROCEDURE sakila.TotalPaid(IN cid INT, OUT total DECIMAL(10,2))
BEGIN
    SELECT SUM(amount) INTO total
    FROM sakila.payment
    WHERE customer_id = cid ;
END;
//

 DROP PROCEDURE IF EXISTS sakila.DynamicQuery;
//
//
CREATE PROCEDURE sakila.DynamicQuery(IN tbl_name VARCHAR(64))
BEGIN
    SET @s = CONCAT('SELECT COUNT(*) AS total_rows FROM ', tbl_name);
    PREPARE stmt FROM @s;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;
//

DELIMITER ;
---

## Dynamic SQL Stored Procedures
- Build SQL strings at runtime using input values (e.g., table name).  
- Steps:  
  1. **Concatenate** a query string (`SELECT COUNT(*) FROM ` + table_name).  
  2. **PREPARE** the statement from the string.  
  3. **EXECUTE** it.  
  4. **DEALLOCATE** the prepared statement.  
- Allows one procedure to work with any table without rewriting code.  

-- Dynamic SQL procedure
//
CREATE PROCEDURE sakila.DynamicQuery(IN tbl_name VARCHAR(64))
BEGIN
    SET @s = CONCAT('SELECT COUNT(*) AS total_rows FROM ', tbl_name);
    PREPARE stmt FROM @s;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;
//

DELIMITER ;

-- CALL examples:

CALL sakila.GetCustomerPayments(7);
-------------------------------------------
-- SET @rents = 0; CALL sakila.IncrementRentals(3, @rents); SELECT @rents;
------------------------------------------------------------------------------------------

CALL sakila.TotalPaid(6, @total); SELECT @total;

-------------------------------------------------------------

CALL sakila.DynamicQuery('sakila.customer');

-----------------------------------------------------
CALL sakila.TotalPaid(7, @total); 

SELECT @total;

---

## Temporary Tables in Dynamic Procedures
- Created on‑the‑fly to hold intermediate results (e.g., list of generated SELECT statements).  
- Defined with an auto‑increment primary key and a `TEXT` column for the SQL text.  
- After the loop finishes, you can query the temporary table to see all generated statements instantly.  

-- Create a temp table to store SELECT statements
DROP TEMPORARY TABLE IF EXISTS sakila.select_statements; 

CREATE TEMPORARY TABLE sakila.select_statements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    statement_text TEXT
);

-- drop PROCEDURE sakila.StoreSelectStatements;
-- Create the procedure
DELIMITER //

CREATE PROCEDURE sakila.StoreSelectStatements(IN db_name VARCHAR(64))
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tbl_name VARCHAR(64);
    DECLARE cur CURSOR FOR
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = db_name;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO tbl_name;
        IF done THEN
            LEAVE read_loop;
        END IF;

        SET @stmt = CONCAT('SELECT count(*) FROM ', db_name, '.', tbl_name, ';');
        SET @ins = CONCAT('INSERT INTO select_statements (statement_text) VALUES (?)');
        PREPARE stmt FROM @ins;
        EXECUTE stmt USING @stmt;
        DEALLOCATE PREPARE stmt;

    END LOOP;

    CLOSE cur;
END;
//

DELIMITER ;

-- Call the procedure
CALL sakila.StoreSelectStatements('sakila');

-- See results
SELECT * FROM sakila.select_statements;
