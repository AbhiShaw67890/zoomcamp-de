-- Create table
CREATE TABLE trips (
    VendorID INT,
    lpep_pickup_datetime TIMESTAMP,
    lpep_dropoff_datetime TIMESTAMP,
    store_and_fwd_flag CHAR(1),
    RatecodeID INT,
    PULocationID INT,
    DOLocationID INT,
    passenger_count INT,
    trip_distance FLOAT,
    fare_amount FLOAT,
    extra FLOAT,
    mta_tax FLOAT,
    tip_amount FLOAT,
    tolls_amount FLOAT,
    ehail_fee FLOAT,
    improvement_surcharge FLOAT,
    total_amount FLOAT,
    payment_type INT,
    trip_type INT,
    congestion_surcharge FLOAT
);

CREATE TABLE taxi_zone_lookup (
    LocationID INT,
    Borough VARCHAR(50),
    Zone VARCHAR(255),
    service_zone VARCHAR(50)
);


-- sloution of qustion 3
SELECT COUNT(*) 
FROM trips 
WHERE lpep_pickup_datetime >= '2019-09-18 00:00:00' 
  AND lpep_dropoff_datetime < '2019-09-19 00:00:00';


-- solution of question 4
SELECT 
    DATE(lpep_pickup_datetime) AS pickup_day,
    SUM(trip_distance) AS total_distance
FROM 
    trips
GROUP BY 
    DATE(lpep_pickup_datetime)
ORDER BY 
    total_distance DESC
LIMIT 1;



-- solution of question 5
SELECT 
    l.Borough, 
    SUM(t.total_amount) AS total_amount_sum
FROM 
    trips t
JOIN 
    location_data l ON t.PULocationID = l.LocationID
WHERE 
    DATE(t.lpep_pickup_datetime) = '2019-09-18'
    AND l.Borough <> 'Unknown'
GROUP BY 
    l.Borough
HAVING 
    SUM(t.total_amount) > 50000
ORDER BY 
    total_amount_sum DESC
LIMIT 3;



-- solution of question 6
SELECT 
    tzl_dropoff.Zone AS drop_off_zone, 
    MAX(t.tip_amount) AS largest_tip
FROM 
    trips t
JOIN 
    location_data tzl_pickup ON t.PULocationID = tzl_pickup.LocationID
JOIN 
    location_data tzl_dropoff ON t.DOLocationID = tzl_dropoff.LocationID
WHERE 
    tzl_pickup.Zone = 'Astoria'
    AND DATE(t.lpep_pickup_datetime) >= '2019-09-01'
    AND DATE(t.lpep_pickup_datetime) < '2019-10-01'
GROUP BY 
    tzl_dropoff.Zone
ORDER BY 
    largest_tip DESC
LIMIT 1;
