-- Active: 1702945249657@@127.0.0.1@3306@sakila


use sakila;
--1--Write a query that gets all the customers that live in Argentina. Show the first and last name in one column, the address and the city.
select CONCAT(c.first_name, ' ', c.last_name) as nombre, a.address ,co.country,ci.city from customer c
join address a using (address_id)
join city ci using (city_id)
join country co using(country_id) 
where co.country = 'Argentina'
group by nombre, address, country,city;

--2--Write a query that shows the film title, language and rating. 
--Rating shall be shown as the full text described here: 
--https://en.wikipedia.org/wiki/Motion_picture_content_rating_system#United_States. Hint: use case.


select title, name,  
 CASE rating
    WHEN 'PG' THEN 'Parental Guidance Suggested'  
     WHEN 'G' THEN 'General Audiences'  
     WHEN 'PG-13' THEN 'Parents Strongly Cautioned'
     WHEN 'R' THEN 'Restricted'
     WHEN 'NC-17' THEN 'Adults Only'
END as rating
from film
join language using(language_id);

--3--Write a search query that shows all the films (title and release year) an actor was part of. 
--Assume the actor comes from a text box introduced by hand from a web page. 
--Make sure to "adjust" the input text to try to find the films as effectively as you think is possible.

select concat(a.first_name, ' ',a.last_name) as actor, 
GROUP_CONCAT(
    CONCAT(
        'Titulo: ',title,' Año: ', release_year
        )
         ORDER BY title SEPARATOR ' || ') as peliculas
from film
join film_actor fa using(film_id)
join actor a using(actor_id)
group by actor_id
order by actor;

--4--Find all the rentals done in the months of May and June. 
--Show the film title, customer name and if it was returned or not. 
--There should be returned column with two possible values 'Yes' and 'No'.

select * from rental where  MONTH(rental_date) = '05' OR MONTH(rental_date) = '06';

select f.title, concat(c.first_name, ' ',c.last_name) as customer_name, CASE
    WHEN return_date is null THEN 'NO'  
    ELSE  'YES'
END AS  returned
from film f
join inventory using(film_id)
join rental r using(inventory_id)
join customer c using(customer_id)
where  MONTH(rental_date) = '05' OR MONTH(rental_date) = '06';
--pense que iba con el group by pero no, no se por que pero bueno ya fue :P


--5--Investigate CAST and CONVERT functions. Explain the differences if any, write examples based on sakila DB.

/*
 Las diferencias entre las funciones CONVERT() y CAST() son las siguientes:
 CAST([value] AS [data_type])
 CONVERT([value], [data_type])
 Además, el Convert() permite utilizar codificaciones de caracteres como utf-8 o utf-16 con la siguiente sentencia:
 CONVERT([value] USING [transcoding_name])
 */
--6--Investigate NVL, ISNULL, IFNULL, COALESCE, etc type of function. Explain what they do. Which ones are not in MySql and write usage examples.
/*
 METHODS:
 - ISNULL([expression]) esta funcion devuelve un 1 si la expresion es nula o un 0 en caso contrario.
 - IFNULL([expression1], [expression2]) esta funcion devuelve la expresion 1 en caso de esta misma no ser nula, en caso contrario, devuelve la expresion 2.
 - COALESCE([value1], [value2], [value3], ...) esta funcion devuelve el primer valor que no sea nulo de la lista, en caso de ser todos nulos, devuelve NULL
 NOT SQL METHOD:
 - NVL() funciona exactamente igual que COALESCE() y es la funcion que no se encuentra dentro de MySQL
 */