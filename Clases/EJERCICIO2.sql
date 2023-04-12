-- Active: 1678142323458@@127.0.0.1@3306

DROP DATABASE IF EXISTS imdb;

CREATE DATABASE imdb IF NOT EXISTS;
USE imdb;

CREATE TABLE film(
    film_id int AUTO_INCREMENT PRIMARY KEY,
    descripcion text,
    release_year YEAR
);

CREATE TABLE actor(
    actor_id int AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);

CREATE TABLE film_actor(
    actor_id INT NOT NULL AUTO_INCREMENT,
    film_id INT NOT NULL AUTO_INCREMENT
);

ALTER TABLE ADD COLUMN last_update VARCHAR(50) TO film AND actor;
ALTER TABLE film_actor ADD FOREIGN KEY (`actor_id`) REFERENCES actor(`actor_id`);
ALTER TABLE film_actor ADD FOREIGN KEY (`film_id`) REFERENCES film(`film_id`);

INSERT INTO film (descripcion, release_year) VALUES ('The Shawshank Redemption', '1994');
INSERT INTO film (descripcion, release_year) VALUES ('The Godfather', '1972');
INSERT INTO film (descripcion, release_year) VALUES ('The Dark Knight', '2008');
INSERT INTO film (descripcion, release_year) VALUES ('Forrest Gump', '1994');
INSERT INTO film (descripcion, release_year) VALUES ('The Matrix', '1999');

INSERT INTO actor (first_name, last_name) VALUES ('Tom', 'Hanks');
INSERT INTO actor (first_name, last_name) VALUES ('Robert', 'De Niro');
INSERT INTO actor (first_name, last_name) VALUES ('Meryl', 'Streep');
INSERT INTO actor (first_name, last_name) VALUES ('Brad', 'Pitt');
INSERT INTO actor (first_name, last_name) VALUES ('Leonardo', 'DiCaprio');

INSERT INTO film_actor VALUES (1, 2);
INSERT INTO film_actor VALUES (2, 1);
INSERT INTO film_actor VALUES (3, 3);
