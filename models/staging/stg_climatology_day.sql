-- models/staging/stg_climatology_day.sql

{{ 
  config(
    materialized = 'table',
    tags = ['staging']
  ) 
}}

with raw as (
  select * from {{ source('climate_data_for_bi','climatology_day') }}
)

select
  postal_code::varchar                                        as postal_code,
  doy_std                                                     as day_of_year,
  avg_of__daily_min_temperature_air_f::numeric(5,1)           as climatology_min_air_f,
  avg_of__daily_avg_temperature_air_f::numeric(5,1)           as climatology_avg_air_f,
  avg_of__daily_max_temperature_air_f::numeric(5,1)           as climatology_max_air_f,
  avg_of__daily_min_temperature_wetbulb_f::numeric(5,1)       as climatology_min_wetbulb_f,
  avg_of__daily_avg_temperature_wetbulb_f::numeric(5,1)       as climatology_avg_wetbulb_f,
  avg_of__daily_max_temperature_wetbulb_f::numeric(5,1)       as climatology_max_wetbulb_f,
  avg_of__daily_min_humidity_relative_pct::int                as climatology_min_rel_humidity_pct,
  avg_of__daily_avg_humidity_relative_pct::int                as climatology_avg_rel_humidity_pct,
  avg_of__daily_max_humidity_relative_pct::int                as climatology_max_rel_humidity_pct,
  avg_of__pos_daily_tot_precipitation_in::numeric(6,2)        as climatology_avg_precip_in,
  frq_of__daily_tot_precipitation_zero_in_pct::int            as climatology_zero_precip_pct,
  avg_of__pos_daily_tot_snowfall_in::numeric(6,2)             as climatology_avg_snow_in,
  frq_of__pos_daily_tot_snowfall_in_pct::int                  as climatology_zero_snow_pct,
  avg_of__daily_avg_radiation_solar_total_wpm2::numeric(8,1)  as climatology_avg_solar_rad_wpm2
from raw
