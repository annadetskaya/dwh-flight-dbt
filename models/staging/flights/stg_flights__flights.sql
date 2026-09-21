{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'merge',
        unique_key = ['flight_id']
    )
}}

select 
    flight_id, flight_no, scheduled_departure, scheduled_arrival, departure_airport, arrival_airport, status, aircraft_code, actual_departure, actual_arrival 
from 
    {{ source('demo_src', 'flights') }}

{% if is_incremental() %}
    where 
        scheduled_departure >= (
            select max(scheduled_departure) - interval '100 day'
            from {{ source('demo_src', 'flights') }}
        )

{% endif %}