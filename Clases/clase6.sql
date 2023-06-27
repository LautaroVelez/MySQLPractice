use sakila;
/*
Exercises

    
Find customers that rented only one film
Find customers that rented more than one film
List the actors that acted in 'BETRAYED REAR' or in 'CATCH AMISTAD'
List the actors that acted in 'BETRAYED REAR' but not in 'CATCH AMISTAD'
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

