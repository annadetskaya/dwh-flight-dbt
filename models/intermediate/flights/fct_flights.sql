{{
    config(
        materialized = 'table'
    )
}}

select
    flight_id,
    flight_no,
    scheduled_departure,
    scheduled_arrival,
    departure_airport as departure_airport_id,
    arrival_airport as arrival_airport_id,
    status,
    aircraft_code as aircraft_id,
    actual_departure,
    actual_arrival,
    case
        when actual_departure is not null and actual_arrival is not null
        then actual_arrival - actual_departure
        else INTERVAL '0 seconds'
    end as actual_duration_flight,

    case
        when actual_departure is not null and scheduled_departure < actual_departure
        then actual_departure - scheduled_departure
        else INTERVAL '0 seconds'
    end as flight_departure_delay,

    current_date as load_date,
    {{ concat_columns(['flight_id','flight_no'])}} as flight_info
from
    {{ ref('stg_flights__flights') }}