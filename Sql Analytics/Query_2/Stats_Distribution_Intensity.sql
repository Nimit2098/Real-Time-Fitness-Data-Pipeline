SELECT id,
       date,
       intensity,
       count(time) as Total_minutes,
       SUM(steps) as Total_steps,
       round(SUM(calories),2) as Total_calories,
       round(AVG(heartrate),2) as AVG_heartrate
from "fitness-data-kafka-database"."fitness_data_kafka_storage"
where intensity in (1,2,3)
group by id,date,intensity
order by id,date,intensity