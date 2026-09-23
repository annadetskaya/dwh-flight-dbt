SELECT  
    scheduled_departure::date as scheduled_departure,
    COUNT(*) as cancelled_flight_cnt
FROM
    {{ ref('fct_flights') }}
WHERE 
    departure_airport_id = 'MJZ'
    AND status = 'Cancelled'
GROUP BY
    scheduled_departure::date