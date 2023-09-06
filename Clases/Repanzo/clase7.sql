use sakila;

# Find the films with less duration, show the title and rating.
select film_id, rating, title, length
from film
WHERE length < (SELECT MIN(length) FROM film);

#Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
select f1.title, f1.length
from film f1
where f1.length < (select MIN(f1.length)
                   from film)
  and not exists(select f1.film_id, f2.film_id from film f2 where f1.film_id <> f2.film_id and f1.length = f2.length);

#list of customers showing the lowest payments done by each of them.
# Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.

     select first_name, last_name,a.address, min(p.amount) as lowest from customer
         join address a on a.address_id = customer.address_id
        join payment p on customer.customer_id = p.customer_id
     group by first_name, last_name, a.address;

#Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.

 select first_name, last_name,a.address, min(p.amount) as lowest, max(p.amount) as max_amount from customer
         join address a on a.address_id = customer.address_id
        join payment p on customer.customer_id = p.customer_id
     group by first_name, last_name, a.address;