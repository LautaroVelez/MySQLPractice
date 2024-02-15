
--1--Create a view named list_of_customers, it should contain the following columns:
--customer id
--customer full name,
--address
--zip code
--phone
--city
--country
--status (when active column is 1 show it as 'active', otherwise is 'inactive')
--store id

create view list_of_customers as
select c.customer_id, concat(c.first_name, ' ', c.last_name) as full_name, a.address, a.postal_code, a.phone, ci.city, co.country, CASE 
    WHEN customer_id = 1 THEN 'active'  
    ELSE  'inactive'
END as status, s.store_id 
from customer c
join store s using(address_id)
join address a using(address_id)
join city ci using(city_id)
join country co using(country_id);

select * from list_of_customers;

--2--Create a view named film_details, it should contain the following columns: 
--film id, title, description, category, price, length, rating, actors as a string of all the actors separated by comma. Hint use GROUP_CONCAT
create or replace view film_details as 
select f.film_id, f.title, f.description, c.name as category, p.amount as price, f.length, f.rating, GROUP_CONCAT(CONCAT('Nombre: ',a.first_name, ' ', a.last_name) ORDER BY a.first_name SEPARATOR ' , ') as 'Actors' 
from film f
join film_category using(film_id)
join category c using(category_id)
join film_actor using(film_id)
join actor a using(actor_id)
join inventory using(film_id)
join rental using(inventory_id)
join payment p using(rental_id)
GROUP BY film_id,name,amount,length,rating;

select * from film_details;

--3--Create view sales_by_film_category, it should return 'category' and 'total_rental' columns.
create or replace view sales_by_film_category as 
select c.name, SUM(pa.amount) as total_rental
from category c
join film_category using(category_id)
join film using(film_id)
join inventory using(film_id)
join rental using(inventory_id)
join payment pa using(rental_id)
GROUP BY name;

select * from sales_by_film_category;

--4--Create a view called actor_information where it should return, actor id, first name, last name and the amount of films he/she acted on.
create or replace view actor_information as 
select a.actor_id, CONCAT(a.first_name, ' ', a.last_name) as nombre_actor, count(film_id) as amount_of_films
from actor a
join film_actor using(actor_id)
join film using(film_id)
group by actor_id;

select * from actor_information;

--5--Analyze view actor_info, explain the entire query and specially how the sub query works. Be very specific, take some time and decompose each part and give an explanation for each.
select * from actor_info;

--6--Materialized views, write a description, why they are used, alternatives, DBMS were they exist, etc.
/*
 Las views son tablas almacenadas con datos de otras tablas, a través de consultas, para su uso cómodo y práctico. Son creadas con el fin de tener acceso a cantidades menores de datos de manera cómoda, fácil y práctica, se emplean cuando se va a trabajar con uno grupo reducido de datos de manera reiterada y se requiere su almacenamiento para agilizar las consultas y facilitar el trabajo a la hora de consultar los datos almacenados.
 Por ello, las views son utilizadas frecuentemente en todas las bases de datos que poseen grandes cantidades de datos o, en su defecto, emplean un grupo de datos de manera reiterada en sus consultas y demás.
 */