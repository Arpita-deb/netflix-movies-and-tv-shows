--Part 2 - Data Normalization

-- connecting first to netflix database
\c netflix

-- by running the code the entire sql script will be executed
-- \i C:/Users/Dell/Desktop/Netflix/NETFLIX_DATA_NORMALIZATION.sql

SET client_encoding TO UTF8;


-- Step 1 - creating a view with common data from titles and credits table

DROP VIEW netflix CASCADE;

CREATE VIEW netflix AS 
SELECT t.id, t.title,t.type, t.release_year, t.age_certification,t.runtime,t.seasons, t.imdb_score, t.imdb_votes, t.genre, t.country,c.person_id, c.name,c.role,c.character
FROM credits c
INNER JOIN titles t
ON c.id = t.id;

SELECT * FROM netflix LIMIT 10;


-- Step 2 - creating a view where the genre column is unnested

DROP VIEW genre_unnested CASCADE;

CREATE VIEW genre_unnested AS 
(SELECT id, title,type, release_year, age_certification,runtime,seasons, imdb_score, imdb_votes,unnest(string_to_array(genre,', ')) AS genre, country,person_id, name,role,character
FROM netflix);


-- Step 3 -  creating a view where the country column is unnested

DROP VIEW country_unnested CASCADE;

CREATE VIEW country_unnested AS 
(SELECT id, title,type, release_year, age_certification,runtime,seasons, imdb_score, imdb_votes,genre, unnest(string_to_array(country,', ')) AS country,person_id, name,role,character
FROM genre_unnested);


SELECT * FROM country_unnested LIMIT 15;



-- Step 4 - changing the view into a table to add the foreign keys

DROP TABLE netflix_table CASCADE;

CREATE TABLE netflix_table AS SELECT * FROM country_unnested;

-- adding two columns to hold the foreign keys genre_id and country_id

ALTER TABLE netflix_table ADD COLUMN genre_id integer;

ALTER TABLE netflix_table ADD COLUMN country_id integer;

-- saving the view as a csv file on desktop

-- \COPY (SELECT * FROM netflix_table) TO 'C:/Users/Dell/Desktop/Netflix/netflix_joined_data.csv' DELIMITER ',' CSV HEADER;

-- \COPY (SELECT * FROM country) TO 'C:/Users/Dell/Desktop/Netflix/country.csv' DELIMITER ',' CSV HEADER;

-- To be updated once data is inserted in the leaf tables

--UPDATE netflix_table SET country_id =(SELECT country.id FROM country WHERE netflix_table.country = country.country_code) ;

--UPDATE netflix_table SET genre_id =(SELECT genre.id FROM genre WHERE netflix_table.genre = genre.genre) ;



-- Step 5 - dropping the unnecessary views

DROP VIEW netflix CASCADE;
DROP VIEW genre_unnested CASCADE;
DROP VIEW country_unnested CASCADE;



-- Step 6 - Creating the leaf tables

DROP TABLE IF EXISTS show CASCADE;
DROP TABLE IF EXISTS director CASCADE;
DROP TABLE IF EXISTS actor CASCADE;
DROP TABLE IF EXISTS type CASCADE;
DROP TABLE IF EXISTS age_certification CASCADE;
DROP TABLE IF EXISTS country CASCADE;
DROP TABLE IF EXISTS genre CASCADE;


CREATE TABLE director (person_id INTEGER,
name TEXT,
PRIMARY KEY(person_id)
);

CREATE TABLE actor(person_id INTEGER,
name TEXT,
PRIMARY KEY(person_id)
);


CREATE TABLE type(id SERIAL,
type VARCHAR(5) UNIQUE,
PRIMARY KEY(id)
);

CREATE TABLE age_certification(id SERIAL,
age_certification VARCHAR(10) UNIQUE,
PRIMARY KEY(id)
);

CREATE TABLE country(id SERIAL,
country_code VARCHAR(3) UNIQUE,
country_name TEXT UNIQUE,
PRIMARY KEY(id)
);

