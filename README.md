# Netflix Data Analysis: A Deep Dive into Streaming Trends 

![Netflix logo](https://logos-world.net/wp-content/uploads/2020/04/Netflix-Logo-2014-present.jpg)

# Introduction:

Netflix is an American subscription video on-demand over-the-top streaming service which  was launched on January 16, 2007. The service primarily distributes original and acquired films and television shows from various genres, and it is available internationally in multiple languages.

Netflix is the most-subscribed video on demand streaming media service, with 238.39 million paid memberships in more than 190 countries. As of October 2023, Netflix is the 24th most-visited website in the world with 23.66% of its traffic coming from the United States, followed by the United Kingdom at 5.84% and Brazil at 5.64%.

Using Postgresql I cleaned, analyzed and normalized the Netflix Streaming data, which contains information about the titles, genres, ratings, and countries of the streaming content. I then used Datawrapper and Tableau to create interactive and engaging visualizations of the streaming trends, such as the most popular genres, the distribution of ratings, and the growth of content over time. 

![Screenshot (1047)](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/86b4a945-6b90-4570-b988-a61db918e182)

# Objective:

The goal of this project is to explore the characteristics and patterns of the Netflix Streaming data and communicate the findings effectively using data visualization tools. By answering the following questions I've conducted an exploratory data analysis of the streaming data of Netflix.

1. What is the total number of movies and TV shows available on Netflix?
2. How has the distribution of content (movies and TV shows) changed over time? For example, how many movies and TV shows were released in each decade?
3. What are the most common genres of movies and TV shows on Netflix?
4. Which country produces the most movies and TV shows on Netflix?
5. What is the average duration of movies and TV shows on Netflix?
6. What are the top-rated movies on Netflix?
7. What are the most popular ratings on Netflix?
8. Which were the top years in terms of the number of titles released?
9. Which actor/director has most films/series in Netflix?
10. What are the percentage relative frequency for genre?

# Tools used:

1. Google Slides - to create the project proposal
2. PostgreSQL (SQL Shell) - for data cleaning, data normalization and analysis process
3. Datawrapper - to create data visualizations
4. Tableau - to create dashboard
5. GitHub - for documentation 

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

The dataset contains 6 files in total, namely -
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

The following steps were taken to clean the netflix data - 

* **Step 1** - Made a backup copy of the original data in csv format

* **Step 2** - Created a new database called 'netflix' in PostgreSQL Database system

* **Step 3** - Created the raw_titles and raw_credits tables to hold the data loaded from csv files

* **Step 4** - Loaded the data into the raw_titles and raw_credits table

* **Step 5** - Checked the size of the dataset

* **Step 6** - Checked the datatypes

* **Step 7** - Removed the redundant columns (index, imdb_id from raw_titles and index from raw_credits table) that will not help us in the analysis

* **Step 8** - Looked for null values by counting the number of rows with Null values, 0s or wrong values. There are null values in titles, runtime, genres, production_countries, imdb_score and imdb votes columns in raw_titles table and in character column in raw_credits table.

* **Step 9** - After identifying the null values, I decided to remove them from title, runtime, imdb_score and imdb_votes columns. Here is the explanation for removing the values.

  I have 1 null value in title column, which needs to be deleted as the title column needs to be unique and non nullable. There are 24 rows with 0 runtime which doesn't make sense, so they're also to be deleted. 
The imdb_score and imdb_votes have 539 null values altogether. I can do any of the following with these 2 columns -
  
  1. Replace null values with 0, but it may not be the best approach, as it could lead to inaccurate results.
  2. Replace null values with a special value such as -1.0 or -999.0. This will allow me to distinguish between missing data and actual scores of 0.
  3. Leave null values as they are. But it can affect the analysis if I have to perform calculations. Null values can cause errors in calculations and can also affect the accuracy of the results. For example, if I'm calculating the average imdb_score of a set of movies and some of the imdb_score values are null, the average will be skewed and may not be an accurate representation of the data.
  4. Another approach is to use a string value such as 'No information' or 'N/A' to represent missing data. However, this approach requires converting the column to a string datatype first, which may not be ideal if I need to perform calculations on the column.
  5. Or, removing the rows altogether. Removing these rows with null values will leave us with 5806 - 1- 24 - 532 = 5249 rows which will not affect the analysis much.

  So I decided to remove these rows with null values.

* Step 10 - Checked for duplicate values. There were no duplicate values in both table. But there are entries with same id and person_id but with different character or role like the data shown below. There are multiple entries of one person acting in one particular show/movie but the data is recorded in 2 or more rows for different characters/roles. 

![Screenshot (912)](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/c612e450-3a0c-49f6-a4c8-7b736b63979e)

This increases the number of records in our table. The character column needed to be concatenated into one single row for each person and show_id, for either actor or director role.

* **Step 11** - Changed the cases of the texts into Proper case

* **Step 12** - Trimed the white, leading and trailing spaces from the categorical columns

* **Step 13** - String manipulation

  * 13.1 - Removed the [ ] and '' (quotation marks) from genres and production_countries columns
  * 13.2 - Replaced the null values with default values
  * 13.3 - Set the Null values in character column to 'No information'
  * 13.4 - Set the null values in seasons to 0 which corresponds to movies
  * 13.5 - Set the null values in age_certification to 'Others'
  * 13.6 - Set the values with [] in genres column with 'N/A'
  * 13.7 - Set the values with [] in production_countries column with 'N/A'

* **Step 14** - Modified some titles

  * 14.1 - Renamed title '30 March' to '30.March'
  * 14.2 - Replaced '#' from the beginning of some titles

* **Step 15** - Removed the extra columns production_contries and genres since I now have cleaned columns country and genre.

* **Step 16** - Concatenating multiple characters into a single row

  The `raw_titles` table holds the data of unique shows, while the `raw_credits` table holds the data of people who have played a certain character in a particular show. Actors and shows have a many-to-many relationship, meaning that one film/show might have more than one actor, and one actor may play more than one character both in one show or in multiple shows. 

  ![Screenshot (908)](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/4f18d8a6-283a-484f-b40e-dcc854855754)

  To make it easier for users to look up any actor associated with a particular show and also get the information on the character they played, a table named _credits_ was created with similar fields as the _raw_credits_ table. The only difference between these two tables is that _raw_credits_ sometimes holds information about characters played by a certain actor in a certain show more than once, while in the _credits_ table, there is only one (unique) combination of _show_id_, _person_id_, _character played_, and _role_ (i.e., either director or actor). This reduces the number of duplicates in the table.
    
    DROP TABLE IF EXISTS credits;
    CREATE TABLE credits (person_id INTEGER, id VARCHAR(20), name TEXT, role VARCHAR(8), character TEXT);

    INSERT INTO credits (person_id, id, name,role, character) SELECT person_id, id, name, role, STRING_AGG(character, ' / ') FROM raw_credits GROUP BY person_id, id, name, role;

  This query groups the rows in the raw_credits table by person_id,id,name and role and concatenate the values in the character column for each group using the string_agg function. The resulting table will have 5 columns: person_id,id, name, character, role where character contains the concatenated values of the character column for each group. This table now has 77122 entries. 

  ![Screenshot (909)](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/6c7c7fbe-ee1b-4751-ab6a-1a0822ae068a)

* **Step 17** - Renamed the 'raw_titles' table to 'titles'

* **Step 18** - Saving the new tables and import them as cleaned csv files

# Database Design:

  After cleaning the Netflix data in Part 1, we obtained two tables - 'titles' containing information about unique shows/movies and 'credits' containing information about the castings in different shows/movies.
The data is now distributed in these two tables.

![initial data dist](https://github.com/Arpita-deb/Books-Database-Normalization/assets/139372731/5e10a804-e422-477f-8414-d5e4ceef96c0)

  When we counted the unique shows in each of the tables (since both have id column which corresponds to unique shows), we found out that the number of unique shows in credits table is higher than the titles table.

![Show](https://github.com/Arpita-deb/Books-Database-Normalization/assets/139372731/764b48d0-8276-4724-926b-fda2334e00d9)

  To have a consistency in the entire analysis, I've chosen only the data that are present in both tables by creating a view with the common data from both titles and credits table.

  Using the best practices of database management system, we can now easily split the data into different tables that will allow us -
    * Less data duplication and more efficient storage usage.
    * Increased data integrity, accuracy and consistency.
    * Improved query performance and organization.
    * Increased security and connection.

## Database Design: 

Database design is the organization of data according to a database model. The designer determines what data must be stored and how the data elements interrelate.

Like any design process, database and information system design begins at a high level of abstraction and becomes increasingly more concrete and specific. Data models can generally be divided into three categories, which vary according to their degree of abstraction. The process will start with a conceptual model, progress to a logical model and conclude with a physical model.

* ## Conceptual data model:

They are also referred to as domain models and offer a big-picture view of what the system will contain, how it will be organized, and which business rules are involved. Conceptual models are usually created as part of the process of gathering initial project requirements.

![conceptual model](https://github.com/Arpita-deb/Books-Database-Normalization/assets/139372731/229bc1b8-7799-426b-866e-20d9a0fb9184)

* ## Logical data model:

They are less abstract and provide greater detail about the concepts and relationships in the domain under consideration. These indicate data attributes, such as data types and their corresponding lengths, and show the relationships among entities. Logical data models don’t specify any technical system requirements.

![logical model](https://github.com/Arpita-deb/Books-Database-Normalization/assets/139372731/371cd6c6-d3ef-4fae-8be1-dd3e979cd4ca)

* ## Physical data model:

They provide a schema for how the data will be physically stored within a database. As such, they’re the least abstract of all. They offer a finalized design that can be implemented as a relational database, including associative tables that illustrate the relationships among entities as well as the primary keys and foreign keys that will be used to maintain those relationships. 

![physical model](https://github.com/Arpita-deb/Books-Database-Normalization/assets/139372731/1c972f98-6226-4768-9656-537d884cb181)

The following steps were taken to create the database -

* **Step 1** - To give the data First Normal Form (1NF), I unnested the nested columns first by 'genres' column and then by 'production_countries' and saved the data in a view called country_nested. As for primary key, the id column is a unique identifier of the show/movie and can act as a primary key.

* **Step 2** - Then I created a table 'netflix_table' with all the data from country_nested view to further manipulate it easily. Due to unnesting of the data, the number of data has increased to 271234.

* **Step 3** - To keep the database uncluttered I removed the redundant views from the database.

* **Step 4** - Then to give the data in netflix_table Second Normal Form (2NF), I needed to make sure that each non-key attribute is functionally dependent on the primary key(show_id) only. The attributes that are functionally independent from the primary key, will have their separate tables with a primary key. So I grouped different categories into different tables according to the physical model of the database.

* **Step 5** - I created the leaf tables and inserted the values in respective tables from netflix_tables and provided the primary keys to each of the tables.

* **Step 6** - To link theses relations(tables) with each other I defined foreign keys.

* **Step 7** - There were four attributes genre, country, actor and director that had many-to-many relationship with the show table. So to join these tables with show table individually I needed 4 junction/linking tables with the foreign keys as columns.

* **Step 8** - To test that the keys work fine and link the tables properly, I've performed several queries with JOIN statements at each step.

* **Step 9** - In the country table to make the data more comprehensible, I decided to add country name along with country ISO code. So I joined a table that have been previously downloaded from Wikipedia and inserted the country names into the country_name column in country table.

* **Step 10**- Finally, I checked for transitive dependencies among the leaf tables and their attributes. There were none. This satisfied the Third Normal Form (3NF).

* **Step 11** - To make the data clean, consistent and complete, I performed some string Manipulations, trimmed some parts of strings, used REGEX to filter out inconsistencies and changed them.


This database is now normalized upto 3rd Normal Form. It ensures that -

1. Each table have columns that only store a single piece of data and that data is accessed through a unique key (Primary Key). [First Normal Form]

2. Each Non-key attributes (i.e., columns other than primary key(s) are functionally dependent on the primary key only. [Second Normal Form]

3. There is no transitional dependency of the non-key attributes i.e., each table has columns that are dependent only on the primary key. [Third Normal Form]

# Data Analysis:

### 1. What is the total number of movies and TV shows available on Netflix?

![total_content](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/f7cd5754-71f3-439f-a1df-7d74310c1224)

### 2. What is the total number of contents per type (movie/show)?

![show-movie-freq](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/e39fcc54-7cf8-4d71-9a43-ef2ee89ec26f)

![distribution-of-movies-and-shows-on-netflix](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/637ef63d-25cc-4a97-ad66-5133e2a1320d)

### 3. How has the distribution of content (movies and TV shows) changed over time?

![distribution-of-contents-on-netflix-over-the-years](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/0fce3200-17d6-4e4a-a349-a66f8b915a52)

### 4. Which were the top years in terms of the number of titles released?

![top-years](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/1c50ab08-e4f5-447b-a599-6c63b5eb09c5)

### 5. How many movies and TV shows were released in each decade?

![decade](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/5be6c53b-601a-4792-ab2c-3320e06793d0)

![rise-of-netflix-over-the-decades](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/3c26d9ea-8ed7-465d-b558-197032b31d9e)

### 6. What are the most common genres of movies and TV shows on Netflix?

![top-5-genre-movies](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/785fc9f9-7281-4e23-9959-f5446e2a8e4f)

![top-5-genre-shows](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/26fc8a19-fca0-4e65-b7ef-bd7675217461)

![popular-genre-on-netflix](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/8f1a54cb-7bc5-4230-b1f3-7790a220b1c9)

### 7. Which country produces the most movies and TV shows on Netflix?

![top-10-country-movie](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/f12b891c-7ec7-4a7e-9858-3a1a99fbb280)

![top-10-country-show](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/5251e76e-0933-4027-8839-89b1c97b01d7)

![total-movie-released-per-country](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/410194f3-06c7-431f-9e80-1f67deb2c200)

![total-shows-released-per-country](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/908ef763-7358-40e9-979d-1543b2107664)

![distribution-of-contents-in-top-10-countries](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/3164f2e7-b5bb-412e-8f17-d4a283bbb65d)

### 8. Calculate descriptive statistics for imdb score, imdb votes and runtime of the shows.

![imdb_score-dist](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/2497b621-1f4e-4f35-b712-74c7e5116cf4)

![imdb_votes-dist](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/0e6b85a6-9237-41c7-b779-76a1ea6ce684)

![runtime-dist](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/6a298cee-5150-4b87-9f0e-551a679eaa7f)

### 9. Which shows/movies are of longest and shortest duration?

![highest-runtime](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/7a78fdb4-abed-4d40-a062-385816a0a081)

![lowest-runtime](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/685d5086-379b-4d9a-9906-d10459d10543)

### 10. Calculate the distribution of seasons for shows.

![seasons](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/e7538a4e-073f-4033-8997-e8b5afd1dcd6)

![popular-seasons-on-netflix](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/655cb459-2fbf-4b52-8a6e-709294619dbf)

### 11. What are the 10 top-rated movies and shows on Netflix?

![top-10-movies](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/37bb537c-0d40-42f2-90fd-b6b9fe14d4f1)

![top-10-show](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/7cd4579d-5fbf-43dd-a018-deb3f660333d)

![top-10-movies-in-netflix-based-on-imdb-scores](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/3e711235-38de-4ac7-bb38-114dc8fad092)

![top-10-shows-in-netflix-based-on-imdb-scores](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/eec8587b-e2cb-4088-995d-1d772bfd279e)

### 12. What are the most popular certifications on Netflix?

![age-cert](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/c79bc763-b7a0-4f59-8a55-cb9bdb280ee9)

![distribution-of-contents-on-netflix-by-age-certification](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/348a84b3-7d9b-49fd-a10b-cf45e589523f)

### 13. List Top 10 Actors with number of shows/movies acted.

![top-10-actors](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/3c398d61-c296-4fa9-8a77-cc87a1b31f30)

### 14. List Top 10 Directors with number of shows/movies directed.

![top-10-directors](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/aed865e9-2aa4-478b-87c4-4faa7f133ec4)

### 15. Categorize the contents in 3 parts (Short, Medium and Long) in terms of duration and give their respective percentage frequency.

![duration-freq](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/66f5cb5c-87b6-4deb-be30-b6fc995fc835)

![distribution-of-contents-on-netflix-based-on-runtime](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/e0b28e23-8ef6-47f3-a1b6-c5511d10716a)


### 16. Categorize the contents in 10 ratings based on the imdb_score.

![rating-freq](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/446ef250-dea1-448a-bde3-1119f839bb47)

![what-do-people-think-of-the-contents-on-netflix-](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/c23452ab-eda9-4dd3-913b-084c5363b897)

### 17. What is the percentage frequency of genre?

![genre-freq](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/72ebc726-70ed-4bdd-8750-70228bfc99ab)

### 18. Calculate the number of shows with runtime greater than the average duration?

![num_content_greater_than_avg_runtime](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/b5f84408-32db-4032-bf56-75ed3f67d888)

### 19. Calculate the number of contents with imdb_score greater than average imdb_score.

![num_content_greater_than_avg_imdb](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/f872323d-fcf0-4bb0-8d63-890e3235baf9)

# Dashboard:

![netflix](https://github.com/user-attachments/assets/bf63a51b-80fc-4e87-b0b9-8b0d35469e48)

The tableau dashboard can be accessed [here](https://public.tableau.com/app/profile/arpita.deb5031/viz/netflixdataanalysis_17012304017640/Dashboard2).

# Summary:

* The analysis revealed that Netflix has more movies than shows, mostly from the USA and India, and that its popularity has increased dramatically since 2010. Japan and North Korea are seen as emerging show producing countries.
* Over the past ten years (2011–2021), Netflix’s popularity surged as the number of contents released increased almost tenfold and the trend seem to continue to the next decade.
* It also shows that the most common genres are drama, comedy and action, and that the average runtime, IMDB score and IMDB votes are 81.61 minutes, 6.5269 and 24724.6467 respectively.
* It also indicates that most of the contents are for mature audiences as 14% of the total contents have TV-MA certification followed by R (11%) and PG-13 (8%).
* Most of the shows have one season.

# Recommendations for various stakeholders:

* **Members**: Netflix can make its members happier and loyal by suggesting contents that they like based on what they watch. Netflix can also use the data to find and make more contents that suit its global members' tastes and needs. For example, Netflix can invest more in producing original shows from Japan and North Korea, as they are seen as emerging markets for show production. Netflix can also create more contents in different languages and genres, such as comedy, drama, and action, which are the most popular among its members.

* **Investors**: Netflix can use the data to show its investors how it is leading and growing in the streaming industry. Netflix can show its investors how it has become more popular and successful by releasing more contents in the past ten years, and how it will keep doing so.

* **Regulators**: Netflix can use the data to follow the rules and standards of different countries and regions where it offers its service. Netflix can make sure that its contents are fit and respectful for the people who watch them, and that it follows the culture and law of each place. Netflix can also use the data to make decisions on how to license, tax, and censor its contents, and to deal with any issues or concerns from the regulators.

* **Communities and organizations**: Netflix can use the data to connect with the communities and organizations that are important for its business and social impact. Netflix can work with independent producers and content creators to give them a chance to share their work with the world. Netflix can also work with schools, NGOs, and media to promote its contents and raise awareness on various topics and issues that are in its contents. Netflix can also use the data to improve its diversity and inclusion efforts, and to support the causes and initiatives that match its values and mission.

# Limitation of the project:

* One possible limitation of the Netflix dataset is that it only contains data up to May 2022, which may not reflect most current contents and trends.
* Due to rigorous data cleaning of the dataset, many incorrect and inconsistent entries have been removed from the dataset. So, it does not cover the entire contents of Netflix.
* Since there were no reviews, we couldn’t perform sentiment analysis to provide more insights into user behavior and preferences.

# Some future project ideas:

* Analyze the relationship between the director and the cast of the movies and shows.
* Explore the variation of content in other countries as well as for different years.
* Perform sentiment analysis on the descriptions of the movies and shows.
* Create a recommendation system based on the user’s preferences and viewing history.

## Resources:

1. Dataset Used
   
   * [Netflix Movies and Series in Kaggle](https://www.kaggle.com/datasets/thedevastator/the-ultimate-netflix-tv-shows-and-movies-dataset?rvi=1)
   * [Netflix Movies and Series in data.world](https://data.world/gonzandrobles/netflix-movies-and-series)
   * [country_iso_codes.csv](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/files/13530946/iso.csv)
   * [Netflix Wikipedia](https://en.wikipedia.org/wiki/Netflix#)

2. Data Cleaning in SQL

   * [Mastering Data Cleanin Techniques With SQL Explained Examples - Medium Article](https://medium.com/gitconnected/mastering-data-cleaning-techniques-with-sql-explained-examples-80980fef2d3a)
   * [Data Cleaning using SQL - Medium Article](https://medium.com/@aakash_7/data-cleaning-using-sql-6aee7fca84ee)
   * [Data Cleaning in SQL](https://learnsql.com/blog/data-cleaning-in-sql/)
   * [The Ultimate Guide to Data Cleaning in SQL](https://acho.io/blogs/the-ultimate-guide-to-data-cleaning-in-sql)
   * [The Ultimate Guide to Data Cleaning in SQL](https://medium.com/@sqlfundamentals/the-ultimate-guide-to-data-cleaning-in-sql-74855cce28c8)

3. Data Design
   
   * [Data Modelling - IBM](https://www.ibm.com/topics/data-modeling)
   * [From Spreadsheets to Database - A Comprehensive study of Database Normalization](https://medium.com/@arpita_deb/from-spreadsheets-to-database-c2e8dbeb6a76)
   * [Books Database Normalization](https://github.com/Arpita-deb/Books-Database-Normalization.git)
   * [How to Keep Unmatched Rows When You Join two Tables in SQL](https://learnsql.com/blog/sql-join-unmatched-rows/)
   * [Managing PostgreSQL Views](https://www.postgresqltutorial.com/postgresql-views/managing-postgresql-views/)
   * [6 Easy And Actionable Steps On How To Design A Database](https://www.databasestar.com/how-to-design-a-database/)
   * [Database Design One to Many Relationships: 7 Steps to Create Them (With Examples) - YouTube Video](https://youtu.be/-C2olg3SfvU?si=CHkSvnP0owU-zBbG)
   * [How to Correctly Define Many-To-Many Relationships in Database Design - YouTube Video](https://youtu.be/1eUn6lsZ7c4?si=-mMSnZjhFoBrLHLg)
   * [7 Database Design Mistakes to Avoid (With Solutions) - YouTube Video](https://youtu.be/s6m8Aby2at8?si=wPD1blBcAi_ZSuCW)
     
5. Regular Expressions
   * [Regular Expressions in PostgreSQL](https://youtu.be/bRly46jfdMk?si=2kjYUxmUJJgYPmLB)

6. Data Analysis 
   * [SQL Indexes - Definition, Examples, and Tips](https://youtu.be/NZgfYbAmge8?si=NEVDDxeAfTzUgpc5)
   * [PostgreSQL Indexing : How, why, and when.](https://youtu.be/clrtT_4WBAw?si=nH2F2JyTCbiQAAQq)
   * [PostgreSQL CASE](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/)
   * [Rating System](https://rating-system.fandom.com/wiki/TV-G)
   * [How to rate movies on IMDB](https://www.imdb.com/list/ls076459507/)

7. Dashboard
   * [Create Netflix dashboard with Tableau in 30 minutes](https://youtu.be/BTArwS4ljC4?si=u-i97yBBDc9yHqko)
