SELECT  
    aircraft_code,
    count(*) as seats_cnt
FROM
    {{ ref('stg_flights__seats') }}
GROUP BY
    aircraft_code