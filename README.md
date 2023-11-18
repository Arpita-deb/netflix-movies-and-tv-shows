# WHAT TO WATCH ON NETFLIX NEXT? 
## Data Analysis of the largest video streaming service

![Netflix logo](https://logos-world.net/wp-content/uploads/2020/04/Netflix-Logo-2014-present.jpg)

# Introduction:

Netflix is an American subscription video on-demand over-the-top streaming service which  was launched on January 16, 2007,. The service primarily distributes original and acquired films and television shows from various genres, and it is available internationally in multiple languages.[6]

Netflix is the most-subscribed video on demand streaming media service, with 238.39 million paid memberships in more than 190 countries. By 2022, "Netflix Original" productions accounted for half of its library in the United States and the namesake company had ventured into other categories, such as video game publishing of mobile games via its flagship service. As of October 2023, Netflix is the 24th most-visited website in the world with 23.66% of its traffic coming from the United States, followed by the United Kingdom at 5.84% and Brazil at 5.64%.

# Objective:

The goal of this project is to find the answers to these following questions -

1. What is the total number of movies and TV shows available on Netflix?
2. How has the distribution of content (movies and TV shows) changed over time? For example, how many movies and TV shows were released in each decade?
3. What are the most common genres of movies and TV shows on Netflix?
4. Which country produces the most movies and TV shows on Netflix?
5. What is the average duration of movies and TV shows on Netflix?
6. What are the top-rated movies on Netflix?
7. What are the most popular ratings on Netflix?
8. What are the most and least popular genres on Netflix?
9. Which were the top years in terms of the number of titles released?
10. Which actor/director has most films/series in Netflix?

# Tools used:

1. Google Slides - to create the project proposal
2. PostgreSQL (SQL Shell) - for data cleaning, data normalization and analysis process
3. Tableau - to create data visualization
4. GitHub - for documentation 

# Methodologies used:

1. Data Cleaning
2. Data Manipulation
3. Database design and Normalization
4. Exploratory Data Analysis
5. Data Visualization
6. Documentation

# Deliverables:

1. A Project Proposal
2. A cleaned dataset
3. Normalized data in PostgreSQL database
4. A full documentation of data cleaning and analysis process
5. Data visualizations and dashboard in Tableau

# About the dataset:

The dataset contains 6 files in total namely -
* Best Movie by Year Netflix.csv
* Best Movies Netflix.csv
* Best Show by Year Netflix.csv
* Best Shows Netflix.csv
* raw_credits.csv
* raw_titles.csv

For this analysis I'll be using 2 raw files raw_credits and raw_titles which contain 5806 entries of movies/shows in raw_title and 77,214 entries for actors/directors in raw_credits respectively.

## Data Dictionary:

### 1. raw_titles

| Column name | Datatype | Type | Description |
| :--- | :--- | :--- | :--- |
| index | integer | NON NULLABLE| index of the rows |
| id | string | NON NULLABLE | unique id for each entry |
| title | string | NON NULLABLE	| The title of the movie or TV show |
| type | string | NON NULLABLE |	The type of the movie or TV show |
| release_year | integer | NON NULLABLE	| The year the movie or TV show was released |
| age_certification	| string | NULLABLE | The age certification of the movie or TV show |
| runtime | integer | NON NULLABLE |	The runtime of the movie or TV show |
| genres | string | NULLABLE | The genres of the movie or TV show |
| production_countries | string | NULLABLE | The production countries of the movie or TV show |
| seasons	| integer | NULLABLE | The number of seasons of the TV show |
| imdb_score | float | NON NULLABLE | The IMDB score of the movie or TV show |
| imdb_votes | integer | NON NULLABLE	| The number of IMDB votes of the movie or TV show |

### 2. raw_credits

| Column name | Datatype | Type | Description |
| :--- | :--- | :--- | :--- |
| index | integer | NON NULLABLE| index of the rows |
| person_id | integer | NON NULLABLE | unique id for each entry |
| id | integer | NON NULLABLE | id of the movie/show|
| name | string | NON NULLABLE | The name of the actor or actress |
|character | string | NULLABLE |The character the actor or actress played in the movie or TV show |
| role | string | NON NULLABLE | The role the actor or actress played in the movie or TV show |

## Data Integrity:

* **Reliability and Originality**:
  The raw dataset is created and updated by Eduardo Gonzalez. It has 6 files. For this analysis only 2 of them are used, *raw_titles* which contains 5806 entries of movies/shows in raw_title and *raw_credits* contains 77,214 entries for actors/directors.

* **Comprehensiveness**:
  This dataset contains information on all of the movies and TV shows available on Netflix as of May 2022. 

* **Citation**:
  There are citation available on Kaggle and data.world.

* **Current**:
  The dataset is updated upto 2022. So it is quite current.

# Data cleaning:

## Step 1 - Making a backup copy of the original data in csv format.

## Step 2 - Creating a new database called 'netflix' in PostgreSQL Database system 
    
    DROP DATABASE netflix; -- In order to remove an existing database
    CREATE DATABASE netflix WITH OWNER arpita;
    \c netflix  -- entering into the database

## Step 3 - Creating the tables to hold the data loaded from csv files
    
    DROP TABLE IF EXISTS raw_titles CASCADE;
    DROP TABLE IF EXISTS raw_credits CASCADE;
 
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
     imdb_votes INTEGER
    );

    CREATE TABLE raw_credits(
     index INTEGER,
     person_id INTEGER,	
     id VARCHAR(15),
     name TEXT,
     character TEXT,
     role VARCHAR(8)
    );

    set client_encoding to UTF8; -- While importing the data from csv file to database, an error occured, which showed that the client encoding i.e the format of the data in csv file, was set on WIN1252. To work in the database it needed to change into UTF8.

