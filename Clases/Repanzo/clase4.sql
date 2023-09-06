USE sakila;

#Show title and special_features of films that are PG-13
SELECT title, special_features FROM film WHERE  rating='PG-13';

#Get a list of all the different films duration.
SELECT length, count(*) as lista from film group by length;

#Show title, rental_rate and replacement_cost of films that have replacement_cost from 20.00 up to 24.00
SELECT title, rental_rate, replacement_cost FROM film WHERE replacement_cost between 20.00 and 24.00;

#Show title, category and rating of films that have 'Behind the Scenes' as special_features
SELECT title, rating FROM film WHERE  special_features like '%Behind the Scenes%';


SELECT title, rating, special_features
    FROM film
    JOIN film_category fc ON film.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
WHERE
    SPECIAL_FEATURES LIKE '%BEHIND THE SCENES%';

#Show first name and last name of actors that acted in 'ZOOLANDER FICTION'
SELECT first_name, last_name FROM actor JOIN film_actor ai on actor.actor_id = ai.actor_id JOIN film a on a.film_id = ai.film_id WHERE a.title LIKE '%ZOOLANDER FICTION%';

#Show the address, city and country of the store with id 1
select address, city, country from store
    join address a on a.address_id = store.address_id
    join city c on c.city_id = a.city_id
    join country c2 on c2.country_id = c.country_id
where store_id = '1';

#Show pair of film titles and rating of films that have the same rating.
select film1.title, film2.title from film as film1, film as film2
                                where film1.rating = film2.rating and film1.film_id <> film2.film_id;

#Get all the films that are available in store id 2 and the manager first/last name of this store (the manager will appear in all the rows).
select title, s2.first_name, s2.last_name from film
    join inventory i on film.film_id = i.film_id
    join store s on i.store_id = s.store_id
    join staff s2 on s.manager_staff_id = s2.staff_id
where i.store_id = 2;
