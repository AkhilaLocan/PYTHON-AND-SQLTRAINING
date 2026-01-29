create database company_db;
CREATE TABLE company_db.test_table (
    id INT,
    name VARCHAR(100)
);

SELECT id FROM company_db.test_table;
INSERT INTO company_db.test_table (id, name)
VALUES
    (1, 'Alice'),
    (2, 'Bob'),
    (3, 'Charlie');
ALTER TABLE company_db.test_table
ADD email VARCHAR(255);
SELECT * FROM company_db.test_table;
