-- Part 3 - Data Analysis

-- entering the database 
\c netflix
-- shows all the relations in the database
\dt 
-- shows all the relations in the database with their sizes 
\dt+


-- 1. What is the total number of movies and TV shows available on Netflix?

-- Total number of shows 

SELECT 
  COUNT(*) 
FROM 
  show;

-- 2. What is the number of content per type of content (movie/show)?

WITH total_count AS
(
SELECT COUNT(*) AS total_content 
FROM show 
)
SELECT t.type, COUNT(s.type_id) AS frequency, 
CONCAT(ROUND(COUNT(s.type_id)::NUMERIC / (SELECT total_content FROM total_count),2) * 100, ' %')  AS percentage_frequency 
FROM show s 
JOIN type t ON t.id = s.type_id 
GROUP BY t.type
;


-- 3. How has the distribution of content (movies and TV shows) changed over time?

SELECT 
  release_year AS year, 
SUM(CASE WHEN type_id = 1 THEN 1 ELSE 0 END) AS num_movies, 
SUM(CASE WHEN type_id = 2 THEN 1 ELSE 0 END) AS num_shows 
FROM 
  show 
GROUP BY 
  release_year 
ORDER BY 
  year;


-- 4. Which were the top years in terms of the number of titles released?

SELECT 
  release_year AS year, 
  COUNT(show_id) AS num_content 
FROM 
  show 
GROUP BY 
  release_year 
ORDER BY 
  COUNT(show_id) DESC
LIMIT 10;


-- 5. How many movies and TV shows were released in each decade?

WITH decade AS (
SELECT title, FLOOR((release_year - 1950) / 10) AS decade
FROM show
WHERE release_year BETWEEN 1953 AND 2022 
GROUP BY title, FLOOR((release_year - 1950) / 10)
)
SELECT decade,
CASE WHEN decade = 0 THEN '1950-1960'
	 WHEN decade = 1 THEN '1961-1970'
	 WHEN decade = 2 THEN '1971-1980'
	 WHEN decade = 3 THEN '1981-1990'
	 WHEN decade = 4 THEN '1991-2000'
	 WHEN decade = 5 THEN '2001-2010'
	 WHEN decade = 6 THEN '2011-2020'
	 WHEN decade = 7 THEN '2021-2030'
END range_of_years,
COUNT(title) AS num_content
FROM decade
GROUP BY decade
ORDER BY decade ASC;

-- This query will group the shows by decade and count the number of shows released in each decade. 
-- The floor((year - 1950) / 10) * 10 expression calculates the decade for each year by subtracting 1950 from the year, dividing by 10, rounding down to the nearest integer, 
-- and multiplying by 10. The WHERE clause filters the data to include only the years between 1953 and 2022. 
-- The GROUP BY clause groups the data by decade, and the ORDER BY clause sorts the results by decade in ascending order.

-- 6. What are the most common genres of movies and TV shows on Netflix?

-- Top 5 genres for movies

SELECT 
  g.genre, 
  COUNT(DISTINCT sg.show_id) AS num_movie 
FROM 
  show_genre sg
JOIN 
  genre g ON g.id = sg.genre_id 
JOIN 
  show s ON s.show_id = sg.show_id
WHERE 
  s.type_id = 1
GROUP BY 
  g.genre
ORDER BY 
  COUNT(DISTINCT sg.show_id) DESC
LIMIT 5;


-- Top 5 genres for shows

SELECT 
  g.genre, 
  COUNT(DISTINCT sg.show_id) AS num_show 
FROM 
  show_genre sg
JOIN 
  genre g ON g.id = sg.genre_id 
JOIN 
  show s ON s.show_id = sg.show_id
WHERE 
  s.type_id = 2
GROUP BY 
  g.genre
ORDER BY 
  COUNT(DISTINCT sg.show_id) DESC
LIMIT 5;


-- 7. Which country produces the most movies and TV shows on Netflix?

-- Top 10 countries producing movies

SELECT c.country_name, 
    COUNT( DISTINCT sc.show_id) AS num_movie 
FROM 
    show_country sc 
JOIN 
    show s ON s.show_id = sc.show_id 
JOIN 
    country c ON c.id = sc.country_id 
WHERE 
    s.type_id = 1 
GROUP BY  
    c.country_name 
ORDER BY  
    COUNT(sc.show_id) DESC 
LIMIT 10;

-- Top 10 countries producing shows

SELECT c.country_name, 
    COUNT( DISTINCT sc.show_id) AS num_show 
FROM 
    show_country sc 
JOIN  
    show s ON s.show_id = sc.show_id 
JOIN 
    country c ON c.id = sc.country_id 
WHERE 
    s.type_id = 2 
GROUP BY 
    c.country_name 
ORDER BY  
    COUNT(sc.show_id) DESC 
LIMIT 10;

-- content released by top 10 country

SELECT 
  country_name,
