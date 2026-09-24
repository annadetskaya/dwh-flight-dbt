{% macro safe_select(table_name) %}

{% set relation = adapter.get_relation(
    database=target.database,
    schema=target.schema,
    identifier=table_name
) %}

{% if relation %}
    SELECT *
    FROM {{relation}}
{% else %} 
    SELECT NULL
{% endif %}

{% endmacro %}