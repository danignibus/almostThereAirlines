-- test.sql HW6 
-- Dani Gnibus
-- Professor Palmer, CS61

-- Description: A database test file that contains a variety of test queries that demonstrate the
-- proper operation of keys, constraints, procedures, functions, triggers, views, etc. 
-- IMPORTANT NOTE: It is assumed that the user has already run data.sql, as this file will 
-- populate the database with much of the information needed to run the following tests. It is 
-- also assumed that the user will run the tests in sequential order, as some later tests depend
-- on the results and data created by earlier ones. 

USE danignibus_db;

-- Test of constraints: All values have been specified to be NOT NULL, but in addition primary keys
-- have been specified to auto-increment, and therefore when this value is specified as NULL it will 
-- be given the next value in the table. However, the following tests should all fail for every 
-- other attribute, as all columns have been specified to be NOT NULL as a constraint. 
INSERT INTO PLANE VALUES(NULL, NULL);
INSERT INTO PERSON VALUES(NULL, NULL, NULL, NULL, NULL);
INSERT INTO CITY VALUES(NULL, NULL);
INSERT INTO FLIGHT_STATUS VALUES(NULL, NULL);
INSERT INTO ROUTE VALUES(NULL, NULL, NULL);
INSERT INTO FLIGHT VALUES(NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO RESERVATION VALUES(NULL, NULL, NULL);
SELECT * FROM PERSON;
-- Tests of primary keys. These tests verify that you can't enter duplicate values for PK's. 
-- Expected output: Tests should all fail.
INSERT INTO PLANE VALUES(1, 20);
INSERT INTO PERSON VALUES(1, 'CYNTHIA', 'HARRISON', 0, '2342sd');
INSERT INTO CITY VALUES(1, 'San Diegoo');
INSERT INTO FLIGHT_STATUS VALUES(1, 'invaded');
INSERT INTO ROUTE VALUES(1, 2, 3);
INSERT INTO FLIGHT VALUES(1, 2, 3, 4, '2015-04-05 09:00:00','2015-04-05 22:00:00', 0);
INSERT INTO RESERVATION VALUES(1, 2, 3);

-- Test of foreign keys: These tests try to insert values into tables that require foreign keys
-- to other tables, where such foreign keys haven't yet been created. Expected output: all 
-- tests should fail, since the foreign key constraint fails.
INSERT INTO ROUTE VALUES(NULL, 100, 30); #testing CITY_start_city FK
INSERT INTO ROUTE VALUES(NULL, 30, 100); #testing CITY_end_city FK
INSERT INTO FLIGHT VALUES(NULL, 10, 10, 1, '2015-04-05 09:00:00','2015-04-05 22:00:00', 0); #testing STATUS_status_id FK
INSERT INTO FLIGHT VALUES(NULL, 2, 59, 1, '2015-04-05 09:00:00','2015-04-05 22:00:00', 0); #testing ROUTE_route_id FK
INSERT INTO FLIGHT VALUES(NULL, 2, 10, 4, '2015-04-05 09:00:00','2015-04-05 22:00:00', 0); #testing PLANE_plane_id RK
INSERT INTO RESERVATION VALUES(NULL, 900, 2); #testing PERSON_person_id FK
INSERT INTO RESERVATION VALUES(NULL, 143, 99); #testing FLIGHT_flight_id FK

-- Test of Permissions procedure, which returns as output a 0 for customers and 1 for employees.
-- Will be used to delegate certain permissions from the front end. 
-- Expected output: Patricia Johnson is an employee; @employee_example should return the value 1.
-- Susan Wilson is a customer; @customer_example should return the value 0. 
CALL Permissions(2, @employee_example);
SELECT @employee_example;
CALL Permissions(8, @customer_example);
SELECT @customer_example;

SELECT * FROM PERSON;
-- Test of PastAndUpcoming procedure, which will get a reservation history of a database user. 
-- Should output flight_id, departure, arrival, status, start and end cities. 
CALL PastAndUpcoming(18);

-- Test of PastFlightReservations procedure, which will get all past reservations of the user with
-- input user id (in this case, user 18). She should have 3 past flight reservations, all of which were created in the
-- data file. Should output flight_id, departure, arrival, status, start and end cities. 
CALL PastFlightReservations(6);

-- Test of UpcomingFlightReservations procedure, which will get all future reservations of the user with
-- input user id (in this case, user 18). She should have 3 future flight reservations (assuming this is graded
-- before May 23), all of which were created in the data file. 
-- Should output flight_id, departure, arrival, status, start and end cities. 
CALL UpcomingFlightReservations(18);

-- Test of helper function GetPersonId, which takes in a first name and last name and 
-- returns their ID (unless they don't exist, in which case returns NULL)
SELECT GetPersonId('PATRICIA', 'JOHNSON');

-- Test of procedure MakeReservation. Makes 11 calls to this procedure when the seat capacity 
-- of flight 42 is 10, and therefore only passengers 1 through 10 acquire seats on the flight,
-- as demonstrated through the selection included. Additionally, @statusSUCCESS should have the 
-- value 1 and @statusFAIL (representing the 11th insertion) should have the value 0, since 
-- the procedure returns 1 upon success and 0 upon failure.
CALL MakeReservation(NULL,1,42, @status);
CALL MakeReservation(NULL,2,42,@status);
CALL MakeReservation(NULL,3,42, @status);
CALL MakeReservation(NULL,4,42, @status);
CALL MakeReservation(NULL,5,42, @status);
CALL MakeReservation(NULL,6,42, @status);
CALL MakeReservation(NULL,7,42, @status);
CALL MakeReservation(NULL,8,42, @status);
CALL MakeReservation(NULL,9,42, @status);
CALL MakeReservation(NULL,10,42, @statusSUCCESS);
CALL MakeReservation(NULL,11,42, @statusFAIL);

SELECT * FROM FLIGHT WHERE flight_id = 35;

SELECT res_id,flight_id,seats_taken, PERSON_person_id AS person_id FROM RESERVATION 
JOIN FLIGHT ON RESERVATION.FLIGHT_flight_id = FLIGHT.flight_id
JOIN PLANE ON FLIGHT.PLANE_plane_id = PLANE.plane_id 
WHERE FLIGHT.flight_id = 42; #this select statement exemplifies that only 10/11 reservations were made

SELECT @statusSUCCESS; #should be a 1, representing customer 10's reservation
SELECT @statusFAIL; #should be a 0, representing customer 11's failed insertion

-- Test for Helper Function FlightIsAvailable. Expected output: 0, since this flight is booked.
SELECT FlightIsAvailable(42);

-- Test for UPCOMINGFLIGHTS view. Expected output:Should list all flights with a departure date
-- occurring in the future. Flight 42 will not be included, as this flight has no available seating
-- and therefore is not a valid flight for selection by a customer.
SELECT * FROM UPCOMINGFLIGHTS;

-- Test for DeleteReservation. Creates and displays three new reservations for flight 
-- ID 39, then deletes one of these and redisplays. Expected output: reservation 39 disappears from 
-- the SELECT, and the number of seats decrease. Note: if you've run the MakeReservation command
-- more than specified in previous data and test files, the ID number of the reservation you call
-- may have to change.
SELECT * FROM PERSON;

CALL MakeReservation(NULL,15,39, @status);
CALL MakeReservation(NULL,16,39, @status);
CALL MakeReservation(NULL,17,39, @status);

SELECT res_id,flight_id,seats_taken FROM RESERVATION 
JOIN FLIGHT ON RESERVATION.FLIGHT_flight_id = FLIGHT.flight_id
JOIN PLANE ON FLIGHT.PLANE_plane_id = PLANE.plane_id 
WHERE FLIGHT.flight_id = 39; #shows the three reservations that have been created, and that seats available = 3

Call DeleteReservation(18); 

SELECT res_id,flight_id,seats_taken FROM RESERVATION 
JOIN FLIGHT ON RESERVATION.FLIGHT_flight_id = FLIGHT.flight_id
JOIN PLANE ON FLIGHT.PLANE_plane_id = PLANE.plane_id 
WHERE FLIGHT.flight_id = 39; #shows that now only two reservations appear, and seats available has decreased

-- Test for PassengerList. Creates three reservations for flight 37, after which the call to 
-- PassengerList should return all three passenger id's (20, 21, 22) along with their first and last names. 
CALL MakeReservation(NULL,20,37, @status);
CALL MakeReservation(NULL,21,37, @status);
CALL MakeReservation(NULL,22,37, @status);
CALL PassengerList(35); #shows the three passengers available in the passenger list

-- Test for GetPassword function. Takes user id for user 1 as input. 
-- Expected output: abc123
SELECT GetPassword(1);

SELECT PERSON_person_id FROM RESERVATION WHERE res_id = 34;

-- Test for GetCity function. Takes city_id 3 as input. Expected output: San Jose.
SELECT GetCity(3);

-- Test for getting list of most popular flights. If data.sql and test.sql have each been run 
-- only once (and if graded before May 18), the list should be flight 42, 37, 39, 49, 1. 
-- Otherwise, list should be in order of most popular to least, within the given date range.
CALL GetPopularFlights('2015-05-08 10:00:00', '2015-06-25 08:00:00');

-- Testing FK's cascade restraint for route. Prior to deletion these should exist according to comments, and 
-- after deletion they should be null.
SELECT * FROM ROUTE WHERE CITY_start_city = 20; #should be route 49
SELECT * FROM ROUTE WHERE CITY_end_city = 20; #should be route 50
DELETE FROM CITY WHERE city_id = 20;
SELECT * FROM ROUTE WHERE CITY_start_city = 20; #should be null
SELECT * FROM ROUTE WHERE CITY_end_city = 20; #should be null

-- Testing FK's cascade restraint for flight. Prior to deletion these should exist according to comments, and 
-- after deletion they should be null.
SELECT * FROM FLIGHT WHERE STATUS_status_id = 4; #should be flight 67
SELECT * FROM FLIGHT WHERE ROUTE_route_id = 38; #should be 53 and 55
SELECT * FROM FLIGHT WHERE PLANE_plane_id = 2; #should be 43-46
DELETE FROM FLIGHT_STATUS WHERE status_id = 4;
DELETE FROM ROUTE WHERE route_id = 38;
DELETE FROM PLANE WHERE plane_id = 2;
SELECT * FROM FLIGHT WHERE STATUS_status_id = 4; #should be null
SELECT * FROM FLIGHT WHERE ROUTE_route_id = 38; #should be null
SELECT * FROM FLIGHT WHERE PLANE_plane_id = 2; #should be null

CALL MakeReservation(NULL,15,37, @status);
CALL MakeReservation(NULL,19,39, @status);
-- Testing FK's cascade restraint for reservation. Prior to deletion these should exist according to comments, and 
-- after deletion they should be null.
SELECT * FROM RESERVATION WHERE PERSON_person_id = 15; #should be flight 37
SELECT * FROM RESERVATION WHERE FLIGHT_flight_id = 39; #should be person 19
DELETE FROM PERSON WHERE person_id = 15;
DELETE FROM FLIGHT WHERE flight_id = 39;
SELECT * FROM RESERVATION WHERE PERSON_person_id = 15; #should be null
SELECT * FROM RESERVATION WHERE FLIGHT_flight_id = 39; #should be null