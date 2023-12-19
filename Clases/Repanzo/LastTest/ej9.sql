--1--Obtén la cantidad de ciudades por país en la base de datos. Ordénalos por país y country_id.
select c.country, c.country_id, COUNT(DISTINCT city_id) as cantidad from country c
join city on c.country_id = city.country_id
GROUP BY country, country_id;

--2--Obtén la cantidad de ciudades por país en la base de datos. 
--Muestra solo los países con más de 10 ciudades, ordenados desde la mayor cantidad de ciudades hasta la menor.
select c.country, c.country_id, COUNT(DISTINCT city_id) as cantidad from country c
join city on c.country_id = city.country_id
GROUP BY country, country_id
HAVING COUNT(DISTINCT city_id) > 10
ORDER BY COUNT(DISTINCT city_id) DESC;

--3--Genera un informe con el nombre del cliente (first, last), dirección, total de películas alquiladas 
--y el dinero total gastado alquilando películas. 
--Muestra primero a aquellos que gastaron más dinero.
select c.first_name, c.last_name, address, count(r.rental_id) as peliqulas_alquiladas, SUM(p.amount) from customer c
join address on c.address_id = address.address_id
join rental r on c.customer_id = r.customer_id
join payment p on c.customer_id = p.customer_id
GROUP BY first_name,last_name, address
order by sum(p.amount) DESC;

--4--¿Qué categorías de películas tienen una duración promedio más larga (comparando el promedio)? 
--Ordénalas por promedio en orden descendente.

select c.name, avg(length) as duracion_promedio from film
join film_category fc on film.film_id = fc.film_id 
join category c on fc.category_id = c.category_id
GROUP BY c.name
order by duracion_promedio DESC;

--5--Muestra las ventas por clasificación de película. Show sales per film rating

select f.rating, count(r.rental_id) as ventas from film f
join inventory USING(film_id)
join rental r USING(inventory_id)
GROUP BY rating;