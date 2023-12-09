-- Part 1 - DATA CLEANING

-- by running this code, the entire sql script will be executed.
-- \i C:/Users/Dell/Desktop/Netflix/NETFLIX_DATA_CLEANING.sql


-- Step 1 - Creating a new database 'netflix'

DROP DATABASE netflix;
CREATE DATABASE netflix WITH OWNER arpita;

-- entering into the database 
\c netflix


-- Step 2 - Creating new tables in the database

-- dropping existing tables in the database

DROP TABLE IF EXISTS raw_titles CASCADE;
DROP TABLE IF EXISTS raw_credits CASCADE;

-- creating new tables to hold the raw data

CREATE TABLE raw_titles
(index INTEGER,
id VARCHAR(15),
title TEXT,
type VARCHAR(5),
release_year INTEGER,
age_certification VARCHAR(10),
runtime INTEGER,
genres VARCHAR(100),
production_countries VARCHAR(50),
seasons FLOAT,
imdb_id VARCHAR(15),
imdb_score FLOAT,
imdb_votes FLOAT
);

CREATE TABLE raw_credits(
index INTEGER,
person_id INTEGER,	
id VARCHAR(15),
name TEXT,
character TEXT,
role VARCHAR(8)
);

-- setting client encoding from 'WIN1252' to 'UTF8'

SHOW client_encoding;
SET client_encoding TO UTF8;



--Step 3 - loading the data into the raw_titles table

\copy raw_titles(index,id,title,type,release_year,age_certification,runtime,genres,production_countries,seasons,imdb_id,imdb_score,imdb_votes) FROM 'C:\Users\Dell\Desktop\Netflix\archive\raw_titles.csv' WITH DELIMITER ',' CSV HEADER;

\copy raw_credits(index,person_id,id,name,character,role) FROM 'C:\Users\Dell\Desktop\Netflix\archive\raw_credits.csv' WITH DELIMITER ',' CSV HEADER;

-- showing the first 10 rows from the tables

SELECT * 
FROM raw_titles 
LIMIT 10;

SELECT * 
FROM raw_credits 
LIMIT 10;



-- Step 4 - Checking the size of the dataset

SELECT COUNT(*) FROM raw_titles;
SELECT COUNT(*) FROM raw_credits;



-- Step 5  - Checking the data types

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'raw_titles';

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'raw_credits';



-- Step 6 - Removing the redundant columns

ALTER TABLE  raw_titles DROP COLUMN index;
ALTER TABLE raw_titles DROP COLUMN imdb_id;
ALTER TABLE raw_credits DROP COLUMN index;



-- Step 7 - Looking for null values

-- from raw_titles table

SELECT COUNT(*) FROM raw_titles WHERE id IS NULL;
SELECT COUNT(*) FROM raw_titles WHERE title IS NULL;
SELECT COUNT(*) FROM raw_titles WHERE type IS NULL;
SELECT COUNT(*) FROM raw_titles WHERE release_year IS NULL;
SELECT COUNT(*) FROM raw_titles WHERE runtime = 0;
SELECT COUNT(*) FROM raw_titles WHERE genres IS NULL;
SELECT COUNT(*) FROM raw_titles WHERE genres= '[]';
SELECT COUNT(*) FROM raw_titles WHERE production_countries IS NULL;
SELECT COUNT(*) FROM raw_titles WHERE production_countries= '[]';
SELECT type, COUNT(*) AS nulls FROM raw_titles WHERE seasons IS NULL GROUP BY type; 
SELECT COUNT(*) FROM raw_titles WHERE imdb_score IS NULL AND imdb_votes IS NULL;
SELECT COUNT(*) FROM raw_titles WHERE imdb_score IS NULL OR imdb_votes IS NULL;

-- from raw_credits table

SELECT COUNT(*) FROM raw_credits WHERE person_id IS NULL;
SELECT COUNT(*) FROM raw_credits WHERE id IS NULL;
SELECT COUNT(*) FROM raw_credits WHERE name IS NULL;
SELECT COUNT(*) FROM raw_credits WHERE character IS NULL;



-- Step 8 - Deleting the null values

