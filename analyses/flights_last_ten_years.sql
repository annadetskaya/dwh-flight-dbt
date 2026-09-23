{% set current_date = run_started_at | string | truncate(10, True, "") %}
{% set current_year = current_date[:4] | int %}
{% set prev_year = current_year - 10 %}
{% set prev_date = (prev_year | string) ~ current_date[4:] %}


SELECT
    COUNT(*) AS flights_cnt,
    scheduled_departure::date AS departure_date
FROM
    {{ ref('fct_flights') }}
WHERE
    scheduled_departure::date 
        BETWEEN '{{ prev_date }}'::date 
        AND '{{ current_date }}'::date
GROUP BY scheduled_departure::date 


{% set source_relation = adapter.get_relation(
      database="dwh_flight_anna",
      schema="intermediate",
      identifier="fct_fligths")
%}

{{ source_relation }}
{{ source_relation.database  }}
{{ source_relation.schema  }}
{{ source_relation.identifier  }}
{{ source_relation.is_table  }}
{{ source_relation.is_view  }}
{{ source_relation.is_cte  }}