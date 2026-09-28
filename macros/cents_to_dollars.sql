{% macro cents_to_dollars(column_name, scale=2) %}
    {% if scale < 0 %}
        {% do exceptions.warn("Invalid `scale`. Got: " ~ scale) %}
    {% endif %}
    ({{ column_name }} / 100.0)::numeric(16, {{ scale }})
{% endmacro %}