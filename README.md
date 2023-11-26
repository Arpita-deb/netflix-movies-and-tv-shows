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
11. What are the percentage relative frequency for age_certification, genre and country?

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

* ### **Step 1 - Making a backup copy of the original data in csv format**

* ### **Step 2 - Creating a new database called 'netflix' in PostgreSQL Database system**

* ### **Step 3 - Creating the tables to hold the data loaded from csv files**

* ### **Step 4 - Loading the data into the raw_titles and raw_credits table**

* ### **Step 5 - Cleaning the data**

* ### **Step 6 - Checking the size of the dataset**

* ### **Step 7 - Checking the datatypes**

![Screenshot (910)](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/6f8ba96b-3b19-46d4-922d-d38cddffd6f6)

* ### **Step 8 - Removing redundant columns**
  
  Deleting the index, imdb_id from raw_titles table and index from raw_credits column. 

* ### **Step 9 - Looking for null values** 

  So there are null values in titles, runtime, genres, production_countries, imdb_score and imdb votes columns in raw_titles table and in character column in raw_credits table.

* ### **Step 10 - Removing the null values**

  I have 1 null value in title column, which needs to be deleted as the title column needs to be unique and non nullable. There are 24 rows with 0 runtime which doesn't make sense, so they're also to be deleted. 
The imdb_score and imdb_votes have 539 null values altogether. I can do any of the following with these 2 columns -
  
  1. Replace null values with 0, but it may not be the best approach, as it could lead to inaccurate results.
  2. Replace null values with a special value such as -1.0 or -999.0. This will allow me to distinguish between missing data and actual scores of 0.
  3. Leave null values as they are. But it can affect the analysis if I have to perform calculations. Null values can cause errors in calculations and can also affect the accuracy of the results. For example, if I'm calculating the average imdb_score of a set of movies and some of the imdb_score values are null, the average will be skewed and may not be an accurate representation of the data.
  4. Another approach is to use a string value such as 'No information' or 'N/A' to represent missing data. However, this approach requires converting the column to a string datatype first, which may not be ideal if I need to perform calculations on the column.
  5. Or, removing the rows altogether. Removing these rows with null values will leave us with 5806 - 1- 24 - 532 = 5249 rows which will not affect the analysis much.
So I decided to remove these rows with null values.

* ### **Step 11 - Looking for duplicate values**

  There are no duplicate values in raw_titles table. There are no duplicate values in credits table . But there are entries with same id and person_id but with different character or role. Now I want to have a unique combination of person_id and id, with unique role i.e for either director or actor and concatenate all the character types into a single character. I'll do it later.

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

![Screenshot (912)](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/c612e450-3a0c-49f6-a4c8-7b736b63979e)

* ### **Step 12 - Changing the cases of the texts into Proper case**

* ### **Step 13 - Trimming the white, leading and trailing spaces**

* ### **Step 14 - String manipulation**

  * **14.1 -  Removing the [ ] and '' (quotation marks) from genres and production_countries columns**
    
  The columns production_countries and genres look like this in this image below.

![Screenshot (913)](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/53bd55c4-6667-4d5c-a070-8e0802265c24)

  After removing the [ ] and '', the rows look like this now -

![Screenshot (913)](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/49200717-b38a-4ef6-95d4-8a576ec67b74)

  * **14.2 - Replacing the null values with default values** 
  * **14.3 - Setting the Null values in character column to 'No information'**
  * **14.4 - Setting the null values in seasons to 0 which corresponds to movies**
  * **14.5 - Setting the null values in age_certification to 'Others'**    
  * **14.6 - Setting the values with [] in genres column with 'N/A'**
  * **14.7 - Setting the values with [] in production_countries column with 'N/A'**

* ### **Step 15 - Modifying the titles**

  * **15.1 - Renaming title '30 March' to '30.March'** 
  * **15.2 - Replacing '#' from the beginning of some titles**

* ### **Step 16 - Removing the extra columns**

* ### **Step 17 - Concatenating multiple characters into a single row**

  In a film or show, there are multiple roles that are played by more than one person. Occasionally, multiple characters might be played by one person. The `raw_titles` table holds the data of unique shows, while the `raw_credits` table holds the data of people who have played a certain character in a particular show. Actors and shows have a many-to-many relationship, meaning that one film/show might have more than one actor, and one actor may play more than one character both in one show or in multiple shows. To make it easier for users to look up any actor associated with a particular show and also get the information on the character they played, a table named `credits` was created with similar fields as the `raw_credits` table. The only difference between these two tables is that `raw_credits` sometimes holds information about characters played by a certain actor in a certain show in more than one row, while in the `credits` table, there is only one (unique) combination of `show_id`, `person_id`, `character played`, and `role` (i.e., either director or actor). This reduces the number of duplicate rows in the table.