CREATE TABLE genre(id SERIAL,
genre TEXT UNIQUE,
PRIMARY KEY(id)
);

CREATE TABLE show (serial_id SERIAL,
show_id VARCHAR(15),
title TEXT,
runtime INTEGER,
seasons INTEGER,
release_year INTEGER,
type VARCHAR(5),
age_certification VARCHAR(10),
imdb_score FLOAT,
imdb_votes FLOAT,
PRIMARY KEY(show_id),
type_id INTEGER REFERENCES type(id) ON DELETE CASCADE,  
certification_id INTEGER REFERENCES age_certification(id) ON DELETE CASCADE
);



-- Step 7 - inserting values into the tables

INSERT INTO type(type) 
SELECT DISTINCT type 
FROM netflix_table 
ORDER BY type;

SELECT * FROM type;

INSERT INTO age_certification(age_certification) 
SELECT DISTINCT age_certification 
FROM netflix_table 
ORDER BY age_certification;

SELECT * FROM age_certification;

INSERT INTO genre (genre) 
SELECT DISTINCT genre 
FROM netflix_table 
ORDER BY genre ; 

SELECT * FROM  genre ;

INSERT INTO country (country_code) 
SELECT DISTINCT country 
FROM netflix_table 
ORDER BY country ; 

SELECT * FROM country LIMIT 10;

INSERT INTO director(person_id, name) 
SELECT person_id, name 
FROM netflix_table 
WHERE role = 'Director' 
GROUP BY person_id, name 
ORDER BY person_id;

SELECT * FROM director LIMIT 10;

INSERT INTO actor(person_id, name) 
SELECT person_id, name 
FROM netflix_table 
WHERE role = 'Actor' 
GROUP BY person_id, name 
ORDER BY person_id;

SELECT * FROM actor LIMIT 10;

INSERT INTO show(show_id,title, runtime, seasons, release_year,type,age_certification, imdb_score, imdb_votes) 
SELECT id, title, runtime, seasons, release_year, type,age_certification, imdb_score, imdb_votes 
FROM netflix_table 
GROUP BY id, title, runtime, seasons, release_year,type,age_certification, imdb_score, imdb_votes 
ORDER BY id;

UPDATE show SET type_id = (SELECT type.id FROM type WHERE show.type = type.type);

UPDATE show SET certification_id = (SELECT age_certification.id FROM age_certification WHERE show.age_certification =age_certification.age_certification);

SELECT * FROM show LIMIT 10;



-- Step 8 - deleting the redundant columns from show

ALTER TABLE show DROP COLUMN type;
ALTER TABLE show DROP COLUMN age_certification;



-- Step 9 - Updating the country_id and genre_id in netflix table 

UPDATE netflix_table 
SET country_id =(SELECT country.id 
                 FROM country 
                 WHERE netflix_table.country = country.country_code) ;

UPDATE netflix_table 
SET genre_id =(SELECT genre.id 
               FROM genre 
               WHERE netflix_table.genre = genre.genre) ;




-- Step 10 - creating linking tables to create many-to-many relation between shows, genre, country, actor and director tables


-- Creating show_genre table and inserting values into it from netflix_table

DROP TABLE IF EXISTS show_genre CASCADE;

CREATE TABLE show_genre (
show_id VARCHAR(15) REFERENCES show(show_id) ON DELETE CASCADE,
genre_id INTEGER REFERENCES genre(id) ON DELETE CASCADE
);

INSERT INTO show_genre (show_id, genre_id) SELECT DISTINCT id, genre_id from netflix_table order by id, genre_id;

SELECT * FROM show_genre LIMIT 10;

SELECT s.title, g.genre
FROM show_genre sg
JOIN show s ON sg.show_id = s.show_id
JOIN genre g ON sg.genre_id = g.id
LIMIT 5;


-- Creating show_country table and inserting values into it from netflix_table

DROP TABLE IF EXISTS show_country CASCADE;

