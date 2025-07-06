-- models/staging/stg_forecast_day.sql

{{ 
  config(
    materialized = 'table',
    tags = ['staging']
  ) 
}}

with raw as (
  select * from {{ source('climate_data_for_bi','forecast_day') }}

)

select
  postal_code::varchar                             as postal_code,
  date_valid_std::date                             as forecast_date,
  doy_std                                          as day_of_year,
  min_temperature_air_2m_f::numeric(5,1)           as min_air_temp_f,
  avg_temperature_air_2m_f::numeric(5,1)           as avg_air_temp_f,
  max_temperature_air_2m_f::numeric(5,1)           as max_air_temp_f,
  tot_precipitation_in::numeric(6,2)               as total_precip_in,
  probability_of_precipitation_pct::int            as precip_prob_pct,
  avg_humidity_relative_2m_pct::int                as avg_rel_humidity_pct,
  avg_wind_speed_10m_mph::numeric(5,1)             as avg_wind_mph,
  avg_wind_direction_10m_deg::int                  as avg_wind_dir_deg,
  avg_radiation_solar_total_wpm2::numeric(7,1)     as avg_solar_rad_wpm2
from raw
