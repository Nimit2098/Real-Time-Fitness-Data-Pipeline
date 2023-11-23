select id,
       date,
       sleep_value,
       count(time) as Avg_minutes,
       round(AVG(heartrate),2) as Avg_heartrate
from "fitness-data-kafka-database"."fitness_data_kafka_storage"
where sleep_value != 0.0
group by id,date,sleep_value
order by id,date,sleep_value