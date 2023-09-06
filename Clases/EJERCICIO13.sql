--1--
INSERT INTO customer
(store_id, first_name, last_name, email, address_id, active, create_date, last_update)
VALUES
(1, 'lautaro', 'velez', 'lautivelez@gmail.com',
 (SELECT MAX(A.address_id)
  FROM address AS A
  INNER JOIN city AS CI ON A.city_id = CI.city_id
  INNER JOIN country CO ON CI.country_id = CO.country_id
  WHERE CO.country = 'United States'),
 1, CURRENT_TIME(), CURRENT_TIMESTAMP());

--2--
INSERT INTO rental (rental_date, inventory_id, customer_id, return_date, staff_id)
VALUES
(CURRENT_DATE(),
 (SELECT I.inventory_id
  FROM inventory AS I
  WHERE NOT EXISTS(SELECT *
                   FROM rental AS R
                   WHERE R.inventory_id = I.inventory_id
                     AND R.return_date IS NULL)
  LIMIT 1),
 1, CURRENT_DATE(),
 (SELECT staff_id
  FROM staff
  WHERE store_id = 2)
);

--3
UPDATE film
SET release_year = CASE rating
                     WHEN 'G' THEN '2001'
                     WHEN 'PG' THEN '2004'
                     WHEN 'R' THEN '2010'
                     WHEN 'PG-13' THEN '2007'
                     WHEN 'NC-17' THEN '2013'
                     ELSE release_year
                   END;

--4
UPDATE rental
SET return_date = CURRENT_TIMESTAMP
WHERE rental_id = (
    SELECT rental_id
    FROM rental
    WHERE return_date IS NULL
    ORDER BY rental_date DESC
    LIMIT 1
);

-- Intentar eliminar una película
/* dado que las operaciones DELETE involucran claves foráneas, no es posible eliminar la película directamente.
   Primero tenemos que eliminar todas las relaciones asociadas a la película y desp eliminar la película. */

-- comenzar una transacción
START TRANSACTION;

-- Eliminar registros relacionados con la película
DELETE FROM film_actor WHERE film_id = 123;
DELETE FROM film_category WHERE film_id = 123;
DELETE FROM rental WHERE inventory_id IN (SELECT inventory_id FROM inventory WHERE film_id = 123);
DELETE FROM inventory WHERE film_id = 123;
DELETE FROM payment WHERE rental_id IN (SELECT rental_id FROM rental WHERE inventory_id IN (SELECT inventory_id FROM inventory WHERE film_id = 123));

-- elimina la película
DELETE FROM film WHERE film_id = 123;

-- Si todo es exitoso, realizamos un COMMIT
COMMIT;

-- Alquilar una película
/*  hay un inventory_id disponible en la tienda, agregamos una entrada de renta y una de pago. */

-- Encontrar un inventory_id disponible
SET @available_inventory_id = (
    SELECT i.inventory_id
    FROM inventory i
    JOIN film f ON f.film_id = i.film_id
    WHERE i.inventory_id NOT IN (
        SELECT iv.inventory_id
        FROM inventory iv
        JOIN rental r ON r.inventory_id = iv.inventory_id
        WHERE r.return_date IS NULL
    )
    LIMIT 1
);

-- agregar una entrada de renta
INSERT INTO rental (rental_date, inventory_id, customer_id, staff_id)
VALUES (CURRENT_DATE(), @available_inventory_id, 1, 1);

-- agregar una entrada de pago
INSERT INTO payment (customer_id, staff_id, rental_id, amount, payment_date)
VALUES (1, 1, LAST_INSERT_ID(), 2.99, CURRENT_DATE());
