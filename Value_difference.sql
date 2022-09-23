-- write your code in PostgreSQL 9.4
with temp as (
    SELECT event_type, value, 
        RANK () OVER(PARTITION BY event_type ORDER BY time  DESC) as rk
    FROM events),

latest as (
    SELECT event_type, value
    FROM temp
    WHERE rk=1),

earlier as (
    SELECT event_type,value
    FROM temp
    WHERE rk=2),

difference as (
    SELECT latest.event_type, latest.value-earlier.value as value
    FROM latest
    JOIN earlier
    ON latest.event_type = earlier.event_type
)

SELECT event_type, value
FROM difference