Loading the data into the raw_titles table - 
   
    \copy raw_titles(index, id, title, type, release_year, age_certification, runtime, genres, production_countries, seasons, imdb_id, imdb_score, imdb_votes) FROM 'C:\Users\Dell\Downloads\archive\raw_titles.csv' WITH DELIMITER ',' CSV HEADER;

Loading the data into the raw_credits table - 
     
     \copy raw_credits(index, person_id, id, name, character, role) FROM 'C:\Users\Dell\Downloads\archive\raw_credits.csv' WITH DELIMITER ',' CSV HEADER;

## Step 4 - Cleaning the data

### 4.1. Checking the size of the dataset

    SELECT COUNT(*) FROM raw_titles; -- returns 5806

There are 5806 items in the raw_titles table.
    
    SELECT COUNT(*) FROM raw_credits; -- returns 77213

There are information of 77,213 actors/directors in raw_credits table.

### 4.2. Checking the datatypes

    SELECT COLUMN_NAME, DATA_TYPE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'raw_titles';

    SELECT COLUMN_NAME, DATA_TYPE
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_NAME = 'raw_credits';


### 4.3. Removing redundant columns

    ALTER TABLE  raw_titles DROP COLUMN index;
    ALTER TABLE raw_titles DROP COLUMN imdb_id;
    ALTER TABLE raw_credits DROP COLUMN index;

### 4.4. Looking for null values

* raw_titles table

      select count(*) from raw_titles where id is null; -- returns 0
      select count(*) from raw_titles where title is null; -- returns 1 
      select count(*) from raw_titles where type is null; -- returns 0
      select count(*) from raw_titles where release_year is null;  -- returns 0
      select count(*) from raw_titles where runtime = 0; -- returns 24
      select count(*) from raw_titles where genres is null; -- returns 0. There are no null values in this column but there are some values with [] which are essentially null values but with empty string.
      select count(*) from raw_titles where genres= '[]'; -- There are 68 of them
      select count(*) from raw_titles where production_countries is null; -- returns 0. Same as genres, there are values with [] which are null values with empty string.
      select count(*) from raw_titles where production_countries= '[]'; -- returns 232
      select type, count(*) AS nulls from raw_titles where seasons is null group by type; -- returns 3759 (All Movies, no shows) 
      select count(*) from raw_titles where imdb_score is null AND imdb_votes is null; -- returns 523
      select count(*) from raw_titles where imdb_score is null OR imdb_votes is null; -- returns 539

