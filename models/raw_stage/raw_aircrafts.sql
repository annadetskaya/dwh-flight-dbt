{{
        config(
            materialized = 'table'
        )
}}

select 
    aircraft_code, 
    model, 
    range,
    'bookings' as RECORD_SOURCE, {# метка из какой исходной системы пришли эти данные #}
    now() as LOAD_DATE {# когда эта запись была загружена в Data Vault #}
from 
    {{ source('demo_src', 'aircrafts') }}