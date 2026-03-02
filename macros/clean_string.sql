{% macro clean_string(column, allowed_values=none) %}
    {% if allowed_values is not none and allowed_values|length > 0 %}
        case
            when lower({{ column }}) in ({{ allowed_values | map('lower') | join(", ") }})
                then lower({{ column }})
            else 'other'
        end
    {% else %}
        trim(lower({{ column }}))
    {% endif %}
{% endmacro %}