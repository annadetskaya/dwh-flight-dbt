{# hub уже хранит ключ сущности #}

{{ config(materialized='incremental')    }}

{%- set source_model = "v_stg_flights__aircrafts"   -%} {# откуда hub берет подготовленные данные #}
{%- set src_pk = "AIRCRAFT_HK"          -%} {#технический hash key сущности Aircraft #}
{%- set src_nk = "aircraft_code"          -%} {# natural/business key самолета #}
{%- set src_ldts = "LOAD_DATE"      -%} 
{%- set src_source = "RECORD_SOURCE"    -%} 

{{ automate_dv.hub(src_pk=src_pk, src_nk=src_nk, src_ldts=src_ldts,
                   src_source=src_source, source_model=source_model) }}