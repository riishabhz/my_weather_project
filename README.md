Welcome to your new dbt project!

### Using the starter project

Try running the following commands:
- dbt run
- dbt test


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

Business Use Case: This weather data pipeline enables businesses to make informed decisions by providing accurate, timely weather forecasts and historical climate insights at a granular (postal code) level. For example:

Retailers can optimize inventory and staffing based on upcoming weather conditions.
Logistics companies can plan routes and schedules considering weather risks to improve delivery reliability.
Agriculture businesses can use the data to plan planting, irrigation, and harvesting activities aligned with climate trends.
Energy providers can forecast demand and manage renewable sources like solar or wind more efficiently.

By transforming raw weather data into clean, enriched, and tested datasets, the project delivers trusted insights that support operational planning, risk management, and strategic initiatives.

1️⃣ Getting the Data into Snowflake I ingested raw weather data into Snowflake, a cloud-native data warehouse known for its scalability and speed. Snowflake helped me efficiently store and query large volumes of time-series weather data.

I used Global Weather & Climate Data for BI (Weather Source, LLC: Global Weather & Climate Data for BI), perfect for BI and analytics on large-scale time-series data.
https://media.licdn.com/dms/image/v2/D4E12AQEH73gOUefYfQ/article-inline_image-shrink_1000_1488/B4EZfdL6soHcAU-/0/1751762578719?e=1757548800&v=beta&t=do_WS34ug7r6LIoRTEX0sa0Ng7AC30oZf9ZiPkVC3_g


2️⃣ Using Visual Studio Code for Development I used Visual Studio Code as my IDE to manage SQL scripts and dbt models. With its powerful extensions, I connected VS Code directly to Snowflake for seamless query execution and version control.


3️⃣ Connecting dbt with Snowflake Integrating dbt allowed me to modularize SQL transformations, build automated pipelines, and apply data quality tests. dbt’s ability to document and test models ensured a maintainable and trustworthy data environment.

4️⃣ Designing a 3-Layer Data Model I structured the data workflow into three logical layers for clarity and efficiency:

Staging Layer: Raw data ingestion with minimal cleaning and normalization.
Entities Layer: Data enrichment by combining and applying business logic for consistent, descriptive datasets.
Mart Layer: Final fact and dimension tables designed for analytical consumption. These tables can be directly used in BI tools like Power BI, Tableau, and Qlik Sense for insightful reporting and visualization.

https://media.licdn.com/dms/image/v2/D4E12AQHwaWtSdu1ltA/article-inline_image-shrink_1500_2232/B4EZfdMWb3HIAU-/0/1751762692726?e=1757548800&v=beta&t=m5zHMa8H4b-9Z6UCopg0irKwRKX4oDCQ9F-X-nb92Pw

**Lineage of Entity layer**


https://media.licdn.com/dms/image/v2/D4E12AQG5c7c-kmQIag/article-inline_image-shrink_1500_2232/B4EZfdM4wmHsAU-/0/1751762832945?e=1757548800&v=beta&t=E2tNPLA62kqYk2h_2IJrXtPW_lR27GVJyqyFyToV9pY

**Staging, Entity and Mart Layer**

https://media.licdn.com/dms/image/v2/D4E12AQFNNPxf00ddRg/article-inline_image-shrink_1000_1488/B4EZfdO7fmHgAU-/0/1751763368608?e=1757548800&v=beta&t=nQo164Q19Gc8eCwfEXMrUcU3BwvVAHe4NfabPYTwe1k
**Fact Table**

Examples of Fact Table Queries :-
1. Identify days with extreme weather conditions by postal code:
SELECT forecast_date, postal_code, forecast_min_air_temp_f, forecast_max_air_temp_f, forecast_total_precip_in, forecast_precip_prob_pct

FROM RAW_mart.fact_weather_observations

WHERE forecast_min_air_temp_f < 32 -- Freezing days

OR forecast_max_air_temp_f > 90 -- Very hot days

OR forecast_total_precip_in > 0.2 -- Heavy precipitation

ORDER BY forecast_date, postal_code;

https://media.licdn.com/dms/image/v2/D4E12AQHmHkWGqF7Hmg/article-inline_image-shrink_1500_2232/B4EZfdR99EHsAU-/0/1751764165231?e=1757548800&v=beta&t=deyx5Nx5tzTC3FO8eFlKFKov_PmbHkevVkZnjD5h2SU
**Extreme weather conditions by postal code**

2. Count how many days with such extreme weather per postal code in the forecast period:
SELECT postal_code, COUNT(*) AS extreme_weather_days

FROM RAW_mart.fact_weather_observations

WHERE forecast_min_air_temp_f < 32

OR forecast_max_air_temp_f > 90

OR forecast_total_precip_in > 0.2

GROUP BY postal_code

ORDER BY extreme_weather_days DESC;

https://media.licdn.com/dms/image/v2/D4E12AQHRVFm-6Xd1lQ/article-inline_image-shrink_1500_2232/B4EZfdR1D7HwAU-/0/1751764128667?e=1757548800&v=beta&t=nKXgivRFIdpNiUQOjxF0Od92SYq6C37YwQarNacRqN4

How this can help retailers (business use case from fact table only):
Locations with frequent freezing days or heavy rain might see lower footfall; retailers can reduce staffing or inventory for perishable goods accordingly.
Locations with many hot days might increase demand for cold drinks, fans, or summer apparel; retailers can stock accordingly and plan staffing.
Weather thresholds you set (like above) can help proactively plan inventory and staffing levels just by using forecast data.
