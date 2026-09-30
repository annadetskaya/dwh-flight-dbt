{% test airport_code_pattern(model, column_name) %}
    SELECT
        {{ column_name }}
    FROM
        {{ model }}
    WHERE NOT {{ column_name }} ~ '^[A-Z]{3}$'
{% endtest %}
