 /* 
--2--Add a rental
-Make easy to select any film title. I.e. I should be able to put 'film tile' in the where, and not the id.
-Do not check if the film is already rented, just use any from the inventory, e.g. the one with highest id.
-Select any staff_id from Store 2.

 --3--Update film year based on the rating
-For example if rating is 'G' release date will be '2001'
-You can choose the mapping between rating and year.
-Write as many statements are needed.
 
 --4--Return a film
-Write the necessary statements and queries for the following steps.
-Find a film that was not yet returned. And use that rental id. Pick the latest that was rented for example.
-Use the id to return the film.

--5--Try to delete a film
-Check what happens, describe what to do.
-Write all the necessary delete statements to entirely remove the film from the DB.
 
 --6--Rent a film
-Find an inventory id that is available for rent (available in store) pick any movie. Save this id somewhere.
-Add a rental entry
-Add a payment entry
-Use sub-queries for everything, except for the inventory id that can be used directly in the queries.
 
 
--7--Once you're done. Restore the database data using the populate script from class 3. */
use sakila;
 /* --1--Add a new customer
-To store 1
-For address use an existing address. The one that has the biggest address_id in 'United States'*/

insert into customer 