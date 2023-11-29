-- 1. Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS 'Name',
    ad.address,
    ci.city
FROM customer c
    INNER JOIN store sto USING(store_id)
    INNER JOIN address ad ON sto.address_id = ad.address_id
    INNER JOIN city ci USING(city_id)
    INNER JOIN country co USING(country_id)
WHERE co.country = 'Argentina';

-- 2. Write a query that shows the film title, language and rating. Rating shall be shown as the full text described here: https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.

SELECT
    f.title,
    l.name,
    f.rating,
    CASE
        WHEN f.rating LIKE 'G' THEN 'All ages admitted'
        WHEN f.rating LIKE 'PG' THEN 'Some material may not be suitable for children'
        WHEN f.rating LIKE 'PG-13' THEN 'Some material may be inappropriate for children under 13'
        WHEN f.rating LIKE 'R' THEN 'Under 17 requires accompanying parent or adult guardian'
        WHEN f.rating LIKE 'NC-17' THEN 'No one 17 and under admitted'
    END 'Rating Text'
FROM film f
    INNER JOIN language l USING(language_id);

-- 3. Write a search query that shows all the films (title and release year) an actor was part of. Assume the actor comes from a text box introduced by hand from a web page. Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.

SELECT
    CONCAT(
        ac.first_name,
        ' ',
        ac.last_name
    ) AS 'actor',
    f.title AS 'film',
    f.release_year AS 'release_year'
FROM film f
    INNER JOIN film_actor USING(film_id)
    INNER JOIN actor ac USING(actor_id)
WHERE
    CONCAT(first_name, ' ', last_name) LIKE TRIM(UPPER('AUDREY BAILEY'));

-- 4. Find all the rentals done in the months of May and June. Show the film title, customer name and if it was returned or not. There should be returned column with two possible values 'Yes' and 'No'.

SELECT
    f.title,
    r.rental_date,
    c.first_name AS 'customer_name',
    CASE
        WHEN r.return_date IS NOT NULL THEN 'Yes'
        ELSE 'No'
    END 'Returned'
FROM rental r
    INNER JOIN inventory i USING(inventory_id)
    INNER JOIN film f USING(film_id)
    INNER JOIN customer c USING(customer_id)
WHERE
    MONTH(r.rental_date) = '05'
    OR MONTH(r.rental_date) = '06'
ORDER BY r.rental_date;

-- 5

/*
 Las diferencias entre las funciones CONVERT() y CAST() son las siguientes:
 CAST([value] AS [data_type])
 CONVERT([value], [data_type])
 Además, el Convert() permite utilizar codificaciones de caracteres como utf-8 o utf-16 con la siguiente sentencia:
 CONVERT([value] USING [transcoding_name])
 */


-- 6

/*
 METHODS:
 - ISNULL([expression]) esta funcion devuelve un 1 si la expresion es nula o un 0 en caso contrario.
 - IFNULL([expression1], [expression2]) esta funcion devuelve la expresion 1 en caso de esta misma no ser nula, en caso contrario, devuelve la expresion 2.
 - COALESCE([value1], [value2], [value3], ...) esta funcion devuelve el primer valor que no sea nulo de la lista, en caso de ser todos nulos, devuelve NULL
 NOT SQL METHOD:
 - NVL() funciona exactamente igual que COALESCE() y es la funcion que no se encuentra dentro de MySQL
 */