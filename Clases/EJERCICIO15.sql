--1--
CREATE OR REPLACE VIEW list_of_customers AS
SELECT 
    C.customer_id,
    CONCAT(C.first_name, ' ', C.last_name) AS full_name,
    A.address,
    A.postal_code,
    A.phone,
    CI.city,
    CO.country,
    CASE
        WHEN C.active = 1 THEN 'ACTIVE'
        ELSE 'INACTIVE'
    END AS status,
    S.store_id
FROM customer AS C
INNER JOIN address AS A ON C.address_id = A.address_id
INNER JOIN city AS CI ON A.city_id = CI.city_id
INNER JOIN country AS CO ON CI.country_id = CO.country_id
INNER JOIN store S ON A.address_id = S.address_id;

--2--
CREATE OR REPLACE VIEW film_details AS
SELECT 
    F.film_id,
    F.title,
    F.description,
    F.length,
    F.rental_rate AS price,
    F.rating,
    C.name AS category,
    GROUP_CONCAT(A.first_name) AS actors
FROM film_actor AS FA
INNER JOIN film AS F ON F.film_id = FA.film_id
INNER JOIN actor AS A ON A.actor_id = FA.actor_id
INNER JOIN film_category AS FC ON F.film_id = FC.film_id
INNER JOIN category AS C ON FC.category_id = C.category_id
GROUP BY F.film_id, F.title, F.description, C.name, F.rental_rate, F.length, F.rating;

--3--
CREATE OR REPLACE VIEW sales_by_film_category AS
SELECT 
    C.name AS category,
    COUNT(R.rental_id) AS total_rental
FROM category AS C
INNER JOIN film_category AS FC ON C.category_id = FC.category_id
INNER JOIN film AS F ON FC.film_id = F.film_id
INNER JOIN inventory AS I ON F.film_id = I.film_id
INNER JOIN rental AS R ON I.inventory_id = R.inventory_id
GROUP BY C.name;

--4--
CREATE OR REPLACE VIEW actor_information AS 
SELECT 
    A.actor_id,
    A.first_name,
    A.last_name,
    COUNT(f.film_id) AS amount_of_films_acted
FROM film_actor AS FA 
INNER JOIN actor AS A ON A.actor_id = FA.actor_id
INNER JOIN film AS F ON F.film_id = FA.film_id
GROUP BY A.actor_id, A.first_name, A.last_name;

