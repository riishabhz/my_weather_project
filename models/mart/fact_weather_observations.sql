/*
Grain: One row per forecast date per postal code. 
      This table contains weather measurements like temperature, humidity, precipitation, etc., 
      aggregated at the day level for each postal code.

*/

{{ 
  config(
    materialized = 'table',
    tags = ['mart', 'fact']
  ) 
}}

select
    md5(concat(cast(forecast_date as string), '_', postal_code)) as unique_key,
    forecast_date,
    postal_code,

    min(forecast_min_air_temp_f) as forecast_min_air_temp_f,
    avg(forecast_avg_air_temp_f) as forecast_avg_air_temp_f,
    max(forecast_max_air_temp_f) as forecast_max_air_temp_f,
    sum(forecast_total_precip_in) as forecast_total_precip_in,
    max(forecast_precip_prob_pct) as forecast_precip_prob_pct,
    avg(forecast_avg_rel_humidity_pct) as forecast_avg_rel_humidity_pct,
    avg(forecast_avg_wind_mph) as forecast_avg_wind_mph,
    avg(forecast_avg_wind_dir_deg) as forecast_avg_wind_dir_deg,
    avg(forecast_avg_solar_rad_wpm2) as forecast_avg_solar_rad_wpm2,

    min(climatology_min_air_temp_f) as climatology_min_air_temp_f,
    avg(climatology_avg_air_temp_f) as climatology_avg_air_temp_f,
    max(climatology_max_air_temp_f) as climatology_max_air_temp_f,
    sum(climatology_total_precip_in) as climatology_total_precip_in,
    avg(climatology_avg_rel_humidity_pct) as climatology_avg_rel_humidity_pct

from {{ ref('ent_weather_enriched') }}

group by
    forecast_date,
    postal_code
