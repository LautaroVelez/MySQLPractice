DROP DATABASE IF EXISTS imdb;
     CREATE DATABASE imdb;

CREATE TABLE IF NOT EXISTS film(
    film_id int PRIMARY KEY  AUTO_INCREMENT,
    title VARCHAR(50) NOT NULL,
    description VARCHAR(120),
    release_year DATE,
);

CREATE TABLE IF NOT EXISTS actor(
    actor_id int PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(20),
    last_name VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS film_actor(
    actor_id int,
    film_id int,
    FOREIGN KEY (film_id) REFERENCES film(film_id),
    FOREIGN KEY (actor_id) REFERENCES actor(actor_id)
);

ALTER TABLE film ADD last_update DATE AFTER release_year;
ALTER TABLE actor ADD last_update DATE AFTER last_name;

ALTER TABLE film_actor ADD FOREIGN KEY (film_id) REFERENCES film(filml_id);
ALTER TABLE film_actor ADD FOREIGN KEY (actor_id) REFERENCES actor(actor_id);

INSERT INTO film