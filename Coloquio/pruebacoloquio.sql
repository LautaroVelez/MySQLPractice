-- Active: 1687904736759@@127.0.0.1@3306@sakila
--1-- Crea una view llamada customer_rental_summary que proporcione un resumen de las transacciones de alquiler para clientes. 
--La vista debe inluir las siguientes columnas: client_id, nombre del cliente, cantidad total de alquileres realizados,total gastado en alquileres
--Utiliza funciones de agregacion y GROUP_CONCAT segun sea necesario.


-- CREATE OR REPLACE VIEW customer_rental_summary as
SELECT c.customer_id, concat(c.first_name, ' ', c.last_name) as full_name, 
count(r.rental_id) as alquileres_realizados,
sum(p.amount) as total_gastado
FROM customer c
JOIN rental r USING(customer_id)
JOIN payment p USING(rental_id)
GROUP BY customer_id,full_name
ORDER BY customer_id;

SELECT * FROM customer_rental_summary;


--2-- Crea un procedimiento almacenado con un parametro de salida que genere una lista de empleados activos en una cierta ciudad
-- El procedimiento debe aceptar el nombre de la ciudad como entrada y devolver una lista de nombres y apellidos de epleados separados por ';'. 
-- Utiliza un cursor para recorrer los resultados y garantiza que solo se incluyan empleados marcados como activos en la lista.


DROP PROCEDURE IF EXISTS get_staff_in_city;
DELIMITER //
CREATE PROCEDURE get_staff_in_city(IN city_name VARCHAR(50), OUT staff_list VARCHAR(255))
BEGIN

    DECLARE done INT DEFAULT 0;
    DECLARE staff_first_name VARCHAR(50);
    DECLARE staff_last_name VARCHAR(50);
    DECLARE staff_full_name VARCHAR(100);

    -- obtener los empleados por ciudad
    DECLARE cur CURSOR FOR
        SELECT first_name, last_name
        FROM staff st
            JOIN address ad USING(address_id)
            JOIN city ci USING(city_id)
        WHERE ci.city = city_name and st.active= 1;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    SET staff_list = '';
    OPEN cur;
    
    -- creo el loop para obtener y almacenar los empleados 
    read_loop: LOOP
        FETCH cur INTO staff_first_name, staff_last_name;
        
        -- break loop cuando no haya más personas del staf
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SET staff_full_name = CONCAT(staff_first_name, ' ', staff_last_name);
        
        IF staff_list = '' THEN
            SET staff_list = staff_full_name;
        ELSE
            SET staff_list = CONCAT(staff_list, '; ', staff_full_name);
        END IF;
    END LOOP;
    
    CLOSE cur;
END//
DELIMITER ;

-- porfavor anda
SET @staff_list = '';
CALL get_staff_in_city('Lethbridge', @staff_list);
SELECT @staff_list;


--esto es para ver en que ciudad habia un usuario
SELECT * FROM staff;
SELECT * FROM address;
SELECT * FROM city 
JOIN address USING(city_id)
WHERE address.city_id = 300;



--3 Agrega una nueva columna llamada lastModification a la tabla product y emplea triggers para garantizar que esta columna refleje la fecha y hora de las 
--operaciones de insercion y actualizacion. Ademas implementa una columna LastModifyUser y sus respectivos triggers para rastrear que usuario de Mysql 
--realizó la ultima modificacion en la fila, considerando la posibilidad de multiples usuarios ademas de root.


ALTER TABLE film
    ADD lastModification datetime;

DELIMITER //
CREATE TRIGGER before_products_update
    BEFORE UPDATE ON film
    FOR EACH ROW
BEGIN
    SET new.lastModification = now();
END//
DELIMITER ;

INSERT INTO film (title, description, language_id)
values ('jack sparrow', 'good',3);

SELECT * FROM film WHERE title = 'jack sparrow' LIMIT 1;

ALTER TABLE film
    ADD LastModifyUser VARCHAR(50);

DROP TRIGGER IF EXISTS before_modify_user_update;
DELIMITER //
CREATE TRIGGER before_modify_user_update
    BEFORE UPDATE ON film
    FOR EACH ROW
BEGIN
    SET new.LastModifyUser = CURRENT_USER; 
END//
DELIMITER ;

SELECT CURRENT_USER;
SELECT LastModifyUser FROM film 
WHERE title = 'cars 1'
order by `LastModifyUser` desc;


--CORRECCION DE JUANFRA, NO SE COMO LO HIZO pero bueno suerte!
INSERT INTO film (title, description, language_id)
values (
    'cars 1', 'CARS', 2
)


update film set title = 'juanfra was here' where title = 'cars 1';

select * from film where title LIKE '%juanfra%'

show TRIGGERS;