{{
    config(
        severity = 'error',
        error_if = '> 100',
        warn_if = '>= 50'
    )
}}


select
    book_ref,
    count(*) as tickets_cnt
from {{ ref('stg_flights__tickets') }}
group by book_ref
having count(*) >= 5