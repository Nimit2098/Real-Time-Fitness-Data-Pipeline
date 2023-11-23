WITH Intensity_per_minute AS (
    Select id,
           date,
           count(time) as Total_Sedentary_minutes,
           round(avg(heartrate),2) as Avg_heartrate
    From "fitness-data-kafka-database"."fitness_data_kafka_storage"
    WHERE id = 1503960366 AND intensity = 0 AND sleep_value = 0.0
    GROUP BY id,date
    order BY id,date ASC)
Select id,
       count(date) as number_days,
       round(Avg(Total_Sedentary_minutes),2) as Avg_Sedentary_minutes_day,
       round(Avg(Avg_heartrate),2) as Avg_heartrate_minute_day
FROM Intensity_per_minute
GROUP BY id