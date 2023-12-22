create DATABASE triggers16;
use triggers16;

CREATE TABLE `employees` (
  `employeeNumber` int(11) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `firstName` varchar(50) NOT NULL,
  `extension` varchar(10) NOT NULL,
  `email` varchar(100) NOT NULL,
  `officeCode` varchar(10) NOT NULL,
  `reportsTo` int(11) DEFAULT NULL,
  `jobTitle` varchar(50) NOT NULL,
  PRIMARY KEY (`employeeNumber`)
);

insert  into `employees`(`employeeNumber`,`lastName`,`firstName`,`extension`,`email`,`officeCode`,`reportsTo`,`jobTitle`) values 
(1002,'Murphy','Diane','x5800','dmurphy@classicmodelcars.com','1',NULL,'President'),
(1056,'Patterson','Mary','x4611','mpatterso@classicmodelcars.com','1',1002,'VP Sales'),
(1076,'Firrelli','Jeff','x9273','jfirrelli@classicmodelcars.com','1',1002,'VP Marketing');


--1-- Insert a new employee to , but with an null email. Explain what happens.

INSERT INTO
    employees (
        employeeNumber,
        lastName,
        firstName,
        extension,
        email,
        officeCode,
        reportsTo,
        jobTitle
    )
    VALUES(
        10, 'velez','lautaro','x2004',NULL,1,1002,'President'
    );
    /*
 Error: Column "email" cannot be null
 El campo email en la definición de la tabla dice estrictamente que ese campo no puede ser nulo: "`email` varchar(100) NOT NULL"
 */

 --2- Run the first the query
--What did happen? Explain. Then run this other
--Explain this case also.

UPDATE employees SET employeeNumber = employeeNumber - 20;
UPDATE employees SET employeeNumber = employeeNumber + 20;

--3- Add a age column to the table employee where and it can only accept values from 16 up to 70 years old.

ALTER TABLE employees ADD COLUMN age int check (age >= 16 and age <= 70);

--4- Describe the referential integrity between tables film, actor and film_actor in sakila db.
-- La tabla "film_actor" desempeña el papel de intermediaria entre las tablas "film" y "actor", posibilitando el funcionamiento de la relación de muchos a muchos que existe entre ambas tablas. Permitiendo que un actor puede participar en múltiples películas, en contraste con el hecho de que una película puede involucrar a varios actores. Dentro de la tabla "film_actor", el campo "film_id" establece una conexión entre la película y el campo "actor_id", lo cual indica qué actor participó en determinada película. Este proceso se repite para todos los registros presentes en la tabla "film_actor".

--5- Create a new column called lastUpdate to table employee and use trigger(s) to keep the date-time updated on inserts and updates operations. 
--Bonus: add a column lastUpdateUser and the respective trigger(s) to specify who was the last MySQL user that changed the row (assume multiple users, other than root, can connect to MySQL and change this table).

alter table employees add column lastUpdate datetime;
alter table employees add column lasUpdateUser varchar(50);


CREATE TRIGGER before_employees_instert
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
SET new.lastUpdate = NOW();
END

CREATE TRIGGER before_employees_insert_who_did_it
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
SET new.lasUpdateUser = NOW();
END

--6- Find all the triggers in sakila db related to loading film_text table. What do they do? Explain each of them using its source code for the explanation.


-- sakila.film_text definition
CREATE TABLE `film_text` (
    `film_id` smallint(6) NOT NULL,
    `title` varchar(255) NOT NULL,
    `description` text,
    PRIMARY KEY (`film_id`),
    FULLTEXT KEY `idx_title_description` (`title`,`description`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Triggers:
CREATE DEFINER=`user`@`%` TRIGGER `ins_film` 
    AFTER INSERT ON `film`
    FOR EACH ROW 
BEGIN
    INSERT INTO film_text (film_id, title, description)
        VALUES (new.film_id, new.title, new.description);
END
-- When add a film it's also added in sakila.film_text

CREATE DEFINER=`user`@`%` TRIGGER `upd_film`
    AFTER UPDATE ON `film`
    FOR EACH ROW
BEGIN
    IF (old.title != new.title) OR (old.description != new.description) OR (old.film_id != new.film_id)
    THEN
        UPDATE film_text
            SET title=new.title,
                description=new.description,
                film_id=new.film_id
        WHERE film_id=old.film_id;
    END IF;
END
-- When update a film, if the values are different, it's also updated in sakila.film_text

CREATE DEFINER=`user`@`%` TRIGGER `del_film`
    AFTER DELETE ON `film`
    FOR EACH ROW
BEGIN
    DELETE FROM film_text WHERE film_id = old.film_id;
END
-- When delete a film it's also deleted in sakila.film_text