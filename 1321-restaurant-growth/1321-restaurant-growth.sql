# Write your MySQL query statement below
WITH DailyAmount AS (
    SELECT 
        visited_on,
        SUM(amount) AS daily_sum
    FROM Customer
    GROUP BY visited_on
),
RollingStats AS (
    SELECT 
        visited_on,
        SUM(daily_sum) OVER (
            ORDER BY visited_on 
            RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW
        ) AS amount,
        ROUND(AVG(daily_sum) OVER (
            ORDER BY visited_on 
            RANGE BETWEEN INTERVAL 6 DAY PRECEDING AND CURRENT ROW
        ), 2) AS average_amount,
        MIN(visited_on) OVER () AS first_date
    FROM DailyAmount
)
SELECT 
    visited_on,
    amount,
    average_amount
FROM RollingStats
WHERE DATEDIFF(visited_on, first_date) >= 6
ORDER BY visited_on ASC;