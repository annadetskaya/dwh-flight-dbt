13:40:02  Running with dbt=1.12.2
13:40:02  Registered adapter: postgres=1.11.0
13:40:05  Found 20 models, 4 snapshots, 13 analyses, 2 seeds, 7 data tests, 8 sources, 630 macros


with source as (

    select * from {{ source('demo_src', 'aircrafts') }}

),

renamed as (

    select
        aircraft_code,
        model,
        range

    from source

)

select * from renamed

