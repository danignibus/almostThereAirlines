-- Dani Gnibus
-- Professor Palmer
-- May 11, 2013
-- CS61 
-- schema.sql HW6
-- Dani Gnibus
-- This file creates the Almost There Airlines database and 
-- all its tables, constraints, keys, functions, procedures, 
-- and triggers. 

USE danignibus_db;

DROP TABLE IF EXISTS RESERVATION;
DROP TABLE IF EXISTS FLIGHT;
DROP TABLE IF EXISTS ROUTE;
DROP TABLE IF EXISTS FLIGHT_STATUS;
DROP TABLE IF EXISTS PLANE;
DROP TABLE IF EXISTS CITY;
DROP TABLE IF EXISTS PERSON;

CREATE TABLE 	PERSON 
  ( person_id   	INT NOT NULL AUTO_INCREMENT,
    cust_fname   	VARCHAR(45) NOT NULL,
    cust_lname   	VARCHAR(45) NOT NULL,
    is_employee		BOOL,
    person_password		VARCHAR(45),
    
    PRIMARY KEY (person_id)
  );

CREATE TABLE 	CITY
  ( city_id			INT NOT NULL AUTO_INCREMENT,
	city_name		VARCHAR(45) NOT NULL,

	PRIMARY KEY (city_id)
  );

CREATE TABLE PLANE
  ( plane_id			INT NOT NULL AUTO_INCREMENT,
	plane_size			INT NOT NULL,

	PRIMARY KEY (plane_id)
  );

CREATE TABLE 	FLIGHT_STATUS
  ( status_id			INT NOT NULL AUTO_INCREMENT,
	flight_status		VARCHAR(20) NOT NULL,

	PRIMARY KEY (status_id)
  );

