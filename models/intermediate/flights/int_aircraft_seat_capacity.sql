{{
    config(
        materialized = 'table'
    )
}}

select
    aircraft_code,
    count(seat_no) as seats_total

from {{ ref('stg_flights__seats') }}

group by aircraft_code