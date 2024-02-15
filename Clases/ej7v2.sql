--1--Find the films with less duration, show the title and rating.
--2--Write a query that returns the tiltle of the film which duration is the lowest. If there are more than one film with the lowest durtation, the query returns an empty resultset.
--3--Generate a report with list of customers showing the lowest payments done by each of them. Show customer information, the address and the lowest amount, provide both solution using ALL and/or ANY and MIN.
--4--Generate a report that shows the customer's information with the highest payment and the lowest payment in the same row.

use sakila;

--1--Encuentra las películas con menor duración, muestra el título y la clasificación.

select title, rating, length as lowest_duration from film where length <= (select MIN(length) from film);


--2--Escribe una consulta que devuelva el título de la película cuya duración sea la más baja. 
--Si hay más de una película con la duración más baja, la consulta devuelve un conjunto de resultados vacío.

select title, length from film f1 where length < (select MIN(length) from film f2)
 and not exists(select f1.film_id, f2.film_id from film f2 where f1.film_id <> f2.film_id and f1.length = f2.length);
 --no se para que es esto pero es toda una misma query
--el primer renglon lo hice yo, el segundo ya no.

--3--Genera un informe con la lista de clientes que muestra los pagos más bajos realizados por cada uno de ellos. 
--Muestra la información del cliente, la dirección y el monto más bajo. Proporciona soluciones utilizando ALL y/o ANY y MIN.

select c.first_name, c.last_name, address, MIN(amount) as lowest from customer c
join address a on c.address_id = a.address_id
join payment p on c.customer_id = p.customer_id
group BY c.first_name, c.last_name, address;


--4--Genera un informe que muestre la información del cliente con el pago más alto y el pago más bajo en la misma fila.
select c.first_name, c.last_name, MIN(amount) as lowest, MAX(amount) as highest from customer c
join payment p on c.customer_id = p.customer_id
group by c.first_name, c.last_name;