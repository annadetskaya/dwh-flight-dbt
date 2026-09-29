{{
    config(
        materialized = 'table'
    )
}}

select
    flight_id,
    count(ticket_no) as ticket_flights_purchased,
    count(boarding_no) as boarding_passes_issued,
    sum(amount) as ticket_flights_amount

from {{ ref('fct_ticket_flights') }}

group by flight_id