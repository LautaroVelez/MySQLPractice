-- Active: 1702945249657@@127.0.0.1@3306@sakila
## Exercises
 --1. List all the actors that share the last name. Show them in order
 --2. Find actors that don't work in any film
 --3. Find customers that rented only one film
 --4. Find customers that rented more than one film
 --5. List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
 --6. List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
 --7. List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
 --8. List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'	

use sakila;
--1. List all the actors that share the last name. Show them in order

  select a1.first_name, a1.last_name from actor a1 
  where EXISTS (select a2.last_name from actor a2 where a1.last_name = a2.last_name and a1.actor_id <> a2.actor_id)
  order by a1.last_name;

--2. Find actors that don't work in any film

select a.first_name, a.last_name from actor a 
where not exists (select f.film_id from film f,film_actor fa where f.film_id = fa.film_id and a.actor_id = fa.actor_id)

 --3. Find customers that rented only one film
select c.first_name, c.last_name from customer c 
where EXISTS (select r.customer_id from rental r where c.customer_id = r.customer_id group by r.customer_id HAVING count(*) = 1)

 --4. Find customers that rented more than one film
select c.first_name, c.last_name from customer c 
where EXISTS (select r.customer_id from rental r where c.customer_id = r.customer_id group by r.customer_id HAVING count(*) > 1)

 --5. List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
select a.first_name, a.last_name from actor a 
where exists (select f.film_id from film f 
join film_actor fa on f.film_id=fa.film_id 
where fa.actor_id = a.actor_id 
and (f.title = 'BETRAYED REAR' or f.title = 'CATCH AMISTAD'));

 --6. List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
select a.first_name, a.last_name from actor a 
where exists (select f.film_id from film f 
join film_actor fa on f.film_id=fa.film_id 
where fa.actor_id = a.actor_id 
and (f.title = 'BETRAYED REAR'));

--7. List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'

select a.first_name, a.last_name from actor a 
where exists (select f.film_id from film f 
join film_actor fa on f.film_id=fa.film_id 
where fa.actor_id = a.actor_id 
and (f.title = 'BETRAYED REAR' and f.title = 'CATCH AMISTAD'));

 --8. List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'	
 select a.first_name, a.last_name from actor a 
where exists (select f.film_id from film f 
join film_actor fa on f.film_id=fa.film_id 
where fa.actor_id = a.actor_id 
and not (f.title = 'BETRAYED REAR' and f.title = 'CATCH AMISTAD'));