DELETE FROM raw_titles
WHERE title IS NULL 
       OR runtime = 0 
       OR imdb_score IS NULL
       OR imdb_votes IS NULL;



-- Step 9 - Looking for duplicates

-- in raw_titles table

SELECT id, COUNT(id) as count
FROM raw_titles
GROUP BY id
HAVING COUNT(id) >1 ;

-- In raw_credits table

-- This SQL code is selecting id, person_id, and the count of each group as count 
-- from the raw_credits table. The GROUP BY clause groups the rows by id, person_id, 
-- and role. The HAVING clause filters the groups with a count greater than 1.

SELECT id, person_id, COUNT(*) as count
FROM raw_credits
GROUP BY id, person_id, role
HAVING COUNT(*) > 1
ORDER BY count desc limit 10;


-- instances of duplicate values differing only in character or role column

SELECT t.title, c.name, c.character, c.role
FROM raw_titles t
JOIN raw_credits c ON t.id = c.id
WHERE c.id ='tm127384' AND c.person_id =11475;

SELECT t.title, c.name, c.character, c.role
FROM raw_titles t
JOIN raw_credits c ON t.id = c.id
WHERE c.id ='tm226362' AND c.person_id =307659;

SELECT t.title, c.name, c.character, c.role
FROM raw_titles t
JOIN raw_credits c ON t.id = c.id
WHERE c.id ='tm228574' AND c.person_id =65832;



-- Step 10 - Capitalizing the values

UPDATE raw_titles SET type = initcap(type);
UPDATE raw_titles SET title= initcap(title);
UPDATE raw_titles SET genres= initcap(genres);
UPDATE raw_credits SET role = initcap(role);
UPDATE raw_credits SET name = initcap(name);



-- Step 11 - Trimming leading and trailing spaces

UPDATE raw_credits SET name = TRIM(name);
UPDATE raw_credits SET character = TRIM(character);
UPDATE raw_titles SET title = TRIM(title);
UPDATE raw_titles SET genres = TRIM(genres);



-- Step 12 - Replacing the Null Values

-- Setting the null values in character column to 'No information'
UPDATE raw_credits 
SET character = 'N/A' 
WHERE character IS NULL;

-- Setting the values in character column to 'Director' where role is Director
UPDATE raw_credits 
SET character = 'Director' 
WHERE role = 'Director';

-- Setting the null values in seasons to 0 which corresponds to Movies
UPDATE raw_titles 
SET seasons = 0 
WHERE seasons IS NULL;

-- Setting the null values in age_certification to 'Others'
UPDATE raw_titles 
SET age_certification = 'Others' 
WHERE age_certification IS NULL;

-- Setting the values with [] in genres column with 'N/A'
UPDATE raw_titles 
SET genres = 'N/A' 
WHERE genres = '[]';

-- Setting the values with [] in production_countries column with 'N/A'
UPDATE raw_titles 
SET production_countries = 'N/A' 
WHERE production_countries = '[]';




-- Step 13 - Removing the [ ] and ' ' from production_countries and genre columns

-- adding two new columns 'country' and 'genre' to hold the cleaned values

ALTER TABLE raw_titles ADD COLUMN country TEXT;
ALTER TABLE raw_titles ADD COLUMN genre TEXT;

-- The given SQL code updates the `country` column of the `raw_titles` table.
-- It sets the value of `country` to a substring of the `production_countries` column, 
-- starting from the second character and ending at the second last character. 
-- The `WHERE` clause ensures that only those rows are updated where the value of the `id` column is equal to itself.
-- The same is done to remove '' from the strings.

UPDATE raw_titles 
SET country = SUBSTRING(production_countries, 2, (length(production_countries)-2)) 
WHERE id=id;

UPDATE raw_titles 
SET genre = SUBSTRING(genres, 2, (length(genres)-2)) 
WHERE id=id;

