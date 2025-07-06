{{ 
  config(
    materialized = 'table',
    tags = ['mart', 'dimension']
  ) 
}}

with dates as (
    select
        dateadd(day, seq4(), '2020-01-01') as date_value
    from table(generator(rowcount => 5000))
)

select
    date_value,
    dayofweek(date_value) as day_of_week,
    extract(month from date_value) as month,
    extract(quarter from date_value) as quarter,
    extract(year from date_value) as year
from dates
