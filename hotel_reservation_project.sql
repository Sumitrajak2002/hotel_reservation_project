
/*
1. What is the total number of reservations in the dataset?
2. Which meal plan is the most popular among guests?

3. What is the average price per room for reservations involving children?
4. How many reservations were made for the year 20XX (replace XX with the desired year)?
5. What is the most commonly booked room type?
6. How many reservations fall on a weekend (no_of_weekend_nights > 0)?
7. What is the highest and lowest lead time for reservations?
8. What is the most common market segment type for reservations?
9. How many reservations have a booking status of "Confirmed"?
10. What is the total number of adults and children across all reservations?
11. What is the average number of weekend nights for reservations involving children?
12. How many reservations were made in each month of the year?
13. What is the average number of nights (both weekend and weekday) spent by guests for each room
type?
14. For reservations involving children, what is the most common room type, and what is the average
price for that room type?
15. Find the market segment type that generates the highest average price per room.
*/ 
use hotel;
select * from hotel_data;
-- QUERY 1: Total number of reservations in the dataset
SELECT 
COUNT(booking_id) AS total_reservation_count 
FROM hotel_data;

-- QUERY 2: Most popular meal plan among guests

select type_of_meal_plan, count(type_of_meal_plan) from hotel_data group by type_of_meal_plan;

WITH popular_meal_ranking AS (
SELECT 
type_of_meal_plan, 
COUNT(*) AS reservation_count, 
RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking 
FROM hotel_data 
GROUP BY type_of_meal_plan
)
SELECT 
type_of_meal_plan, 
reservation_count 
FROM popular_meal_ranking 
WHERE ranking = 1;

-- QUERY 3: Average price per room for reservations involving children
SELECT 
ROUND(AVG(avg_price_per_room), 2) AS average_price_per_room_involving_children 
FROM hotel_data 
WHERE no_of_children >= 1;

-- QUERY 4: Reservations that were made in subsequent years
SELECT 
EXTRACT(year FROM arrival_date) AS year, 
COUNT(*) AS reservation_count 
FROM hotel_data 
GROUP BY EXTRACT(year FROM arrival_date)
ORDER BY year;

-- QUERY 5: Most commonly booked room type
WITH popular_room_type AS (
SELECT 
COUNT(*) AS booking_count, 
room_type_reserved, 
RANK() OVER (ORDER BY COUNT(room_type_reserved) DESC) AS ranking 
FROM hotel_data 
GROUP BY room_type_reserved
)
SELECT 
room_type_reserved AS most_commonly_booked_room_type, 
booking_count 
FROM popular_room_type 
WHERE ranking = 1;

-- QUERY 6: Reservations falling on a weekend
SELECT 
COUNT(*) AS weekend_reservation 
FROM hotel_data 
WHERE no_of_weekend_nights > 0;

-- QUERY 7: Highest and lowest lead time for reservations
SELECT 
MAX(lead_time) AS highest_lead_time, 
MIN(lead_time) AS lowest_lead_time 
FROM hotel_data;

-- QUERY 8: Most common market segment type for reservations
WITH common_segment_type AS (
SELECT 
market_segment_type, 
COUNT(*) AS reservation_count, 
RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking 
FROM hotel_data 
GROUP BY market_segment_type
)
SELECT 
market_segment_type AS most_common_market_segment_type, 
reservation_count 
FROM common_segment_type 
WHERE ranking = 1;

-- QUERY 9: Reservations having a booking status of "Confirmed"
SELECT 
COUNT(*) AS confirmed_reservation 
FROM hotel_data 
WHERE booking_status = 'Not_Canceled';

-- QUERY 10: Total number of adults and children across all reservations
SELECT 
SUM(no_of_adults) AS total_adults, 
SUM(no_of_children) AS total_children 
FROM hotel_data;

-- QUERY 11: Average number of weekend nights for reservations involving children
SELECT 
ROUND(AVG(no_of_weekend_nights), 2) AS average_weekend_night_with_children 
FROM hotel_data 
WHERE no_of_children > 0;

-- QUERY 12: Reservations made in each month of the year

select arrival_date from hotel_data;

SELECT 
EXTRACT(year FROM arrival_date) AS year, 
EXTRACT(month FROM arrival_date) AS month, 
COUNT(Booking_ID) AS reservation_count 
FROM hotel_data 
GROUP BY year, month 
ORDER BY year, month;

select arrival_date from hotel_data;

-- QUERY 13: Average number of nights (both weekend and weekday) spent by guests for each room type
SELECT 
room_type_reserved, 
ROUND(AVG(no_of_weekend_nights + no_of_week_nights), 2) AS average_night_spend 
FROM hotel_data 
GROUP BY room_type_reserved
ORDER BY room_type_reserved;

-- QUERY 14: For reservations involving children, most common room type, and the average price for that room type
WITH popular_room_with_children AS (
SELECT 
room_type_reserved, 
COUNT(*) AS reservation_count, 
RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking, 
ROUND(AVG(avg_price_per_room), 2) AS average_price 
FROM hotel_data 
WHERE no_of_children > 0 
GROUP BY room_type_reserved
)
SELECT 
room_type_reserved AS most_popular_room_with_children, 
reservation_count, 
average_price 
FROM popular_room_with_children 
WHERE ranking = 1;

-- QUERY 15: Market segment type that generates the highest average price per room
WITH average_price AS (
SELECT 
market_segment_type, 
RANK() OVER (ORDER BY AVG(avg_price_per_room) DESC) AS ranking, 
ROUND(AVG(avg_price_per_room), 2) AS average_price 
FROM hotel_data 
GROUP BY market_segment_type
)
SELECT 
market_segment_type, 
average_price AS hotel_data 
FROM average_price 
WHERE ranking = 1;
