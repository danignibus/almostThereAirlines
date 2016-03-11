-- data.sql HW6
-- Dani Gnibus
-- Professor Palmer
-- May 11, 2013
-- CS61 
-- 
-- This file loads data into the Almost There Airlines database 

USE danignibus_db;

-- Load data from customer file. Customer IDs, first names, and last names were taken from the 
-- Sakila database. Around 20 customers were specified to be employees as well, using the is_employee boolean. 
-- All customers have identical passwords.
LOAD DATA LOCAL INFILE '~/Documents/CS61/customers.csv' INTO TABLE PERSON FIELDS terminated by ',';

-- Load data from cities file to populate cities table. 
LOAD DATA LOCAL INFILE '~/Documents/CS61/cities.csv' INTO TABLE CITY FIELDS terminated by ',';

-- There are two types of planes; one that seats 10 passengers and one that seats 15.
INSERT INTO PLANE VALUES(1, 10);
INSERT INTO PLANE VALUES(2, 15);


-- Flight status can either be on time, delayed, canceled, departed, arrived, or unknown, as specified
-- by Piazza.
LOAD DATA LOCAL INFILE '~/Documents/CS61/flight_status.csv' INTO TABLE FLIGHT_STATUS FIELDS terminated by ',';

-- There are fifty routes. Each route goes from one city in the CITY table to another. No routes
-- go from one city to the same city. 
LOAD DATA LOCAL INFILE '~/Documents/CS61/routes.csv' INTO TABLE ROUTE FIELDS terminated by ',';

-- There are 75 flights. Several flights occur between pairs of cities on the same day; others are more
-- spread out. 
LOAD DATA LOCAL INFILE '~/Documents/CS61/flights2.csv' INTO TABLE FLIGHT FIELDS terminated by ',';


-- Add some reservations to database.
CALL MakeReservation(NULL,18,1, @status);
CALL MakeReservation(NULL,18,3,@status);
CALL MakeReservation(NULL,18,4, @status);
CALL MakeReservation(NULL,18,49, @status);
CALL MakeReservation(NULL,18,50,@status);
CALL MakeReservation(NULL,18,51, @status);
