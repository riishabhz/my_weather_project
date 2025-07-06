/*
Grain:
One row per forecast_date per postal_code.
Each row represents the enriched weather data for a single forecast date and postal code combination,
including forecasted, historical, and climatology measurements.
*/

{{ 
  config(
    materialized = 'table',
    tags = ['entities', 'enriched']
  )
}}

with forecast as (
    select distinct * from {{ ref('stg_forecast_day') }}
),

history as (
    select * from {{ ref('stg_history_day') }}
),

climatology as (
    select * from {{ ref('stg_climatology_day') }}
)

select
    f.postal_code as postal_code,
    f.forecast_date as forecast_date,
    f.day_of_year as day_of_year,

    -- Forecast data
    f.min_air_temp_f as forecast_min_air_temp_f,
    f.avg_air_temp_f as forecast_avg_air_temp_f,
    f.max_air_temp_f as forecast_max_air_temp_f,
    f.total_precip_in as forecast_total_precip_in,
    f.precip_prob_pct as forecast_precip_prob_pct,
    f.avg_rel_humidity_pct as forecast_avg_rel_humidity_pct,
    f.avg_wind_mph as forecast_avg_wind_mph,
    f.avg_wind_dir_deg as forecast_avg_wind_dir_deg,
    f.avg_solar_rad_wpm2 as forecast_avg_solar_rad_wpm2,

    -- Historical data
    h.min_air_temp_f as history_min_air_temp_f,
    h.avg_air_temp_f as history_avg_air_temp_f,
    h.max_air_temp_f as history_max_air_temp_f,
    h.total_precip_in as history_total_precip_in,
    h.avg_rel_humidity_pct as history_avg_rel_humidity_pct,
    h.avg_wind_mph as history_avg_wind_mph,
    h.avg_wind_dir_deg as history_avg_wind_dir_deg,
    h.avg_solar_rad_wpm2 as history_avg_solar_rad_wpm2,

    -- Climatology data
    c.climatology_min_air_f as climatology_min_air_temp_f,
    c.climatology_avg_air_f as climatology_avg_air_temp_f,
    c.climatology_max_air_f as climatology_max_air_temp_f,
    c.climatology_avg_precip_in as climatology_total_precip_in,
    c.climatology_avg_rel_humidity_pct as climatology_avg_rel_humidity_pct,
    c.climatology_avg_solar_rad_wpm2 as climatology_avg_solar_rad_wpm2,

    current_timestamp() as loaded_at

from forecast f
left join history h
    on f.postal_code = h.postal_code
   and f.day_of_year = h.day_of_year
left join climatology c
    on f.postal_code = c.postal_code
   and f.day_of_year = c.day_of_year
