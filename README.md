# WHAT TO WATCH ON NETFLIX NEXT? 
## Data Analysis of the largest video streaming service

![Netflix logo](https://logos-world.net/wp-content/uploads/2020/04/Netflix-Logo-2014-present.jpg)

# Introduction

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

1. Google Sheets - to create the project proposal
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
# Data Design:
# Data Analyze:
# Data Visualization:
# Results:

## Resources:
1. Dataset
   
   * [Netflix Movies and Series in Kaggle](https://www.kaggle.com/datasets/thedevastator/the-ultimate-netflix-tv-shows-and-movies-dataset?rvi=1)
   * [Netflix Movies and Series in data.world](https://data.world/gonzandrobles/netflix-movies-and-series)
   * [Netflix Wikipedia](https://en.wikipedia.org/wiki/Netflix#)
