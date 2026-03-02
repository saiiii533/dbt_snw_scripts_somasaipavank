{% macro date_bucket(ts, level) %}
    case
        when '{{ level }}' = 'month' then date_trunc('month', {{ ts }})
        else {{ ts }}
    end
{% endmacro %}