### Exercises

--1. Write a function that returns the amount of copies of a film in a store in sakila-db. Pass either the film id or the film name and the store id.

DROP FUNCTION IF EXISTS get_film_copy_count;
DELIMITER //
CREATE FUNCTION get_film_copy_count(FILM_IDENTIFIER VARCHAR(255), STORE_ID INT) RETURNS INT READS SQL DATA
BEGIN 
	DECLARE film_count INT;
	SELECT
	    COUNT(*) INTO film_count
	FROM inventory i
	    JOIN film f ON i.film_id = f.film_id
	WHERE (
	        f.film_id = film_identifier
	        OR f.title = film_identifier
	    )
	    AND i.store_id = store_id;
	RETURN film_count;
	END
//
DELIMITER ;

-- Testear correcto funcionamiento
SELECT get_film_copy_count(9, 1);
SELECT get_film_copy_count('ACADEMY DINOSAUR', 2);


--2. Write a stored procedure with an output parameter that contains a list of customer first and last names separated by ";", that live in a certain country. You pass the country it gives you the list of people living there. **USE A CURSOR**, do not use any aggregation function (ike CONTCAT_WS.
DROP PROCEDURE IF EXISTS get_customers_in_country;
DELIMITER //
CREATE PROCEDURE get_customers_in_country(IN country_name VARCHAR(50), OUT customer_list VARCHAR(255))
BEGIN
    -- Declarar variables a usar
    DECLARE done INT DEFAULT 0;
    DECLARE customer_first_name VARCHAR(50);
    DECLARE customer_last_name VARCHAR(50);
    DECLARE customer_full_name VARCHAR(100);

    -- Obtener customers por país
    DECLARE cur CURSOR FOR
        SELECT first_name, last_name
        FROM customer cu
            JOIN `address` ad ON cu.address_id = ad.address_id
            JOIN city ci ON ad.city_id = ci.city_id
            JOIN country co ON ci.country_id = co.country_id
        WHERE co.country = country_name;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    SET customer_list = '';
    OPEN cur;
    
    -- Loop para obtener y almacenar los customers para hacer display posteriormente
    read_loop: LOOP
        FETCH cur INTO customer_first_name, customer_last_name;
        
        -- Break loop cuando no haya más customers
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        SET customer_full_name = CONCAT(customer_first_name, ' ', customer_last_name);
        
        IF customer_list = '' THEN
            SET customer_list = customer_full_name;
        ELSE
            SET customer_list = CONCAT(customer_list, '; ', customer_full_name);
        END IF;
    END LOOP;
    
    CLOSE cur;
END;
//
DELIMITER ;

-- Testear correcto funcionamiento
SET @output_list = '';
CALL get_customers_in_country('ARGENTINA', @output_list);
SELECT @output_list;

--3. Review the function **inventory_in_stock** and the procedure **film_in_stock** explain the code, write usage examples.