CREATE TABLE 	ROUTE
  ( route_id			INT NOT NULL AUTO_INCREMENT,
	CITY_start_city		INT NOT NULL,
    CITY_end_city		INT NOT NULL,

	PRIMARY KEY (route_id),
	FOREIGN KEY (CITY_start_city) REFERENCES CITY(city_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (CITY_end_city) REFERENCES CITY(city_id) ON DELETE CASCADE ON UPDATE CASCADE
  );

CREATE TABLE 	FLIGHT
  ( flight_id			INT NOT NULL AUTO_INCREMENT,
	STATUS_status_id	INT NOT NULL,
    ROUTE_route_id		INT NOT NULL,
    PLANE_plane_id		INT NOT NULL,
	departure			DATETIME NOT NULL,
    arrival				DATETIME NOT NULL,
    seats_taken			INT NOT NULL,
    
	PRIMARY KEY (flight_id),
    FOREIGN KEY (STATUS_status_id) REFERENCES FLIGHT_STATUS(status_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (ROUTE_route_id) REFERENCES ROUTE(route_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (PLANE_plane_id) REFERENCES PLANE(plane_id) ON DELETE CASCADE ON UPDATE CASCADE
  );
  
CREATE TABLE 	RESERVATION
  ( res_id	   			INT NOT NULL AUTO_INCREMENT,
    PERSON_person_id	INT NOT NULL,
    FLIGHT_flight_id	INT NOT NULL,
    
    PRIMARY KEY (res_id),
    FOREIGN KEY (PERSON_person_id) REFERENCES PERSON(person_id) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (FLIGHT_flight_id) REFERENCES FLIGHT(flight_id) ON DELETE CASCADE ON UPDATE CASCADE
  );

-- This procedure will be called when a customer attempts to make a reservation for 
-- a specific flight. It checks to see if that flight still has available seats, and if it 
-- does creates the reservation based on the input values.
-- Returns: 1 upon successful insertion and 0 upon failed insertion (full flight).
DROP PROCEDURE IF EXISTS MakeReservation;
DELIMITER //
CREATE PROCEDURE MakeReservation(
	IN res_id_input INTEGER,
    IN person_id_input INTEGER,
    IN flight_id_input INTEGER, 
    OUT insert_status INTEGER)
	
    BEGIN
		DECLARE new_person_id INTEGER;
		DECLARE current_plane_size INTEGER;
		DECLARE capacity INTEGER;
		SELECT plane_size FROM PLANE JOIN FLIGHT 
			ON FLIGHT.PLANE_plane_id = PLANE.plane_id 
            WHERE FLIGHT.flight_id = flight_id_input
            INTO capacity;
        SELECT seats_taken FROM FLIGHT
			WHERE flight_id_input = FLIGHT.flight_id
            INTO current_plane_size;
		IF (current_plane_size < capacity) THEN
			INSERT INTO RESERVATION VALUES(res_id_input, person_id_input, flight_id_input);
            UPDATE FLIGHT 
            SET FLIGHT.seats_taken = FLIGHT.seats_taken + 1 WHERE flight_id_input = FLIGHT.flight_id;
            SET insert_status = 1;
		ELSE 
			SET insert_status = 0;
		END IF;
	
    END
    //
DELIMITER ;

-- This function identifies whether a user is an employee or a customer, in order to 
-- give them certain permissions from the front end. Will be used to delegate certain permissions from the front end. 
-- Returns: 1 if customer and 0 if employee. 
DROP PROCEDURE IF EXISTS Permissions;
DELIMITER //
CREATE PROCEDURE Permissions(
	IN input_person_id INTEGER,
    OUT permissions INTEGER )
	
    BEGIN
		SELECT is_employee FROM PERSON
		WHERE PERSON.person_id = input_person_id
		INTO permissions;
    END
    //
DELIMITER ;

-- This procedure will allow a customer to cancel a flight, freeing up
-- the seat and deleting that reservation for the customer.
DROP PROCEDURE IF EXISTS DeleteReservation;
DELIMITER //
CREATE PROCEDURE DeleteReservation(
	IN res_id_input INTEGER)
	
    BEGIN
		DECLARE flight_id INTEGER;
        SELECT FLIGHT_flight_id FROM RESERVATION WHERE RESERVATION.res_id = res_id_input
        INTO flight_id;
		UPDATE FLIGHT 
		SET FLIGHT.seats_taken = FLIGHT.seats_taken - 1 WHERE FLIGHT.flight_id = flight_id;
        DELETE FROM RESERVATION WHERE RESERVATION.res_id = res_id_input;
    END
    //
DELIMITER ;


-- This stored procedure displays for a specific customer all their
-- past and upcoming reservations. 
DROP PROCEDURE IF EXISTS PastAndUpcoming;
DELIMITER //
CREATE PROCEDURE PastAndUpcoming(
	IN input_user_id INTEGER)
	
    BEGIN
		SELECT FLIGHT_flight_id AS flight_id, departure, arrival, STATUS_status_id AS flight_status, GetCity(CITY_start_city) AS start_city, GetCity(CITY_end_city) AS end_city 
        FROM RESERVATION JOIN FLIGHT 
		ON RESERVATION.FLIGHT_flight_id = FLIGHT.flight_id
        JOIN ROUTE
        ON FLIGHT.ROUTE_route_id = ROUTE.route_id
		WHERE RESERVATION.PERSON_person_id = input_user_id;
    
    END //
DELIMITER ;

-- This stored procedure displays for a specific customer all their
-- past and upcoming reservations. 
DROP PROCEDURE IF EXISTS PastFlightReservations;
DELIMITER //
CREATE PROCEDURE PastFlightReservations(
	IN input_user_id INTEGER)
    BEGIN
		SET @currentDate = NOW();
		SELECT res_id, FLIGHT_flight_id AS flight_id, departure, arrival, STATUS_status_id AS flight_status, GetCity(CITY_start_city) AS start_city, GetCity(CITY_end_city) AS end_city
        FROM RESERVATION JOIN FLIGHT 
		ON RESERVATION.FLIGHT_flight_id = FLIGHT.flight_id
        JOIN ROUTE
        ON FLIGHT.ROUTE_route_id = ROUTE.route_id
		WHERE RESERVATION.PERSON_person_id = input_user_id
        AND FLIGHT.departure < @currentDate;
    
    END //
DELIMITER ;

-- This stored procedure displays for a specific customer all their
-- past and upcoming reservations. 
DROP PROCEDURE IF EXISTS UpcomingFlightReservations;
DELIMITER //
CREATE PROCEDURE UpcomingFlightReservations(
	IN input_user_id INTEGER)
    BEGIN
		SET @currentDate = NOW();
		SELECT res_id, FLIGHT_flight_id AS flight_id, departure, arrival, STATUS_status_id AS flight_status, GetCity(CITY_start_city) AS start_city, GetCity(CITY_end_city) AS end_city
        FROM RESERVATION JOIN FLIGHT 
		ON RESERVATION.FLIGHT_flight_id = FLIGHT.flight_id
        JOIN ROUTE
        ON FLIGHT.ROUTE_route_id = ROUTE.route_id
		WHERE RESERVATION.PERSON_person_id = input_user_id
        AND FLIGHT.departure > @currentDate;
    
    END //
DELIMITER ;

-- This stored procedure displays the passenger list of a flight to 
-- an employee. 
DROP PROCEDURE IF EXISTS PassengerList;
DELIMITER //
CREATE PROCEDURE PassengerList(
	IN input_flight_id INTEGER)
    BEGIN
		SELECT PERSON_person_id AS passenger_id, cust_fname, cust_lname FROM RESERVATION
		JOIN FLIGHT 
		ON RESERVATION.FLIGHT_flight_id = FLIGHT.flight_id JOIN PERSON
        ON RESERVATION.PERSON_person_id = PERSON.person_id
		WHERE RESERVATION.FLIGHT_flight_id = input_flight_id;
    
    END //
DELIMITER ;

-- This stored procedure will select the five flights with the most number of passengers 
-- specified between two dates.
DROP PROCEDURE IF EXISTS GetPopularFlights;
DELIMITER //
CREATE PROCEDURE GetPopularFlights(
	IN date_1 DATETIME,
    IN date_2 DATETIME)
    BEGIN
		SELECT flight_id, seats_taken, GetCity(CITY_start_city) AS start_city, GetCity(CITY_end_city) AS end_city, departure, arrival 
        FROM FLIGHT JOIN ROUTE
        ON FLIGHT.ROUTE_route_id = ROUTE.route_id
		WHERE FLIGHT.departure > date_1 AND FLIGHT.departure < date_2 
        ORDER BY seats_taken DESC LIMIT 5;
    
    END //
DELIMITER ;


-- Helper Function GetPersonId to get the person id of an input person.
DROP FUNCTION IF EXISTS GetPersonId;
DELIMITER //
CREATE FUNCTION GetPersonId(first_name VARCHAR(45), last_name VARCHAR(45)) RETURNS INTEGER
    DETERMINISTIC
	BEGIN
		DECLARE new_person_id INTEGER;
		SELECT person_id FROM PERSON
			WHERE cust_fname = first_name AND cust_lname = last_name
			INTO new_person_id;	
 
	RETURN (new_person_id);
END //
DELIMITER ;

-- Function that will return expected password, for matching upon login.
DROP FUNCTION IF EXISTS GetPassword;
DELIMITER //
CREATE FUNCTION GetPassword(input_user_id INTEGER) RETURNS VARCHAR(45)
    DETERMINISTIC
	BEGIN
		DECLARE user_password VARCHAR(45);
		SELECT person_password FROM PERSON
			WHERE input_user_id = PERSON.person_id
			INTO user_password;	
 
	RETURN (user_password);
END //
DELIMITER ;

-- Helper function to get city names easily for an input city ID.
DROP FUNCTION IF EXISTS GetCity;
DELIMITER //
CREATE FUNCTION GetCity(input_city_id INTEGER) RETURNS VARCHAR(45)
    DETERMINISTIC
	BEGIN
		DECLARE output_city_name VARCHAR(45);
		SELECT city_name FROM CITY
			WHERE input_city_id = CITY.city_id
			INTO output_city_name;	
 
	RETURN (output_city_name);
END //
DELIMITER ;

-- View that will display upcoming available flights to customers.
DROP VIEW IF EXISTS UPCOMINGFLIGHTS;
CREATE VIEW UPCOMINGFLIGHTS AS
	SELECT flight_id, departure, arrival, GetCity(CITY_start_city) AS start_city, GetCity(CITY_end_city) AS end_city
    FROM FLIGHT JOIN ROUTE
    ON FLIGHT.ROUTE_route_id = ROUTE.route_id
	WHERE departure > NOW() AND FlightIsAvailable(flight_id)
    ORDER BY departure;
    

-- Helper Function FlightAvailability that returns whether or not a flight is full.
DROP FUNCTION IF EXISTS FlightIsAvailable;
DELIMITER //
CREATE FUNCTION FlightIsAvailable(input_flight_id INTEGER) RETURNS INTEGER
    NOT DETERMINISTIC
	BEGIN
        DECLARE current_plane_size INTEGER;
        DECLARE capacity INTEGER;
		SELECT plane_size FROM PLANE JOIN FLIGHT 
			ON FLIGHT.PLANE_plane_id = PLANE.plane_id 
            WHERE FLIGHT.flight_id = input_flight_id
            INTO capacity;
        SELECT seats_taken FROM FLIGHT
			WHERE input_flight_id = FLIGHT.flight_id
            INTO current_plane_size;
		IF (current_plane_size < capacity) THEN
			RETURN 1;
		ELSE RETURN 0;
		END IF;
END //
DELIMITER ;
    