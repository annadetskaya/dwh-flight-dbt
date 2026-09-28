13:38:48  Running with dbt=1.12.2
13:38:49  Registered adapter: postgres=1.11.0
13:38:51  Found 20 models, 4 snapshots, 13 analyses, 2 seeds, 7 data tests, 8 sources, 630 macros


with source as (

    select * from {{ source('demo_src', 'airports') }}

),

renamed as (

    select
        airport_code,
        airport_name,
        city,
        coordinates,
        timezone

    from source

)

select * from renamed

