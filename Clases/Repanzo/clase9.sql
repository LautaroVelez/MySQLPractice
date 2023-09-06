use sakila;



#1- Get the amount of cities per country in the database. Sort them by country, country_id.
select COUNT(city) as amount, country from country
join city c on country.country_id = c.country_id
group by country
order by country;

#2- Get the amount of cities per country in the database. Show only the countries with more than 10 cities, order from the highest amount of cities to the lowest
select COUNT(city) as amount, country from country
join city c on country.country_id = c.country_id
group by country
having amount > 10
order by amount desc;

#3-Generate a report with customer (first, last) name, address, total films rented and the total money spent renting films. Show the ones who spent more money first .

SELECT c.first_name,
       c.last_name,
       a.address,
       (select COUNT(*) from rental r where customer_id = r.customer_id) as cantidad_peliculas_rentadas,
       (select SUM(p.amount) from payment p where customer_id= p.customer_id) as cantidad_plata
from customer c
join address a on a.address_id = c.address_id
group by c.first_name, c.last_name, a.address, c.customer_id
order by cantidad_plata desc;

#4- Which film categories have the larger film duration (comparing average)? Order by average in descending order
SELECT c.name, AVG(f.length) AS PROMEDIO_DURACION
FROM film f
         INNER JOIN film_category fc ON fc.film_id = f.film_id
         INNER JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY PROMEDIO_DURACION DESC;

/*
5- Show sales per film rating
 */

 SELECT f.rating, COUNT(p.payment_id) as VENTAS
FROM film f
         JOIN inventory i ON i.film_id = f.film_id
         JOIN rental r ON r.inventory_id = i.inventory_id
         JOIN payment p ON p.rental_id = r.rental_id
GROUP BY rating
ORDER BY VENTAS DESC;