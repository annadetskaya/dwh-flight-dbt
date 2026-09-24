{%- macro concat_columns(columns, delim = ', ') %}
    {%- for column in columns -%}
        {{ column }} {% if not loop.last %} || '{{delim}}' || {% endif %}
    {%- endfor -%}
{% endmacro %}



{% macro drop_old_relations(dryrun=False) %}
{% if execute %}

{# Get all dbt models, seeds, and snapshots #}
{% set current_models = [] %}
        
    {% for node in graph.nodes.values() | selectattr("resource_type", "in", ["model", "snapshot", "seed"]) %}
        {% do current_models.append(node.name) %}
    {% endfor %}

{# Build a cleanup script for tables and views not managed by dbt #}
{% set cleanup_query %}
WITH MODELS_TO_DROP AS (
    SELECT
        CASE
            WHEN TABLE_TYPE = 'BASE TABLE' THEN 'TABLE'
            WHEN TABLE_TYPE = 'VIEW' THEN 'VIEW'
        END AS RELATION_TYPE,
        CONCAT_WS('.', TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME) AS RELATION_NAME
    FROM 
        INFORMATION_SCHEMA.TABLES 
    WHERE 
        TABLE_SCHEMA = '{{ target.schema }}'
        AND UPPER(TABLE_NAME) NOT IN (
            {%- for model in current_models -%}
                '{{ model.upper() }}'
                {%- if not loop.last -%}
                    ,
                {%- endif %}
            {%- endfor -%}
    )
) 
SELECT
    'DROP ' || RELATION_TYPE || ' ' || RELATION_NAME || ';' as DROP_COMMANDS
FROM
    MODELS_TO_DROP;
{% endset %}

{% set drop_commands = run_query(cleanup_query).columns[0].values() %}
{# Drop unused tables and views or print the commands #}
    {% if drop_commands %}
        {% if dryrun | as_bool == False %}
            {% do log('Executing DROP commands ...', True) %}
        {% else %}
            {% do log('Printing DROP commands ...', True) %}
        {% endif %}

        {% for drop_command in drop_commands %}
            {% do log(drop_command, True) %}
            {% if  dryrun | as_bool == False %}
            {% do run_query(drop_command) %}
            {% endif %}
        {% endfor %}
    {% else %}
            {% do log('No relations to clean', True) %}
    {% endif %}

{% endif %}
{% endmacro %}

{% macro show_columns_relation(table_name) %}

    {% set relation = ref(table_name) %}

    {% if execute %}
        {% set columns = adapter.get_columns_in_relation(relation) %}
        {% for column in columns -%}
            {{ column.name }}{% if not loop.last %}, {% endif %}
        {%- endfor %}
    {% endif %}

{% endmacro %}