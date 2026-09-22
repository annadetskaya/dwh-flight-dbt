{{
    config(
        materialized = 'table'
    )
}}

select
    ft.ticket_no,
    ft.book_ref,
    ft.passenger_id,
    ft.passenger_name,
    ft.contact_data
from {{ ref('stg_flights__tickets') }} ft

left join {{ ref('stg_dict_airline_employees') }} em
    on ft.passenger_id = em.passenger_id

where em.passenger_id is null