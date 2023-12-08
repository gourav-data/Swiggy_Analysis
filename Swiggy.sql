
USE practice_db;
SELECT 
    *
FROM
    swiggy;
    
-- Total number of restaurant in each city  

SELECT DISTINCT
    city,
    COUNT(DISTINCT area) AS Total_area,
    COUNT(DISTINCT restaurant) AS Total_Restaurant
FROM
    swiggy
GROUP BY city;


-- Top restaurant of every city  
select DISTINCT city,
		FIRST_VALUE(area) over(partition by city order by Total_ratings desc,avg_rating desc) as Area,
		FIRST_VALUE(restaurant) over(partition by city order by Total_ratings desc,avg_rating desc) as Top_Restaurent,
        FIRST_VALUE(avg_Rating) over(partition by city order by Total_ratings desc,avg_rating desc) as Ratings
from swiggy;

-- Top 10 cities with chinese restaurant
 
SELECT 
    city,
    area,
    COUNT(restaurant) Total_Restaurant,
    ROUND(AVG(avg_rating)) AS Rating
FROM
    swiggy
WHERE
    food_type LIKE '%Chinese%'
GROUP BY city , area
ORDER BY COUNT(restaurant) DESC
LIMIT 10;

-- Average food delivery time  v/s food delivery time in each city 

CREATE VIEW delivery_Time AS
    SELECT city,area,ROUND(AVG(delivery_time)) AS Average_Delivery_Time
    FROM swiggy
    GROUP BY city , area
    ORDER BY average_Delivery_Time;
SELECT city, area,
    CASE
        WHEN average_delivery_time > (SELECT AVG(Delivery_Time) FROM swiggy) THEN 'Slow'
        WHEN average_delivery_time <= (SELECT  AVG(Delivery_Time) FROM swiggy) THEN 'Fast'
    END AS Food_Delivery
FROM delivery_time;