UPDATE raw_titles
SET genre = REPLACE(genre, '''', '')
WHERE genre LIKE '%''%';

UPDATE raw_titles
SET country = REPLACE(country, '''', '')
WHERE country LIKE '%''%';

-- In the country column the entry for country code 'LB' was written as 'Lebanon'. Updating the data with 'LB'

UPDATE raw_titles 
SET country = 'LB' 
WHERE country='Lebanon';



-- Step 14 - Looking closely at some unusual titles
-- There are 4 shows/movies with names formatted as dates.
-- A left join from (raw_titles to raw_credits) is used to get all the information.

SELECT t.id, t.title, t.runtime,t.release_year, c.person_id, c.id, c.name, c.character, c.role
FROM raw_titles t 
LEFT JOIN raw_credits c
ON t.id=c.id
WHERE t.id IN ('tm197423','tm461427', 'tm348993','tm1011248');

-- Renaming title '30 March' to 30.March

UPDATE raw_titles 
SET title = '30.March' 
WHERE title = '30 March';



-- Step 15- Some more unusual titles starting with '#'

-- The SQL query selects the title column from the raw_titles table. 
-- The WHERE clause filters out the rows where the title column starts 
-- with a digit or an uppercase letter.

SELECT title 
FROM raw_titles 
WHERE title ~ '^#' 
ORDER BY title;

-- trimming the # from the Left hand side of the titles

UPDATE raw_titles 
SET title = LTRIM(title, '#') 
WHERE title ~ '^#';



-- Step-16 Removing the extra columns

ALTER TABLE raw_titles DROP COLUMN genres;
ALTER TABLE raw_titles DROP COLUMN production_countries;



--Step - 17 Concatenating the character column
-- creating a new credits table to hold the concatenated entries
DROP TABLE IF EXISTS credits;

CREATE TABLE credits (
person_id INTEGER, 
id VARCHAR(20), 
name TEXT, 
role VARCHAR(8), 
character TEXT);

-- The query groups the rows in the raw_credits table by person_id,id,name and role
-- and concatenate the values in the character column for each group using the
-- string_agg function and inserts them into the credits table.

INSERT INTO credits (person_id, id, name,role, character) 
SELECT person_id, id, name, role, STRING_AGG(character, ' / ') 
FROM raw_credits 
GROUP BY person_id, id, name, role;

--  the query returns the cleaned data with one character row per id and person_id

SELECT * 
FROM credits 
WHERE person_id = 307659 AND id = 'tm226362';



-- Step-18 Looking for duplicates in the new 'credits' table

SELECT id, person_id, COUNT(*) AS count 
FROM credits 
GROUP BY id, person_id 
HAVING COUNT(*) >1 
ORDER BY COUNT(*) DESC 
LIMIT 10;



-- Step - 19 Creating the cleaned 'titles' table

DROP TABLE IF EXISTS titles;

-- This query creates an exact copy of the raw_titles table with all the columns.

CREATE TABLE titles (LIKE raw_titles including all);

-- Inserting the modified data from raw_titles table to title table to work with them later on.

INSERT INTO titles(id,title,type,release_year,age_certification,runtime,seasons,imdb_score,imdb_votes,country,genre) 
SELECT * 
FROM raw_titles 
WHERE id = id;



--Step - 20 Checking for null values in cleaned tables

SELECT * 
FROM titles 
WHERE title IS NULL 
OR type IS NULL 
OR age_certification IS NULL 
OR runtime = 0 
OR seasons IS NULL 
OR country IS NULL 
OR genre IS NULL 
OR type IS NULL 
OR imdb_score IS NULL 
OR imdb_votes IS NULL ;

SELECT * 
FROM raw_credits 
WHERE name IS NULL 
OR character IS NULL 
OR role IS NULL;



-- Step 21 - Fine Adjustments

UPDATE titles SET genre = 'N/A' WHERE genre = '/';
UPDATE titles SET country = 'N/A' WHERE country = '/';
UPDATE credits SET character = 'N/A' WHERE character = '--';



-- Step - 22 Importing the new tables as csv files

\copy titles TO 'C:/Users/Dell/Desktop/Netflix/titles_cleaned.csv' DELIMITER ',' CSV HEADER;
\copy credits TO 'C:/Users/Dell/Desktop/Netflix/credits_cleaned.csv' DELIMITER ',' CSV HEADER;
