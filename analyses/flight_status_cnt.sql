{# Get unique statuses for the parameter array #}

{% set statuses_query %}

SELECT DISTINCT
    status
FROM
    {{ ref('stg_flights__flights') }}
{% endset %}  


{% set statuses_query_result = run_query(statuses_query) %}

{% if execute %}
    {% set unique_status = statuses_query_result.columns[0].values() %}
{% else %}
    {% set unique_status = [] %}
{% endif %}


SELECT 
    {% for status in unique_status -%}
    SUM(
        CASE 
            WHEN status = '{{ status }}' THEN 1 
            ELSE 0 
        END
    ) AS status_{{ status | lower | replace(' ', '_') }}
    {%- if not loop.last %},{% endif %}
    {% endfor %}
FROM
    {{ ref('stg_flights__flights') }}