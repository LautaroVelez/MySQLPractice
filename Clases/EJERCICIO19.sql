use sakila;

--1
CREATE USER 'data_analyst'@'localhost' IDENTIFIED BY '2801';

--2
GRANT SELECT, UPDATE, DELETE ON sakila.* TO 'data_analyst'@'localhost';

--3
CREATE TABLE tabla
(
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(60)
);

--CREATE command denied to user 'data_analyst'@'localhost' for table 'tabla'

--4
UPDATE film
SET title = 'GLOWPS'
WHERE film_id = 1;

--5
REVOKE UPDATE ON sakila.* FROM 'data_analyst'@'localhost';

--6
UPDATE film
SET title = 'MORASON'
WHERE film_id = 1;
--UPDATE command denied to user 'data_analyst'@'localhost' for table 'tabla'