* raw_credits table
    
      select count(*) from raw_credits where person_id is null;  -- returns 0
      select count(*) from raw_credits where id is null;  -- returns 0
      select count(*) from raw_credits where name is null;  -- returns 0
      select count(*) from raw_credits where character is null;  -- returns 9627

So there are null values in titles, runtime, genres, production_countries, imdb_score and imdb votes columns in raw_titles table and in character column in raw_credits table.

### 4.5. Removing the null values

I have 1 null value in title column, which needs to be deleted as the title column needs to be unique and non nullable. There are 24 rows with 0 runtime which doesn't make sense, so they're also to be deleted. 
The imdb_score and imdb_votes have 539 null values altogether. I can do any of the following with these 2 columns -
  
  1. Replace null values with 0, but it may not be the best approach, as it could lead to inaccurate results.
  2. Replace null values with a special value such as -1.0 or -999.0. This will allow me to distinguish between missing data and actual scores of 0.
  3. Leave null values as they are. But it can affect the analysis if I have to perform calculations. Null values can cause errors in calculations and can also affect the accuracy of the results. For example, if I'm calculating the average imdb_score of a set of movies and some of the imdb_score values are null, the average will be skewed and may not be an accurate representation of the data.
  4. Another approach is to use a string value such as 'No information' or 'N/A' to represent missing data. However, this approach requires converting the column to a string datatype first, which may not be ideal if I need to perform calculations on the column.
  5. Or, removing the rows altogether. Removing these rows with null values will leave us with 5806 - 1- 24 - 532 = 5249 rows which will not affect the analysis much.

    DELETE FROM raw_titles
    WHERE title IS NULL 
       OR runtime = 0 
       OR imdb_score IS NULL
       OR imdb_votes IS NULL;

### 4.6. Looking for duplicate values

In raw_titles table 
    
    SELECT id, COUNT(id) as count
    FROM raw_titles
    GROUP BY id
    HAVING COUNT(id) >1 ;

Since id is the primary key in raw_titles table, there must be unique non-duplicate values. The query returned 0 rows which means there are no duplicate values in this table. 

In raw_credits table

    SELECT id, person_id, COUNT(*) as count
    FROM raw_credits
    GROUP BY id, person_id, role
    HAVING COUNT(*) > 1
    ORDER BY count DESC LIMIT 10;

[IMAGE]
[QUERY OF THE JOIN TABLE WHICH SHOWS 4 ENTRIES]

SELECT film.title, role.name, role.character, role.role
from raw_titles film
join raw_credits role on film.id = role.id
where role.id ='tm228574' and role.person_id =65832;

There are no duplicate values. But there are entries with same id and person_id but with different character or role. Now I want to have a unique combination of person_id and id, with unique role i.e for either director or actor and concatenate all the character types into a single character. I'll do it later.


### 4.7. Changing the cases of the texts into Proper case

    UPDATE raw_titles SET type = initcap(type);
    UPDATE raw_titles SET title= initcap(title);
    UPDATE raw_titles SET genres= initcap(genres);
    UPDATE raw_credits SET role = initcap(role);
    UPDATE raw_credits SET name = initcap(name);


### 4.8. Trimming the white, leading and trailing spaces

    UPDATE raw_credits SET name = TRIM(name);
    UPDATE raw_credits SET character = TRIM(character);
    UPDATE raw_titles SET title = TRIM(title);
    UPDATE raw_titles SET genres = TRIM(genres);

### 4.9. String manipulation

#### 4.9.1 REMOVING THE [ ] BRACKETS FROM genres, production_countries COLUMNS
 
