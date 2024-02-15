-- Active: 1702945249657@@127.0.0.1@3306@sakila

/* 
 --7--Once you're done. Restore the database data using the populate script from class 3. */
use sakila;
/* --1--Add a new customer
 -To store 1
 -For address use an existing address. The one that has the biggest address_id in 'United States'*/
insert into
    customer (
        store_id,
        first_name,
        last_name,
        email,
        address_id,
        create_date
    )
VALUES
(
        1,
        'Lautaro',
        'Velez',
        'lautivelez28@gmail.com', (
            SELECT MAX(address_id)
            from address
        ), NOW()
    );
/*
 --2--Add a rental
 -Make easy to select any film title. I mean, I should be able to put 'film tile' in the where, and not the id.
 -Do not check if the film is already rented, just use any from the inventory, example, the one with highest id.
 -Select any staff_id from Store 2.
 */
INSERT INTO
    rental (
        rental_date,
        inventory_id,
        customer_id,
        staff_id
    )
VALUES(
    now(),(
        select film_id from film
        where title = 'ZORRO ARK'
    ),
    (select max(customer_id) from customer),
    2
);

select DISTINCT(rating) from film; 

/*
 --3--Update film year based on the rating
 -For example if rating is 'G' release date will be '2001'
 -You can choose the mapping between rating and year.
 -Write as many statements are needed.
 */

update film set release_year = 2005 where rating = 'PG';
update film set release_year = 2001 where rating = 'G';
update film set release_year = 2008 where rating = 'NC-17';
update film set release_year = 2010 where rating = 'PG-13';
update film set release_year = 2015 where rating = 'R';

/*
 --4--Return a film
 -Write the necessary statements and queries for the following steps.
 -Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
 -Use the id to return the film.*/


--esta query es para ver q films no estan devueltos y sacar el film_id y el rental_id ;)
select *, rental_id from inventory 
join rental USING(inventory_id)
where return_date is null
order by rental_id desc;

update rental set return_date = now() WHERE rental_id = 16050 and (select film_id from film where film_id = 223);

/*
 --5--Try to delete a film
 -Check what happens, describe what to do.
 -Write all the necessary delete statements to entirely remove the film from the DB.*/

 delete from film where film_id = 1 limit 1;
 
 --Cannot delete or update a parent row: a foreign key constraint fails (`sakila`.`film_actor`, CONSTRAINT `fk_film_actor_film` FOREIGN KEY (`film_id`) REFERENCES `film` (`film_id`) ON DELETE RESTRICT ON UPDATE CASCADE)

delete from film_actor where film_id = 1 limit 1;
delete from film_category where film_id = 1 limit 1;
delete from rental where inventory_id = (select inventory_id from inventory where film_id = 1 limit 1);
delete from inventory where film_id = 1 limit 1;
 delete from film where film_id = 1 limit 1;

 -- Lo que hicimos aquí arriba es eliminar todas las relaciones de la film con film_id = 1000 para poder eliminarla completamente de la DB.

/*
--6--Rent a film
 -Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
 -Add a rental entry
 -Add a payment entry
 -Use sub-queries for everything, except for the inventory id that can be used directly in the queries.
 */

 select inventory_id from rental where return_date is null;
 select * from rental where inventory_id = 2047 and return_date is null;
select * from inventory 
join rental using(inventory_id)
where return_date is null and inventory_id = 2047;

 insert into rental (
    rental_date,
    inventory_id,
    customer_id,
    staff_id
 )
 values (
    NOW(),
    2047,
    (select MAX(customer_id) from customer),
    (select MAX(staff_id) from staff)
 );

insert into payment (
    customer_id,
    staff_id,
    rental_id,
    amount,
    payment_date
)
values(
    (select MAX(customer_id) from customer),
    (select MAX(staff_id) from staff),
    (select MAX(rental_id) from rental),
    14.0,
    now()
);

select * from rental where inventory_id = 2047;
select * from payment where amount = 14.0;