SUM(CASE WHEN type_id = 1 THEN 1 ELSE 0 END) AS num_movies, 
SUM(CASE WHEN type_id = 2 THEN 1 ELSE 0 END) AS num_shows 
FROM 
  show_country sc
JOIN show s ON s.show_id = sc.show_id
JOIN country c ON c.id = sc.country_id
WHERE c.country_name IN ('United States of America','India', 'United Kingdom of Great Britain and Northern Ireland', 'Japan','France','Spain','Canada', 'Korea','Germany','Mexico') 
GROUP BY 
 country_name
;


-- 8. Calculate descriptive statistics for imdb score, imdb votes and runtime of shows.

-- imdb_score

-- creating a B-Tree index on imdb_score to speed up the query
CREATE INDEX idx_imdb_score ON show(imdb_score);

SELECT 
     ROUND(AVG(imdb_score)::NUMERIC, 4) AS avg_imdb_score,
     ROUND(MIN(imdb_score)::NUMERIC, 4) AS min_imdb_score,
     ROUND(MAX(imdb_score)::NUMERIC, 4) AS max_imdb_score,
     ROUND(VARIANCE(imdb_score)::NUMERIC, 4) AS variance_imdb_score,
     ROUND(STDDEV(imdb_score)::NUMERIC, 4) AS std_dev_imdb_score
FROM 
    show;

-- imdb_votes

-- creating a B-Tree index on imdb_votes to speed up the query
CREATE INDEX idx_imbd_votes ON show(imdb_votes);

SELECT 
    ROUND(AVG(imdb_votes)::NUMERIC, 4) AS avg_imdb_votes,
    ROUND(MIN(imdb_votes)::NUMERIC, 4) AS min_imdb_votes,
    ROUND(MAX(imdb_votes)::NUMERIC, 4) AS max_imdb_votes,
    ROUND(VARIANCE(imdb_votes)::NUMERIC, 4) AS variance_imdb_votes,
    ROUND(STDDEV(imdb_votes)::NUMERIC, 4) AS std_dev_imdb_votes
FROM 
    show;


-- runtime

-- creating a B-Tree index on runtime to speed up the query
CREATE INDEX idx_runtime ON show(runtime);

SELECT 
    ROUND(AVG(runtime)::NUMERIC, 2) AS avg_runtime,
    ROUND(MIN(runtime)::NUMERIC, 2) AS min_runtime,
    ROUND(MAX(runtime)::NUMERIC, 2) AS max_runtime,
    ROUND(VARIANCE(runtime)::NUMERIC, 2) AS variance_runtime,
    ROUND(STDDEV(runtime)::NUMERIC, 2) AS std_dev_runtime
FROM 
    show;

-- 9. Which shows/movies are of longest and shortest runtime?

-- Longest runtime

WITH max_runtime AS (
SELECT 
    MAX(runtime) AS max_runtime 
FROM 
    show 
)
SELECT 
    title, runtime 
FROM 
    show 
WHERE 
    runtime = (SELECT max_runtime FROM max_runtime);

-- Shortest runtime

WITH min_runtime AS (
SELECT 
    MIN(runtime) AS min_runtime 
FROM 
    show 
)
SELECT 
    title, runtime 
FROM 
    show 
WHERE 
    runtime = (SELECT min_runtime FROM min_runtime);


-- 10. Calculate the distribution of seasons for shows.

SELECT seasons, 
    COUNT(*) AS num_shows 
FROM 
    show 
WHERE 
    type_id = 2 
GROUP BY 
    seasons 
ORDER BY 
     COUNT(*) DESC;

-- 11. What are the 10 top-rated movies and shows on Netflix?

-- Top 10 Most Popular Movies
SELECT 
    title AS movie,
    imdb_score, 
    imdb_votes 
FROM 
    show 
WHERE 
    type_id = 1 
ORDER BY 
    imdb_score DESC 
LIMIT 10;

-- Top 10 Most Popular Shows
SELECT 
    title AS show,
    imdb_score, 
    imdb_votes 
FROM 
    show 
WHERE 
    type_id = 2 
ORDER BY 
    imdb_score DESC 
LIMIT 10;


-- 12. What are the most popular certifications on Netflix?

WITH certification_description AS (
SELECT age_certification, 
       CASE age_certification 
           WHEN 'G' THEN 'General Audiences' 
           WHEN 'PG' THEN 'Parental Guidance Suggested' 
           WHEN 'PG-13' THEN 'Parents Strongly Cautioned' 
           WHEN 'R' THEN 'Restricted'  
           WHEN 'NC-17' THEN 'Adults Only' 
           WHEN 'TV-14' THEN 'Parental Guidance Under Age 14' 
           WHEN 'TV-G' THEN 'Suitable for All Audience' 
           WHEN 'TV-MA' THEN 'Suitable only for Mature Audience' 
           WHEN 'TV-PG' THEN 'TV Parental Guidance Suggested' 
           WHEN 'TV-Y' THEN 'Suitable for Children aged 6 years or under' 
           WHEN 'TV-Y7' THEN 'Suitable for Children aged 7 years or older' 
           WHEN 'Others' THEN 'No information available' 
       END certification_description 
FROM age_certification 
)
, 
num_content AS 
(SELECT ac.age_certification AS age_certification, 
    COUNT(s.title) AS num_content 
FROM 
    show s 
JOIN 
    age_certification ac ON ac.id = s.certification_id 
GROUP BY 
    ac.age_certification 
)
SELECT 
    num_content.age_certification, 
    certification_description.certification_description, 
    num_content.num_content 
