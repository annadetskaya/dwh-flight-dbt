{{
    config(
        materialized = 'table'
    )
}}

select 
    fl.departure_airport_id AS Departure_Airport_Code, -- код аэропорта отправления
    dep.airport_name AS Departure_Airport_Name, -- название аэропорта отправления (dep)
    dep.city AS Departure_Airport_City, -- город аэропорта отправления
    dep.coordinates AS Departure_Airport_Coordinates, -- координаты аэропорта отправления
    
    fl.arrival_airport_id AS Arrival_Airport_Code, -- код аэропорта прибытия 
    arr.airport_name AS Arrival_Airport_Name, -- название аэропорта прибытия (arr)
    arr.city AS Arrival_Airport_City, -- город аэропорта прибытия
    arr.coordinates AS Arrival_Airport_Coordinates, -- координаты аэропорта прибытия

    fl.status AS Flight_status, -- статус рейса

    fl.aircraft_id AS Aircraft_code, -- код самолета
    ac.model AS Aircraft_model, -- модель самолета

    fl.scheduled_departure::date AS Scheduled_departure_date, -- запланированная дата отправления
    fl.flight_no AS Flight_no, -- номер полета
    fl.flight_id AS Flight_id, -- идентификатор полета
    
    coalesce(mt.ticket_flights_purchased, 0) AS Ticket_flights_purchased, -- кол-во купленных билетов
    coalesce(mt.boarding_passes_issued, 0) AS Boarding_passes_issued, -- кол-во выданных посадочных талонов
    coalesce(mt.ticket_flights_amount, 0) AS Ticket_flights_amount, -- сумма стоимости проданных билетов 
    sc.seats_total - coalesce(mt.ticket_flights_purchased, 0) AS Ticket_flights_no_sold -- кол-во не проданных билетов

from
    {{ ref('fct_flights') }} fl
left join
    {{ ref('stg_flights__airports') }} dep
    on fl.departure_airport_id = dep.airport_code
left join
    {{ ref('stg_flights__airports') }} arr
    on fl.arrival_airport_id = arr.airport_code
left join
    {{ ref('stg_flights__aircrafts') }} ac 
    on fl.aircraft_id = ac.aircraft_code
left join 
     {{ ref('int_flight_ticket_metrics') }} mt
     on fl.flight_id = mt.flight_id
left join 
     {{ ref('int_aircraft_seat_capacity') }} sc
     on fl.aircraft_id = sc.aircraft_code

