# Real-Time Fitness Data Pipeline

## Introduction:

The project focuses on creating a streamlined data pipeline using Amazon Web Services (AWS) for collecting data from fitness devices, managing the storage of this data, and conducting meaningful analyses using AWS Athena to discover valuable insights into users' health and fitness trends.

## Architecture:
<img src="Architecture\Fitness Real-time Data Pipeline.jpeg">

In this architecture, fitness device data is generated through a Python script and sent to Kafka by a frontend acting as a producer. Kafka, hosted on an EC2 instance, facilitates real-time data streaming to a consumer that stores the data in an S3 bucket in JSON format. An AWS Glue crawler is then employed to create a data catalog, establishing a structured schema in the database. Athena is subsequently utilized to run SQL queries directly on the S3-stored data, enabling efficient and cost-effective analytics without the need to move or preprocess the data. This end-to-end pipeline ensures seamless data flow, from simulation to storage and analytics, providing valuable insights into fitness metrics.

Check out the "Pipeline Snapshots" folder to see photos of all the components of the architecture.

## Data schema:
The data schema employed for fitness device information comprises ten key fields. These include the unique identifier ('id') for individual users, the date and time of recorded activities, metrics such as calories burned, exercise intensity, and metabolic equivalents (METs). The schema also incorporates data on the number of steps taken, sleep patterns denoted by a 'sleep_value,' a log identifier ('logid'), and the recorded heart rate. This structured schema provides a comprehensive representation of diverse fitness metrics, facilitating efficient organization and analysis of the data for insights into users' physical activities and health patterns.

## SQL Query Analytics Outcome:

#### 0th Query (Table Preview):

```
SELECT * 
FROM "fitness-data-kafka-database"."fitness_data_kafka_storage" limit 10;
```

<img src="Sql Analytics\Query_0\Output.jpg">

#### Explaination:

The result provides a preview of the database table structure created using the Glue crawler on the S3 data. Displaying all columns and 10 rows, this query offers a comprehensive overview of the fitness device data, setting the stage for subsequent analyses.

#### 1st Query (Average Sedentary Minutes):

```
WITH Intensity_per_minute AS (
    Select id,
           date,
           count(time) as Total_Sedentary_minutes,
           round(avg(heartrate),2) as Avg_heartrate
    FROM "fitness-data-kafka-database"."fitness_data_kafka_storage"
    WHERE id = 1503960366 AND intensity = 0 AND sleep_value = 0.0
    GROUP BY id,date
    ORDER BY id,date ASC)
SELECT id,
       count(date) as number_days,
       round(Avg(Total_Sedentary_minutes),2) as Avg_Sedentary_minutes_day,
       round(Avg(Avg_heartrate),2) as Avg_heartrate_minute_day
FROM Intensity_per_minute
GROUP BY id
```

<img src="Sql Analytics\Query_1\Output_cropped.jpg">

#### Explaination:

This query outputs the average sedentary minutes per day for a specific user ID, indicating the number of days for which the average is computed. Additionally, it reveals the average heart rate during sedentary periods. This information provides insights into users' inactive time and associated heart rate patterns.

#### 2nd Query (Intensity Distribution):

```
SELECT id,
       date,
       intensity,
       count(time) as Total_minutes,
       SUM(steps) as Total_steps,
       round(SUM(calories),2) as Total_calories,
       round(AVG(heartrate),2) as AVG_heartrate
FROM "fitness-data-kafka-database"."fitness_data_kafka_storage"
WHERE intensity in (1,2,3)
GROUP BY id,date,intensity
ORDER BY id,date,intensity
```

<img src="Sql Analytics\Query_2\Output.jpg">

#### Explaination:

Grouping the data by intensity (Light, Moderate, Very Active), this query delves into the statistical distribution of metrics for each intensity level. Notably, it highlights variations in heart rate, calorie burn, and steps across different intensities, offering a nuanced understanding of users' daily activity patterns.

#### 3rd Query (Sleep Analysis):

```
SELECT id,
       date,
       sleep_value,
       count(time) as Avg_minutes,
       round(AVG(heartrate),2) as Avg_heartrate
FROM "fitness-data-kafka-database"."fitness_data_kafka_storage"
WHERE sleep_value != 0.0
GROUP BY id,date,sleep_value
ORDER BY id,date,sleep_value
```

<img src="Sql Analytics\Query_3\Output.jpg">

#### Explaination:

The third query categorizes data by sleep_value (Not in bed, Asleep, Restless, Awake), allowing for a detailed study of sleep time in minutes and associated heart rates. The analysis reinforces the importance of maximizing time spent in sleep_value 1 (asleep) while minimizing durations in sleep_values 2 and 3 (restless and awake). Notably, the heart rate remains relatively consistent across all three sleep values.

#### Conclusion:

The implementation of a real-time data pipeline for fitness data, encompassing data simulation, Kafka streaming, S3 storage, Glue cataloging, and Athena analytics, demonstrates a robust solution for managing and gaining insights from fitness device data. The SQL queries provide valuable analytics, revealing patterns in sedentary behavior, activity intensity, and sleep quality. This project offers a scalable and efficient approach to deriving meaningful insights, contributing to informed decision-making for individuals and healthcare professionals in optimizing health and fitness outcomes.