FROM 
    num_content 
JOIN 
    certification_description ON certification_description.age_certification = num_content.age_certification  
ORDER BY 
    num_content.num_content;


-- 13. Which actor has most films/series on Netflix?

SELECT a.name AS actor, 
	COUNT(sa.show_id) AS number_of_contents
FROM 
	show_actor sa 
JOIN 
	actor a ON a.person_id = sa.actor_id 
GROUP BY 
	a.name 
ORDER BY 
	COUNT(sa.show_id) DESC 
LIMIT 10;


-- 14. List Top 10 Directors with number of shows/movies directed.

SELECT d.name AS director, 
	COUNT(sd.show_id) AS number_of_contents 
FROM 	
	show_director sd 
JOIN  
	director d ON d.person_id = sd.director_id 
GROUP BY 
	d.name 
ORDER BY 
	COUNT(sd.show_id) DESC 
LIMIT 10;



-- 15. Categorize the contents in 3 parts (Short, Medium and Long) in terms of duration and give their respective percentage frequency.


WITH total_count AS
(
SELECT 
    COUNT(*) AS total_content
FROM 
    show
)
,
duration AS
(SELECT title,
       runtime,
       CASE WHEN runtime> 0 AND runtime <= 60 THEN 'Short'
       WHEN runtime > 60 AND runtime <= 120 THEN 'Medium'
       WHEN runtime> 120 THEN 'Long'
       END duration
FROM 
    show
ORDER BY 
    title
)
SELECT 
    d.duration, 
    COUNT(d.title)  AS frequency,
    CONCAT(ROUND(COUNT(d.title)::NUMERIC / (SELECT total_content FROM total_count), 2)*100, ' %') AS relative_frequency
FROM 
    show s
JOIN 
    duration d ON d.title = s.title
GROUP BY 
    d.duration;


--16.  Categorize the contents in 10 ratings based on the imdb_score and give the percentage frequency for each of them.

WITH rating AS
(
SELECT title, imdb_score, 
CASE 
	WHEN imdb_score >= 1.0 AND  imdb_score <2.0 THEN 'Do Not Want'
	WHEN imdb_score >= 2.0 AND  imdb_score <3.0 THEN 'Awful'
	WHEN imdb_score >= 3.0 AND  imdb_score < 4.0 THEN 'Bad'
	WHEN imdb_score >= 4.0 AND  imdb_score <5.0 THEN 'Nice Try, But No Cigar'
	WHEN imdb_score >= 5.0 AND  imdb_score < 6.0 THEN 'Meh'
	WHEN imdb_score >= 6.0 AND  imdb_score < 7.0 THEN 'Not Bad'
	WHEN imdb_score >= 7.0 AND  imdb_score < 8.0 THEN 'Good'
	WHEN imdb_score >= 8.0 AND  imdb_score < 9.0 THEN 'Very Good'
	WHEN imdb_score >= 9.0 AND  imdb_score <= 10.0 THEN 'Excellent'
	WHEN imdb_score = 10.0 THEN 'Masterpiece'
END rating
FROM show
)
SELECT rating , COUNT(title) AS num_content
FROM rating
GROUP BY rating
ORDER BY num_content DESC
;


-- 17. What is the percentage frequency of genre?

WITH total_count AS
(
SELECT COUNT(*) AS total_content
FROM show
)
SELECT 
	g.genre, 
	COUNT(s.show_id) AS frequency,
	CONCAT(ROUND(COUNT(s.show_id)::NUMERIC / (SELECT total_content FROM total_count), 2)*100, ' %') AS relative_frequency
FROM 
	show_genre sg
JOIN 
	show s ON s.show_id = sg.show_id
JOIN 
	genre g ON g.id = sg.genre_id
GROUP BY 
	g.genre
ORDER BY 
	COUNT(s.show_id) DESC;



-- 18. Calculate the number of shows with runtime greater than the average duration.

WITH avg_runtime AS (
SELECT ROUND(AVG(runtime),2) AS avg_runtime
FROM show
)
SELECT COUNT(*) AS num_content
FROM show 
WHERE runtime > (SELECT avg_runtime FROM avg_runtime)
;


-- 19. Calculate the number of contents with imdb_score greater than average imdb_score.

WITH avg_imdb_score AS (
SELECT AVG(imdb_score) AS avg_imdb_score
FROM show
)
SELECT COUNT(*) AS num_content
FROM show
WHERE imdb_score > (SELECT avg_imdb_score FROM avg_imdb_score)
;
