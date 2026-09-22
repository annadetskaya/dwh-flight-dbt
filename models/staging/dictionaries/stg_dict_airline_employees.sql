{{
    config(
        materialized = 'table'
    )
}}

select
    passenger_id
from {{ ref('airline_employees') }}