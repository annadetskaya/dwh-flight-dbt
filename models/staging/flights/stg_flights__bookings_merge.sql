{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'merge',
        unique_key = ['book_ref'],
        tags = ['bookings'],
         merge_update_columns = ['total_amount'], 
         on_schema_change = 'sync_all_columns'
    )
}}

select 
    "book_ref", 
    "book_date", 
    "total_amount"
from {{ source('demo_src', 'bookings') }}
{% if is_incremental() %}
    where 
        book_date > (
            select max(book_date) - interval '97 day'
            from {{ source('demo_src', 'bookings') }}
        )
{% endif %}

{# бизнес решил, что через 7 дней данные точно не изменятся (синтаксис Postgress) #}
{# получаем все измененные строки за последние 7 дней #}