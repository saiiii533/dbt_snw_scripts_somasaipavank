{% macro  clean_string(column) %}
lower(trim({{column}}))
{% endmacro %}
