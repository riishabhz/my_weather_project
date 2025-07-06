{{ 
  config(
    materialized = 'table',
    tags = ['mart', 'dimension']
  ) 
}}

select distinct
    postal_code
from {{ ref('ent_weather_enriched') }}
