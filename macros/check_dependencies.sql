{% macro check_dependencies() %}

    {% if execute %}

        {% set dependencies = model.depends_on.nodes %}
        {% set dependencies_count = dependencies | length %}

        {% if dependencies_count > 1 %}
            {% do exceptions.warn(
                "Model " ~ model.name ~
                " depends on " ~ dependencies_count ~
                " objects!"
            ) %}
        {% endif %}

    {% endif %}

{% endmacro %}