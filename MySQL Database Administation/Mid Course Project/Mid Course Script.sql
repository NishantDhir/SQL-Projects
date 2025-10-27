USE Mavenmoviesmini;

/*
Take a look at the mavenmoviesmini schema. What do you notice about it? How many tables are there?
What does the data represent? What do you think about the current schema? */

Select * from inventory_non_normalized;

/* If you wanted to break out the data from the inventory_non_normalized table into multiple tables, how  many tables do you think would be ideal? What would you name those tables?  
Based on your answer from question #2, create a new schema with the tables you think will best serve this  data set. You can use SQL code or Workbench's Ul tools (whichever you feel more comfortable with). */ 

Select * from inventory_non_normalized;

/* Next, use the data from the original schema to populate the tables in your newly optimized schema
(TIP: Revisit the video on database normalization again if you get stuck) */

Create Schema mavenmoviesmini_normalized;

USE mavenmoviesmini_normalized;

CREATE TABLE mavenmoviesmini_normalized.inventory (
  inventory_id INT NOT NULL,
  film_id INT NOT NULL,
  store_id INT NOT NULL,
  PRIMARY KEY (inventory_id)
);

CREATE TABLE mavenmoviesmini_normalized.film (
  film_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description VARCHAR(255) NOT NULL,
  release_year INT NOT NULL,
  rental_rate DECIMAL(6,2) NOT NULL,
  rating VARCHAR(45) NOT NULL,
  PRIMARY KEY (film_id)
);

CREATE TABLE mavenmoviesmini_normalized.store(
  store_id INT NOT NULL,
  store_manager_first_name VARCHAR(45) NOT NULL,
  store_manager_first_last VARCHAR(45) NOT NULL,
  store_address VARCHAR(45) NOT NULL,
  store_district VARCHAR(45) NOT NULL,
  store_city VARCHAR(45) NOT NULL,
  PRIMARY KEY (store_id)
);

/* Make sure your new tables have the proper primary keys defined and that applicable foreign keys are added.
Add any constraints you think should apply to the data as well (unique, non-NIJLL, etc.) */

ALTER TABLE mavenmoviesmini_normalized.inventory
  ADD INDEX inventory_film_id_idx (film_id ASC) VISIBLE,
  ADD INDEX inventory_store_id_idx (store_id ASC) VISIBLE;

ALTER TABLE mavenmoviesmini_normalized.inventory
  ADD CONSTRAINT inventory_film_id
    FOREIGN KEY (film_id)
    REFERENCES mavenmoviesmini_normalized.film (film_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  ADD CONSTRAINT inventory_store_id
    FOREIGN KEY (store_id)
    REFERENCES mavenmoviesmini_normalized.store (store_id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE mavenmoviesmini_normalized.inventory
  DROP FOREIGN KEY inventory_film_id,
  DROP FOREIGN KEY inventory_store_id;

INSERT INTO Inventory (Inventory_id, film_id, store_id)
SELECT Distinct Inventory_id, film_id, store_id
FROM mavenmoviesmini.inventory_non_normalized;

SELECT * FROM INVENTORY;

INSERT INTO film (film_id, title, description, release_year, rental_rate, rating)
SELECT film_id, title, description, release_year, rental_rate, rating
FROM mavenmoviesmini.inventory_non_normalized;

INSERT INTO film (film_id, title, description, release_year, rental_rate, rating)
SELECT DISTINCT film_id, title, description, release_year, rental_rate, rating
FROM mavenmoviesmini.inventory_non_normalized
WHERE film_id NOT IN (SELECT film_id FROM film);

SELECT * from film;

INSERT INTO store (store_id, store_manager_first_name, store_manager_last_name, store_address, store_city, store_district)
SELECT store_id, store_manager_first_name, store_manager_last_name, store_address, store_city, store_district
FROM mavenmoviesmini.inventory_non_normalized;


/* Finally, after doing all of this technical work, write a brief summary of what you have done, in a way that your
non-technical client can understand. Communicate what you did, and why your new schema design is better. */

Previously, we had one table that was redundantly storing lots of information about the film titles, film descriptions which we consolidated.
The more impactful thing was store address, store manangers data was boiled down to just two records in the database instead of storing all the 
information 4500 times. We have also taken one inventory table non normalized and broken that into 3 tables with forgein keys which alows us to map 
to data that is stored in to other tables into film and store. This makes our database more efficient and will help business when it expands. 