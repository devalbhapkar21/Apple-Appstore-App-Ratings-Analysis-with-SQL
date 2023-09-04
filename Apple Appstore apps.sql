--Checking Number of Unique Apps in Both TablesAppleStore
SELECT COUNT(DISTINCT id) AS UniqueAppId
FROm AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppId
FROm appleStore_description

--Checking for Missing Values
SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name is NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) AS MissingValues 
FROM appleStore_description
where app_desc IS NULL 


--Checking no. of apps per genre

select prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps desc


-- Getting an overview of Apps rating
SELECT min(user_rating) as MinRating,
	   max(user_rating) AS MaxRating,
       avg(user_rating) AS AvgRating
FROM AppleStore


--Checking Whether paid apps have higher ratings than free apps

SELECT CASE
 			when price > 0 THEN 'Paid'
            ELSE 'Free'
        END AS app_type,
        avg(user_rating) AS avg_rating
FROM AppleStore
GROUP BY app_type


--Checking if apps that support more languages have higher ratings
select CASE
			when lang_num < 10 then '<10 Languages'
            when lang_num BETWEEN 10 and 30  Then '10-30 Languages'
            else '>30 Languages'
       END AS lang_bucket,
  	   avg(user_rating) AS avg_rating
FROM AppleStore
GRoup by lang_bucket
ORDER BY avg_rating


--Checking genres with low ratings
SELECT prime_genre,
	   avg(user_rating) AS avg_rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY avg_rating ASC
Limit 10


--Checking if there's correlation between the app description length and user rating 
SELECT CASE 
			WHEN length(b.app_desc) < 500 then 'short'
            WHEN length(b.app_desc) BETWEEN 500 and 1000 then 'medium'
            else 'long'
       END AS description_length_bucket,
       avg(user_rating) AS avg_rating
FROM AppleStore AS a
JOIN appleStore_description as b 
ON a.id = b.id
GROUP BY description_length_bucket
order by avg_rating DESC


--Checking top rated apps for each genre 
select prime_genre,track_name,user_rating
FROM(
     SELECT 
  	 prime_genre,
  	 track_name,
  	 user_rating,
     RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC,rating_count_tot DESC) AS rank
     FROM AppleStore
  ) AS a 
WHERE 
a.rank = 1


