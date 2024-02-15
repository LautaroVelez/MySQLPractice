-- Active: 1687904736759@@127.0.0.1@3306@sakila

--1-Show title and special_features of films that are PG-13
--2-Get a list of all the different films duration.
--3-Show title, rental_rate and replacement_cost of films that have replacement_cost from 20.00 up to 24.00
--4-Show title, category and rating of films that have 'Behind the Scenes' as special_features
--5-Show first name and last name of actors that acted in 'ZOOLANDER FICTION'
--6-Show the address, city and country of the store with id 1
--7-Show pair of film titles and rating of films that have the same rating.
--8-Get all the films that are available in store id 2 and the manager first/last name of this store (the manager will appear in all the rows).

use sakila;

--1--
select f.title, f.special_features from film f where f.rating = "PG-13";

--2--
select distinct f.length from film f order by f.LENGTH;

--3--
select f.title, f.rental_rate, f.replacement_cost from film f where f.replacement_cost > 20.00 and f.replacement_cost < 24.00;  

--4--
select f.title, c.name, f.rating from film f, category c, film_category fc where fc.film_id = fc.category_id and c.category_id = fc.category_id and f.special_features = "Behind the Scenes";
--5--
select a.first_name, a.last_name from actor a, film_actor fa, film f where fa.actor_id = a.actor_id and fa.film_id = f.film_id and f.title= 'ZOOLANDER FICTION';

select a.first_name, a.last_name From actor a 
Join film_actor fa on a.actor_id = fa.actor_id 
Join film f on fa.film_id = f.film_id
Where f.title = 'ZOOLANDER FICTION';

--6---Show the address, city and country of the store with id 1
--esta no
select co.country, ci.city, a.address from store s
join country co on co.country_id = ci.city_id
join address a on a.address_id = ci.city_id
JOIN city ci on ci.city_id = s.store_id
where s.store_id = 1;

--esta capaz¿
select a.address, ci.city, co.country from store s
join address a on s.store_id = a.address_id 
join city ci on a.address_id = ci.city_id
join country co on ci.city_id = co.country_id
where s.store_id = 1;

--7-Show pair of film titles and rating of films that have the same rating.
select f1.title, f1.rating, f2.title, f2.rating from film f1, film f2 where f1.rating = f2.rating and f1.film_id =! f2.film_id;

--8-Get all the films that are available in store id 2 and the manager first/last name of this store (the manager will appear in all the rows).
select f.title, s.store_id, st.first_name, st.last_name from staff st
join store s on st.staff_id = s.manager_staff_id
join  inventory i on s.store_id = i.store_id
join film f on i.film_id = f.film_id
where s.store_id = 2;
