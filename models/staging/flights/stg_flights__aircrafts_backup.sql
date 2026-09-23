{{
    config(
        materialized='table',
        pre_hook='
            {% set current_time = run_started_at|string|truncate(19, True, "")|replace("-","_")|replace(" ","_")|replace(":","") %}

            {% set old_relation = adapter.get_relation(
                database=this.database,
                schema=this.schema,
                identifier=this.identifier
            ) %}

            {% set backup_relation = api.Relation.create(
                database=this.database,
                schema=this.schema,
                identifier=this.identifier ~ "_" ~ current_time,
                type="table"
            ) %}

            {% if old_relation %}
                {% do adapter.rename_relation(old_relation, backup_relation) %}
            {% endif %}
        '
    )
}}

SELECT
    aircraft_code,
    model,
    "range"
FROM
    {{ source('demo_src', 'aircrafts') }}