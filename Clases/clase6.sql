use sakila;
/*
Exercises

    
List the actors that acted in both 'BETRAYED REAR' and 'CATCH AMISTAD'
List all the actors that didn't work in 'BETRAYED REAR' or 'CATCH AMISTAD'
 */

#List all the actors that share the last name. Show them in order
select last_name, first_name from actor a where exists(
    select last_name from actor a2 where a.last_name = a2.last_name and a.actor_id <> a2.actor_id)
    order by last_name;

#Find actors that don't work in any film
select first_name, last_name from actor a where not exists(
    select film_id from film_actor where a.actor_id = film_id
)
    order by first_name, last_name;

#Find customers that rented only one film

select c.customer_id, c.first_name, c.last_name  from customer c
                      where exists(select COUNT(r.rental_id) from rental r where c.customer_id = r.customer_id having COUNT(r.rental_id) = 1)
order by c.first_name, c.last_name;

#Find customers that rented more than one film

select c.customer_id, c.first_name, c.last_name from customer c
where exists(select count(r.rental_id) as cantidad_rentas from rental r where c.customer_id=r.customer_id having cantidad_rentas > 1)
order by c.first_name, c.last_name;

#List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'

select a.actor_id, a.first_name, a.last_name from actor a
                                             where exists(select f.film_id from film f
                                                                           join film_actor fa on f.film_id = fa.film_id
                                                where f.film_id = a.actor_id
                                                and f.title = 'BETRAYED REAR' or f.title = 'CATCH AMISTAD')
order by a.first_name, a.last_name;

#List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
select a.actor_id, a.first_name, a.last_name from actor a
                                             where exists(select f.film_id from film f
                                                                           join film_actor fa on f.film_id = fa.film_id
                                                where f.film_id = a.actor_id
                                                and f.title = 'BETRAYED REAR' and not f.title = 'CATCH AMISTAD')
order by a.first_name, a.last_name;