-- Active: 1702945249657@@127.0.0.1@3306@sakila
--1--Find the films with less duration, show the title and rating.
--2--Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
--3--Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.
--4--Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.

use sakila;

--1--Find the films with less duration, show the title and rating.
select title, rating, length as less_duration from film 
where length <= (select MIN(length) from film);

select f1.title, f1.rating, MIN(f1.length) less_duration from film f1, film f2
where f1.film_id <> f2.film_id
group by f1.title, f1.rating
order by less_duration;

--2--Write a query that returns the title of the film which duration is the lowest. 
--If there are more than one film with the lowest duration, the query returns an empty resultset.

select title,length from film f1 
where length <= (select MIN(length) from film) and not EXISTS
(select f2.length from film f2 where f2.length <= f1.length and f1.film_id <> f2.film_id);

--trate de entender el 1 y el 2 pero no pude, me voy a dormir, 03:14am 19 de dic.
