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


        /*book_ref > current_date - interval '7 day' -- к примеру, так решил бизнес, что через 7 дней данные точно не изменятся (синтаксис Postgress)
        -- получаем все измененные строки за последние 7 дней
        -- мы бы так писали в реальной жизни, а не на учебном проекте, где даты сильно старые*/

{% endif %}