![Screenshot (908)](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/4f18d8a6-283a-484f-b40e-dcc854855754)
    
    DROP TABLE IF EXISTS credits;
    CREATE TABLE credits (person_id INTEGER, id VARCHAR(20), name TEXT, role VARCHAR(8), character TEXT);

    INSERT INTO credits (person_id, id, name,role, character) SELECT person_id, id, name, role, STRING_AGG(character, ' / ') FROM raw_credits GROUP BY person_id, id, name, role;

  This query groups the rows in the raw_credits table by person_id,id,name and role and concatenate the values in the character column for each group using the string_agg function. The resulting table will have 5 columns: person_id,id, name, character, role where character contains the concatenated values of the character column for each group. This table now has 77122 entries. 

![Screenshot (909)](https://github.com/Arpita-deb/netflix-movies-and-tv-shows/assets/139372731/6c7c7fbe-ee1b-4751-ab6a-1a0822ae068a)

* ### **Step 18 - Renaming the 'raw_titles' table to 'titles'**

* ### **Step 19 - Saving the new tables and import them as cleaned csv files**

# Database Design:

By the end of data cleaning process we end up with two clean tables, *titles* containing all information on shows/movies and *credits* containing the information of actors and directors associated with each show. In both tables, the one important attribute that uniquely identifies a show is its **id**. Each table has this column that helps us join the two tables together. 

![initial data dist](https://github.com/Arpita-deb/Books-Database-Normalization/assets/139372731/5e10a804-e422-477f-8414-d5e4ceef96c0)

But the titles table contain 5249 unique entries of shows, while credits show contain information for 5434 shows. Clearly, these extra rows in credits table have no equivalent data in shows table. So,we'll remove these redundant rows that would not help us in the analysis.

![Show](https://github.com/Arpita-deb/Books-Database-Normalization/assets/139372731/764b48d0-8276-4724-926b-fda2334e00d9)

Using Inner Join we selected the data that are present in both tables and saved them as the third table *netflix_table*. Now that we have one table that has all the non-null entries, we are ready to normalize it. 


Database design is the organization of data according to a database model. The designer determines what data must be stored and how the data elements interrelate.

Like any design process, database and information system design begins at a high level of abstraction and becomes increasingly more concrete and specific. Data models can generally be divided into three categories, which vary according to their degree of abstraction. The process will start with a conceptual model, progress to a logical model and conclude with a physical model.

* ## Conceptual data model:

They are also referred to as domain models and offer a big-picture view of what the system will contain, how it will be organized, and which business rules are involved. Conceptual models are usually created as part of the process of gathering initial project requirements. Typically, they include entity classes (defining the types of things that are important for the business to represent in the data model), their characteristics and constraints, the relationships between them and relevant security and data integrity requirements.

![conceptual model](https://github.com/Arpita-deb/Books-Database-Normalization/assets/139372731/229bc1b8-7799-426b-866e-20d9a0fb9184)

* ## Logical data model:

They are less abstract and provide greater detail about the concepts and relationships in the domain under consideration. One of several formal data modeling notation systems is followed. These indicate data attributes, such as data types and their corresponding lengths, and show the relationships among entities. Logical data models don’t specify any technical system requirements. This stage is frequently omitted in agile or DevOps practices. Logical data models can be useful in highly procedural implementation environments, or for projects that are data-oriented by nature, such as data warehouse design or reporting system development.

![logical model](https://github.com/Arpita-deb/Books-Database-Normalization/assets/139372731/371cd6c6-d3ef-4fae-8be1-dd3e979cd4ca)

* ## Physical data model:

They provide a schema for how the data will be physically stored within a database. As such, they’re the least abstract of all. They offer a finalized design that can be implemented as a relational database, including associative tables that illustrate the relationships among entities as well as the primary keys and foreign keys that will be used to maintain those relationships. Physical data models can include database management system (DBMS)-specific properties, including performance tuning.

![physical model](https://github.com/Arpita-deb/Books-Database-Normalization/assets/139372731/1c972f98-6226-4768-9656-537d884cb181)

This database is normalized upto 3rd Normal Form. It ensures that -

1. Each table have columns that only store a single piece of data and that data is accessed through a unique key (Primary Key). [First Normal Form]
2. Each Non-key attributes (i.e., columns other than primary key(s) are functionally dependent on the primary key only. [Second Normal Form]
3. There is no transitional dependency of the non-key attributes i.e., each table has columns that are dependent only on the key. [Third Normal Form]

# Data Analysis:
# Data Visualization:
# Results:

## Resources:

1. Dataset
   
   * [Netflix Movies and Series in Kaggle](https://www.kaggle.com/datasets/thedevastator/the-ultimate-netflix-tv-shows-and-movies-dataset?rvi=1)
   * [Netflix Movies and Series in data.world](https://data.world/gonzandrobles/netflix-movies-and-series)
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
