{% macro graph_cnt() %}

    {% if execute %}

        {% set models = graph.nodes.values()
            | selectattr("resource_type", "equalto", "model")
            | list
            | length %}

        {% set seeds = graph.nodes.values()
            | selectattr("resource_type", "equalto", "seed")
            | list
            | length %}

        {% set snapshots = graph.nodes.values()
            | selectattr("resource_type", "equalto", "snapshot")
            | list
            | length %}

        {% do log("Total in project:", True) %}
        {% do log("- " ~ models ~ " models", True) %}
        {% do log("- " ~ seeds ~ " seed", True) %}
        {% do log("- " ~ snapshots ~ " snapshot", True) %}

    {% endif %}

{% endmacro %}