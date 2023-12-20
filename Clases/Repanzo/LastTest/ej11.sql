-- Active: 1702945249657@@127.0.0.1@3306@sakila

use sakila;
--4--Encuentra todos los títulos de películas que no están en el inventario.
select title from film where not EXISTS (select f2.title from film f2 join inventory i USING(film_id));

--5--Encuentra todas las películas que están en el inventario pero nunca fueron alquiladas.
--Muestra el título y el inventory_id.
--Este ejercicio es complicado.
--Sugerencia: utiliza subconsultas en el FROM y en el WHERE, o utiliza LEFT JOIN y pregunta si uno de los campos es nulo.

select title, inventory_id from film, inventory i
where  EXISTS (select f2.title from film f2 
join inventory i USING(film_id) 
join rental r USING(inventory_id));

--6--Genera un informe con:

--Nombre del cliente (primero, último), ID de la tienda, título de la película,
--cuándo se alquiló y se devolvió la película para cada uno de estos clientes
--ordenado por store_id, apellido del cliente.

--customer (first, last) name, store id, film title,
--when the film was rented and returned for each of these customers
--order by store_id, customer last_name

--mine
select c.first_name, c.last_name, i.store_id, f.title, r.rental_date, r.return_date from customer c
join rental r using(customer_id)
join inventory i USING(inventory_id)
join film f using(film_id)
order by store_id, c.last_name;

--lichi's
SELECT
    CONCAT(c.last_name, " ", c.first_name) AS full_name,
    i.store_id,
    f.title,
    r.rental_date,
    r.return_date
FROM customer c
    JOIN rental r USING(customer_id)
    JOIN inventory i USING(inventory_id)
    JOIN film f USING(film_id)
ORDER BY
    i.store_id,
    c.last_name;



--7--Show sales per store (money of rented films)

--show store's city, country, manager info and total sales (money)
--(optional) Use concat to show city and country and manager first and last name

select sum(amount) as money, s.store_id,concat(c.city, ', ',co.country) as info_tienda, concat(st.first_name,' ',st.last_name) as nombre_manager from payment
join staff st USING(staff_id)
join address using(address_id)
join store s using(store_id)
join city c using(city_id)
join country co USING(country_id)
GROUP BY store_id, info_tienda, country,nombre_manager;

--8--¿Qué actor ha aparecido en la mayoría de las películas?
select a.first_name, a.last_name,COUNT(fa.actor_id) as numero_de_peliculas from actor a
join film_actor fa USING(actor_id)
GROUP BY a.first_name, a.last_name
ORDER BY numero_de_peliculas desc
limit 1;

