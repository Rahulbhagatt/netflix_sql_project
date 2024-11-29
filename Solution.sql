--netflix project

 create table netflix
(
 show_id	varchar(6),
 type	   varchar(10),
 title	   varchar(150),
 director  varchar(208),
 casts	   varchar(1000),
 country	 varchar(150),
 date_added	 varchar(50),
 release_year	INT,
 rating	  varchar(10),
 duration varchar(15),
 listed_in	varchar(100),
 description  varchar(250)
);

select * from netflix;

select count(*) as total_count from netflix;

select distinct type from netflix;

-- 13 business problems & Solutions

--1. Count the number of Movies vs TV Shows

select 
	type,
	count(*) as total_content
from netflix
group by type;

2. Find the most common rating for movies and TV shows

select 
	type,
	rating
from
(
 select 
	type,
	rating,
	count(*),
	rank() over(partition by type order by count(*)desc) as ranking
 from netflix
 group by 1, 2
) as t1
where
	ranking = 1

3. List all movies released in a specific year (e.g., 2020)

select * from netflix
where 
	type = 'Movie'
	and
	release_year = 2020

4. Find the top 5 countries with the most content on Netflix

select 
	unnest(string_to_array(country,', ')) as new_country,
	count(show_id) as total_content
from netflix
group by 1
order by 2 desc
limit 5

5. Identify the longest movie

select Max(duration) from netflix
where
	type = 'Movie'
	and
	duration = (select MAX(duration) from netflix)

6. Find all the movies/TV shows by director 'Rajiv Chilaka'!

select * from netflix
where director like '%Rajiv Chilaka%'

7. List all TV shows with more than 5 seasons

select 
	*
from netflix
where 
	type = 'TV Show'
	and
	Split_part(duration, ' ', 1)::numeric > 5

8. Count the number of content items in each genre

select 
	unnest(string_to_array(listed_in, ',')) as genre,
	count(show_id) as total_content
from netflix    
group by 1

9. List all movies that are documentaries

select * from netflix
where 
	listed_in ILIKE '%documentaries%' 

10. Find all content without a director

select * from netflix
where 
	director is null


11. Find how many movies actor 'Salman Khan' appeared in last 10 years!

select * from netflix
where 
	casts ILIKE '%Salman Khan%'
	and
	release_year > Extract(year from current_date) - 10

12. Find the top 10 actors who have appeared in the highest number of movies produced in India.

select
unnest(string_to_array(casts, ',')) as actor,
count(*) as total_content
from netflix
where country ILIKE '%india'
group by 1
order by 2 desc
limit 10


13.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
  the description field. Label content containing these keywords as 'Bad' and all other 
  content as 'Good'. Count how many items fall into each category.

With new_table
AS
(
select 
*,
	CASE
	WHEN
		description ILIKE '%kill%' OR
		description ILIKE '%violence%' THEN 'Bad_content'
		ELSE 'Good content'
	END category
from netflix
)
Select
	category,
	count(*) as total_content
from new_table
group by 1

-- End --
