{{
    config(
        materialized = 'table',
        meta = {
            'owner': 'sql_file_owner@gmail.com'
        }
    )
}}
select
    {{ show_columns_relation('stg_flights__bookings')}},
    {{ dbt_utils.generate_surrogate_key(['book_ref']) }}::varchar(32) as booking_hk
from 
    {{ ref('stg_flights__bookings') }}