Adding a new columns country and genre to hold the new values 

    ALTER TABLE raw_titles ADD COLUMN country TEXT;
    ALTER TABLE raw_titles ADD COLUMN genre TEXT;
    UPDATE raw_titles SET country = SUBSTRING(production_countries, 2, (length(production_countries)-2)) WHERE id=id;
    UPDATE raw_titles SET genre =  SUBSTRING(genres, 2, (length(genres)-2)) WHERE id=id;

#### 4.9.2 REMOVING THE '' (quotation marks) FROM THE genre and country COLUMNS

    UPDATE raw_titles SET genre = REPLACE(genre, '''', '') WHERE genre LIKE '%''%';
    UPDATE raw_titles SET country = REPLACE(country, '''', '') WHERE country LIKE '%''%';

### 4.10. Replacing the null values with default values 

#### 4.10.1 SETTING THE NULL VALUES IN character COLUMN TO 'No information'

    UPDATE raw_credits SET character = 'No information' WHERE character IS NULL;
    UPDATE raw_credits SET character = 'Director' WHERE role = 'Director';

#### 4.10.2 SETTING THE NULL VALUES IN seasons TO 0 WHICH CORRESPONDS TO MOVIES

    UPDATE raw_titles SET seasons = 0 WHERE seasons IS NULL;

#### 4.10.3 SETTING THE NULL VALUES IN age_certification TO 'No information'    
    
    UPDATE raw_titles SET age_certification = 'Others' WHERE age_certification IS NULL;

#### 4.10.4 SETTING THE VALUES WITH [] IN genres COLUMN WITH 'No Information'

    UPDATE raw_titles SET genres = 'No information' WHERE genres = '[]';

#### 4.10.5 SETTING THE VALUES WITH [] IN production_countries COLUMN WITH 'No Information'

    UPDATE raw_titles SET production_countries  = 'No information' WHERE production_countries  = '[]';

### 4.11. Dealing with titles

#### 4.11.1 SOME UNUSUAL TITLES
There are 4 shows/movies with names formatted as dates in csv file. So I looked into them closely. I used a left join from (raw_titles to raw_credits) to get all the information about these 4 items from both tables.

    SELECT t.id, t.title, t.runtime,t.release_year, c.person_id, c.id, c.name, c.character, c.role
    FROM raw_titles t 
    LEFT JOIN raw_credits c
    ON t.id=c.id
    WHERE t.id IN ('tm197423','tm461427', 'tm348993','tm1011248');

When I double checked on internet, I found out that there are indeed shows named '15 August', '22 July', 'October 1' and '30.March' but not '30 March'. So I renamed the last one. 

Renaming title '30 March' to '30.March' 

    UPDATE raw_titles SET title = '30.March' WHERE title = '30 March';

(one point to remember : there are no details about this movie in raw_credits)

#### 4.11.2 SOME TITLES STARTING WITH #

I used a simple Regular Expression to filter only whose titles that doesn't start either with any numerical digit (0=9) or English alphabets (A-Z).

    SELECT title FROM raw_titles WHERE title !~'^[0-9A-Z]' ORDER BY title;

It returns 13 rows which starts with a #. So to remove that character from the left side of the string, I used LTRIM function.

    UPDATE raw_titles SET title = LTRIM(title, '#') WHERE title !~'^[0-9A-Z]';

### 4.12. Removing the extra columns

Now that we've created a trimmed, properly capitalized and cleaned columns genre and country, we can get rid of the former columns genres and production_countries.
 
    ALTER TABLE raw_titles DROP COLUMN genres;
    ALTER TABLE raw_titles DROP COLUMN production_countries;
    
### 4.13. Renaming the 'raw_titles' table to 'titles'

    DROP TABLE IF EXISTS titles;
    ALTER TABLE raw_titles RENAME TO titles;

### 4.14. Concatenating multiple characters into a single row

In a film or show, there are multiple roles that are played by more than one person. Occasionally, multiple characters might be played by one person. The `raw_titles` table holds the data of unique shows, while the `raw_credits` table holds the data of people who have played a certain character in a particular show. Actors and shows have a many-to-many relationship, meaning that one film/show might have more than one actor, and one actor may play more than one character both in one show or in multiple shows. To make it easier for users to look up any actor associated with a particular show and also get the information on the character they played, a table named `credits` was created with similar fields as the `raw_credits` table. The only difference between these two tables is that `raw_credits` sometimes holds information about characters played by a certain actor in a certain show in more than one row, while in the `credits` table, there is only one (unique) combination of `show_id`, `person_id`, `character played`, and `role` (i.e., either director or actor). This reduces the number of duplicate rows in the table.
    
    DROP TABLE IF EXISTS credits;
    CREATE TABLE credits (person_id INTEGER, id VARCHAR(20), name TEXT, role VARCHAR(8), character TEXT);

    INSERT INTO credits (person_id, id, name,role, character) SELECT person_id, id, name, role, STRING_AGG(character, ' / ') FROM raw_credits GROUP BY person_id, id, name, role;

This query will group the rows in the raw_credits table by person_id,id,name and role and concatenate the values in the character column for each group using the string_agg function. The resulting table will have 5 columns: person_id,id, name, character, role where character contains the concatenated values of the character column for each group. This table now has 77122 entries. 

showing some of the concatenated values
     
    SELECT character FROM credits WHERE character ~'^.*,+' LIMIT 10;

checking for duplicates in the credits table

    SELECT id, person_id, COUNT(*) AS count 
    FROM credits 
    GROUP BY id, person_id 
    HAVING COUNT(*) >1 
    ORDER BY COUNT(*) DESC 
    LIMIT 10;

It shows there are atmost 2 people with same id and person_id which implies that one entry is for actor and one for director role.

### 4.15. Checking the number of records in the cleaned tables

    SELECT COUNT(*) FROM titles; -- Returns 5249 rows
    SELECT * from raw_titles limit 4; -- -- Returns 77213 [double check it] rows
    [IMAGE OF THE CLEANED TABLE]
    
    SELECT COUNT(*) FROM credits;
    SELECT * from raw_titles limit 4;
    [IMAGE]

### 4.15. Checking once more for null values in the cleaned tables

    SELECT * FROM titles WHERE title IS NULL
    OR type IS NULL 
    OR age_certification IS NULL 
    OR runtime = 0 
    OR seasons IS NULL 
    OR country IS NULL 
    OR genre IS NULL 
    OR type IS NULL 
    OR imdb_score IS NULL 
    OR imdb_votes IS NULL; -- Returns 0

    SELECT * FROM credits WHERE name IS NULL 
    OR character IS NULL 
    OR role IS NULL; -- Returns 0

### 4.17.  Save the new tables and import them as cleaned csv files

    \copy titles TO 'C:/Users/Dell/Desktop/titles_cleaned.csv' DELIMITER ',' CSV HEADER;
    \copy credits TO 'C:/Users/Dell/Desktop/credits_cleaned.csv' DELIMITER ',' CSV HEADER;


### 4.18 Updating the null values in the new tables 

Unfortunately, the null values in country and genre tables have been stored as empty strings instead of 'No information'. So I update them here once again, before starting normalizing them. 

    UPDATE titles SET country = 'No information' WHERE country = '';
    UPDATE titles SET genre = 'No information' WHERE genre = '';

# Data Design:
# Data Analyze:
# Data Visualization:
# Results:

## Resources:
1. Dataset
   
   * [Netflix Movies and Series in Kaggle](https://www.kaggle.com/datasets/thedevastator/the-ultimate-netflix-tv-shows-and-movies-dataset?rvi=1)
   * [Netflix Movies and Series in data.world](https://data.world/gonzandrobles/netflix-movies-and-series)
   * [Netflix Wikipedia](https://en.wikipedia.org/wiki/Netflix#)
