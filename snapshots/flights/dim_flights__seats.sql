{% snapshot dim_aircraft_seats %}

{{
    config(
        target_schema='snapshot',
        unique_key="aircraft_code || '-' || seat_no",

        strategy='check',
        check_cols = ['fare_conditions'],
        dbt_valid_to_current="'9999-01-01'::date"

   )
}}

SELECT
    "aircraft_code",
    "seat_no",
    "fare_conditions"
FROM
    {{ ref('stg_flights__seats') }}

{% endsnapshot %}