CREATE TABLE show_country (
show_id VARCHAR(15) REFERENCES show(show_id) ON DELETE CASCADE,
country_id INTEGER REFERENCES country(id) ON DELETE CASCADE
);

INSERT INTO show_country (show_id, country_id) SELECT DISTINCT id, country_id from netflix_table order by id, country_id;

SELECT * FROM show_country LIMIT 10;

SELECT s.title, c.id, c.country_code
FROM show_country sc
JOIN show s ON sc.show_id = s.show_id
JOIN country c ON sc.country_id = c.id
LIMIT 5;


-- Creating show_actor table and inserting values into it from netflix_table

DROP TABLE IF EXISTS show_actor CASCADE;

CREATE TABLE show_actor (
show_id VARCHAR(15) REFERENCES show(show_id) ON DELETE CASCADE,
actor_id INTEGER REFERENCES actor(person_id) ON DELETE CASCADE,
character TEXT);

INSERT INTO show_actor (show_id, actor_id,character) SELECT DISTINCT id, person_id, character FROM netflix_table WHERE role = 'Actor' order by id, person_id;

SELECT * FROM show_actor LIMIT 10;

SELECT s.title, a.name, sa.character
FROM show_actor sa
JOIN show s ON sa.show_id = s.show_id
JOIN actor a ON sa.actor_id = a.person_id
LIMIT 15;


-- Creating show_director table and inserting values into it from netflix_table

DROP TABLE IF EXISTS show_director CASCADE;

CREATE TABLE show_director (
show_id VARCHAR(15) REFERENCES show(show_id) ON DELETE CASCADE,
director_id INTEGER REFERENCES director(person_id) ON DELETE CASCADE
);

INSERT INTO show_director (show_id, director_id) SELECT DISTINCT id, person_id from netflix_table where role = 'Director' order by id, person_id;

SELECT * FROM show_director LIMIT 10;

SELECT s.title, d.name
FROM show_director sd
JOIN show s ON sd.show_id = s.show_id
JOIN director d ON sd.director_id = d.person_id
ORDER BY sd.show_id
LIMIT 20;



--  Step 11 - creating ISO table to fill the country_name column in country table

-- Creating iso table and inserting values into it from iso csv file

DROP TABLE IF EXISTS iso;

CREATE TABLE iso (id SERIAL,
English_short_name TEXT, 
Alpha_2_code TEXT, 
Alpha_3_code TEXT,
Numeric_code INTEGER,
Link_to_ISO_3166_2_subdivision_codes TEXT,
Independent TEXT);

\copy iso(English_short_name,Alpha_2_code,Alpha_3_code,Numeric_code,Link_to_ISO_3166_2_subdivision_codes,Independent) FROM 'C:\Users\Dell\Desktop\Netflix\iso.csv'  WITH DELIMITER ',' CSV HEADER ENCODING 'windows-1251';


UPDATE country SET country_name = (SELECT English_short_name FROM iso WHERE iso.Alpha_2_code=country.country_code);



-- Step 12 - Fine Adjustments

UPDATE country SET country_name = LTRIM(country_name , '┬á');

UPDATE country SET country_name = 'Unknown states' WHERE country_code = 'XX';

UPDATE country SET country_name = 'No information' WHERE country_code = 'N/A';

UPDATE country SET country_name = 'Unknown country' WHERE country_code = 'SU';

UPDATE country SET country_name = 'Turkiye' WHERE country_name = 'T╤îrkiye';

SELECT * FROM country WHERE country_name ~ '[[b]]$';

UPDATE country SET country_name = RTRIM(country_name, '[b]') WHERE country_name ~ '[[b]]$';

SELECT * FROM country WHERE country_name ~ ',.*';

UPDATE country SET country_name = REGEXP_REPLACE(country_name , ',.*', '');

UPDATE country SET country_name = 'Venezuela' WHERE country_name = 'Venezuela (Bolivarian Republic of)';

UPDATE country SET country_name = 'Iran' WHERE country_name = 'Iran (Islamic Republic of)';

SELECT * FROM country LIMIT 10;
