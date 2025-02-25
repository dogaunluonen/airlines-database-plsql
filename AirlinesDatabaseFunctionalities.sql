--PROCEDURES

-- Updating Flight Status: The status of a flight needs to be updated when it changes, for example, 
-- from 'scheduled' to 'departed' or from 'scheduled' to ‘departed’.
CREATE OR REPLACE PROCEDURE UpdateFlightStatusToDeparted ( p_flight_id IN INT)
AS
BEGIN
   UPDATE Flights
   SET status = 'departed'
   WHERE flight_id = p_flight_id;
END UpdateFlightStatusToDeparted;


CREATE OR REPLACE PROCEDURE UpdateFlightDepartureTime(p_FlightID INT, p_DepartureTime DATE)
AS
BEGIN
  UPDATE Flights
  SET departure_time = p_DepartureTime
  WHERE flight_id = p_FlightID;
   COMMIT;
  DBMS_OUTPUT.PUT_LINE('Departure time updated successfully.');
EXCEPTION
  WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END UpdateFlightDepartureTime;


-- Checking Seat Availability: Before making a reservation, check if the desired seat is available.
CREATE OR REPLACE PROCEDURE CheckSeatAvailability(
   flight_id_param IN INT,
   seat_param IN VARCHAR2,
   isAvailable OUT NUMBER
)
IS
   v_count NUMBER;
BEGIN
   isAvailable := 0;

   SELECT COUNT(*)
   INTO v_count
   FROM Tickets
   WHERE flight_id = flight_id_param
   AND seat = seat_param;
   
   IF v_count = 0 THEN
       isAvailable := 1;
       DBMS_OUTPUT.PUT_LINE('Seat ' || seat_param || ' is available for flight ' || flight_id_param || '.');
   ELSE
       DBMS_OUTPUT.PUT_LINE('Seat ' || seat_param || ' is not available for flight ' || flight_id_param || '.');
   END IF;
END;


-- Generating Sales Reports: Generate detailed sales reports for performance analysis
CREATE OR REPLACE PROCEDURE GenerateSalesReport (p_start_date IN DATE, p_end_date IN DATE)
AS
   CURSOR sales_cursor IS
       SELECT r.flight_id, SUM(f.amount) AS total_sales
       FROM FinancialTransactions f
       JOIN Reservations r ON f.reservation_id = r.reservation_id
       JOIN Flights fl ON r.flight_id = fl.flight_id
       WHERE f.transaction_date BETWEEN p_start_date AND p_end_date
       GROUP BY r.flight_id;
  
   v_flight_id Reservations.flight_id%TYPE;
   v_total_sales FinancialTransactions.amount%TYPE;
BEGIN
   OPEN sales_cursor;
   LOOP
       FETCH sales_cursor INTO v_flight_id, v_total_sales;
       EXIT WHEN sales_cursor%NOTFOUND;


       DBMS_OUTPUT.PUT_LINE('Flight ID: ' || v_flight_id || ', Total Sales: ' || v_total_sales);
   END LOOP;
   CLOSE sales_cursor;
END GenerateSalesReport;


-- Canceling a Reservation: When a passenger cancels a reservation, the corresponding reservation and ticket need to be updated.
CREATE OR REPLACE PROCEDURE CancelReservation( p_reservation_id IN INT)
IS
   v_amount DECIMAL(9, 2);
   v_flight_status VARCHAR2(20);
BEGIN
SELECT f.status
   INTO v_flight_status
   FROM Reservations r
   JOIN Flights f ON r.flight_id = f.flight_id
   WHERE r.reservation_id = p_reservation_id;

   IF v_flight_status = 'departed' THEN
       DBMS_OUTPUT.PUT_LINE('The flight has already departed. Reservation cannot be canceled.');
       RETURN;
   END IF;
   UPDATE Reservations
   SET status = 'canceled'
   WHERE reservation_id = p_reservation_id
   AND status = 'confirmed'; 

   IF SQL%ROWCOUNT = 0 THEN
       DBMS_OUTPUT.PUT_LINE('No confirmed reservation found with ID ' || p_reservation_id);
       RETURN;
   END IF;
   UPDATE Tickets
   SET status = 'canceled'
   WHERE reservation_id = p_reservation_id;

   SELECT 0
   INTO v_amount
   FROM FinancialTransactions
   WHERE reservation_id = p_reservation_id;
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Reservation and ticket canceled successfully. Revenue updated.');
EXCEPTION
   WHEN OTHERS THEN
       ROLLBACK;
       DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END CancelReservation;


-- Upgrading Passenger Class: When a passenger requests an upgrade to a higher class, their reservation and ticket need to be updated accordingly.
CREATE OR REPLACE PROCEDURE UpgradePassengerClass(p_reservation_id IN INT)
IS
   CURSOR c_passengers IS
       SELECT p.passenger_id, p.loyalty_program
       FROM Passengers p
       JOIN Tickets t ON p.passenger_id = t.passenger_id
       WHERE t.reservation_id = p_reservation_id;
  
   v_passenger_id INT;
   v_loyalty_points INT;
   v_avg_ticket_price DECIMAL(8, 2);
    v_reservation_status VARCHAR2(15);
BEGIN
   SELECT status
   INTO v_reservation_status
   FROM Reservations
   WHERE reservation_id = p_reservation_id;

   IF v_reservation_status = 'canceled' THEN
       DBMS_OUTPUT.PUT_LINE('Cannot upgrade class for a canceled reservation.');
       RETURN;
   END IF;
  
   v_avg_ticket_price := CalculateAverageTicketPrice(p_reservation_id);

   FOR r_passenger IN c_passengers LOOP
       IF r_passenger.loyalty_program < v_avg_ticket_price THEN
           DBMS_OUTPUT.PUT_LINE('Passenger ID ' || r_passenger.passenger_id || ' has insufficient loyalty points. Upgrade not possible.');
           RETURN;
       END IF;
   END LOOP;

   UPDATE Tickets
   SET class = 'Business'
   WHERE reservation_id = p_reservation_id;

   FOR r_passenger IN c_passengers LOOP
       UPDATE Passengers
       SET loyalty_program = loyalty_program - v_avg_ticket_price
       WHERE passenger_id = r_passenger.passenger_id;
   END LOOP;
   COMMIT;
   DBMS_OUTPUT.PUT_LINE('Passenger classes upgraded successfully.');
EXCEPTION
   WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE('Reservation not found with ID ' || p_reservation_id);
   WHEN OTHERS THEN
       ROLLBACK;
       DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END UpgradePassengerClass;


-- Get detail for a reservation.
CREATE OR REPLACE PROCEDURE GetReservationDetail (p_reservation_id IN INT) 
IS
   v_flight_id INT;
   v_passenger_id INT;
   v_reservation_date DATE;
   v_travel_date DATE;
   v_status VARCHAR2(20);
   v_flight_origin VARCHAR2(3);
   v_flight_destination VARCHAR2(3);
   v_departure_time DATE;
   v_arrival_time DATE;
   v_passenger_first_name VARCHAR2(100);
   v_passenger_last_name VARCHAR2(100);
BEGIN
   SELECT r.flight_id,
          r.passenger_id,
          r.reservation_date,
          r.travel_date,
          r.status,
          f.origin,
          f.destination,
          f.departure_time,
          f.arrival_time,
          p.first_name,
          p.last_name
   INTO v_flight_id,
        v_passenger_id,
        v_reservation_date,
        v_travel_date,
        v_status,
        v_flight_origin,
        v_flight_destination,
        v_departure_time,
        v_arrival_time,
        v_passenger_first_name,
        v_passenger_last_name
   FROM Reservations r
   JOIN Flights f ON r.flight_id = f.flight_id
   JOIN Passengers p ON r.passenger_id = p.passenger_id
   WHERE r.reservation_id = p_reservation_id;


   DBMS_OUTPUT.PUT_LINE('Flight ID: ' || v_flight_id);
   DBMS_OUTPUT.PUT_LINE('Passenger ID: ' || v_passenger_id);
   DBMS_OUTPUT.PUT_LINE('Reservation Date: ' || v_reservation_date);
   DBMS_OUTPUT.PUT_LINE('Travel Date: ' || v_travel_date);
   DBMS_OUTPUT.PUT_LINE('Status: ' || v_status);
   DBMS_OUTPUT.PUT_LINE('Flight Origin: ' || v_flight_origin);
   DBMS_OUTPUT.PUT_LINE('Flight Destination: ' || v_flight_destination);
   DBMS_OUTPUT.PUT_LINE('Departure Time: ' || v_departure_time);
   DBMS_OUTPUT.PUT_LINE('Arrival Time: ' || v_arrival_time);
   DBMS_OUTPUT.PUT_LINE('Passenger First Name: ' || v_passenger_first_name);
   DBMS_OUTPUT.PUT_LINE('Passenger Last Name: ' || v_passenger_last_name);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE('No data found for reservation ID ' || p_reservation_id);
   WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END GetReservationDetail;


-- Searching flights between two airports.
CREATE OR REPLACE PROCEDURE SearchFlights (
   DepartureAirportCode IN VARCHAR2,
   ArrivalAirportCode IN VARCHAR2
) IS
BEGIN
   FOR flight_record IN (
       SELECT flight_id, aircraft_id, origin, destination, departure_time, arrival_time, status
       FROM Flights
       WHERE origin = DepartureAirportCode
         AND destination = ArrivalAirportCode
       ORDER BY departure_time
   ) LOOP
       DBMS_OUTPUT.PUT_LINE('Flight ID: ' || flight_record.flight_id ||
                            ', Aircraft ID: ' || flight_record.aircraft_id ||
                            ', Origin: ' || flight_record.origin ||
                            ', Destination: ' || flight_record.destination ||
                            ', Departure Time: ' || flight_record.departure_time ||
                            ', Arrival Time: ' || flight_record.arrival_time ||
                            ', Status: ' || flight_record.status);
   END LOOP;
END SearchFlights;


-- Update a reservation to completed status.
CREATE OR REPLACE PROCEDURE CompleteReservation(p_reservation_id IN INT)
IS
   v_flight_id INT;
   v_flight_status VARCHAR2(20);
BEGIN
   SELECT flight_id
   INTO v_flight_id
   FROM Reservations
   WHERE reservation_id = p_reservation_id;

   SELECT status
   INTO v_flight_status
   FROM Flights
   WHERE flight_id = v_flight_id;

   IF v_flight_status = 'departed' THEN
           UPDATE Reservations
       SET status = 'completed'
       WHERE reservation_id = p_reservation_id;
       DBMS_OUTPUT.PUT_LINE('Reservation ID ' || p_reservation_id || ' status updated to completed.');
   ELSE
       DBMS_OUTPUT.PUT_LINE('Reservation ID ' || p_reservation_id || ' cannot be updated. Flight ID ' || v_flight_id || ' status is not departed.');
   END IF;
   COMMIT;

EXCEPTION
   WHEN NO_DATA_FOUND THEN
       DBMS_OUTPUT.PUT_LINE('Reservation ID ' || p_reservation_id || ' not found.');
   WHEN OTHERS THEN
       DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
       ROLLBACK;
END CompleteReservation;


--FUNCTIONS

-- Calculating how many tickets are sold for specific flights.
CREATE OR REPLACE FUNCTION GetTicketCount(p_flight_id IN INT)
RETURN INT
IS
   v_ticket_count INT;
BEGIN
   SELECT COUNT(*)
   INTO v_ticket_count
   FROM Tickets
   WHERE flight_id = p_flight_id;

   RETURN v_ticket_count;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
       RETURN 0;
   WHEN OTHERS THEN
       RETURN -1; 
END GetTicketCount;


-- Checking how many flights are available.
CREATE OR REPLACE FUNCTION CheckFlightAvailability (
   p_flight_id INT
) RETURN NUMBER
IS
   v_total_seats INT;
   v_reserved_seats INT;
BEGIN
   SELECT capacity INTO v_total_seats FROM Aircrafts WHERE aircraft_id IN (SELECT aircraft_id FROM Flights WHERE flight_id = p_flight_id);
   SELECT COUNT(*) INTO v_reserved_seats FROM Reservations WHERE flight_id = p_flight_id AND status = 'confirmed';

   IF v_total_seats > v_reserved_seats THEN
       RETURN 1; 
   ELSE
       RETURN 0; 
   END IF;
END CheckFlightAvailability;

DECLARE
    v_flight_id INT := 1; 
    v_available NUMBER;
BEGIN
    v_available := CheckFlightAvailability(p_flight_id => v_flight_id);
    IF v_available = 1 THEN
        DBMS_OUTPUT.PUT_LINE('There are seats available for flight ' || v_flight_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('There are no seats available for flight  ' || v_flight_id);
    END IF;
END CheckFlightAvailability;


-- Calculating the total number of reservation for a spesific passenger.
CREATE OR REPLACE FUNCTION CalculateTotalReservations(passengerID IN INT) RETURN INT IS
    total_reservations INT;
BEGIN
    SELECT COUNT(*)
    INTO total_reservations
    FROM Reservations
    WHERE passenger_id = passengerID AND status = 'confirmed';
    RETURN total_reservations;
END CalculateTotalReservations;


-- Calculating the average ticket price for a spesific flight.
CREATE OR REPLACE FUNCTION CalculateAverageTicketPrice(flightID IN INT) RETURN DECIMAL IS
    avg_price DECIMAL(8, 2);
BEGIN
    SELECT AVG(price)
    INTO avg_price
    FROM Tickets
    WHERE flight_id = flightID AND status = 'issued';


    IF avg_price IS NULL THEN
        avg_price := 0;
    END IF;

    RETURN avg_price;
END CalculateAverageTicketPrice;


--TRIGGERS

-- Avoiding Overbooking: When a flight is full no more ticket can be sold.
CREATE OR REPLACE TRIGGER CheckFlightCapacity
BEFORE INSERT OR UPDATE ON Tickets
FOR EACH ROW
DECLARE
   v_AircraftCapacity NUMBER;
   v_TicketCount NUMBER;
BEGIN
   SELECT Capacity INTO v_AircraftCapacity
   FROM Aircrafts
   WHERE Aircraft_ID = (
       SELECT aircraft_ID
       FROM Flights
       WHERE FlightID = :NEW.FlightID
   );
   SELECT COUNT(*) INTO v_TicketCount
   FROM Tickets
   WHERE FlightID = :NEW.FlightID;
  
   IF v_TicketCount >= v_AircraftCapacity THEN
       RAISE_APPLICATION_ERROR(-20002, 'Flight capacity exceeded');
   END IF;
END;


-- Assigning loyalty points to passengers.
CREATE OR REPLACE TRIGGER AfterFlightCompletion
AFTER UPDATE OF status ON Reservations
FOR EACH ROW
BEGIN
   IF :NEW.status = 'completed' THEN
       UPDATE Passengers p
       SET p.loyalty_program = p.loyalty_program + (
           SELECT COALESCE(SUM(t.price), 0)
           FROM Tickets t
           WHERE t.reservation_id = :NEW.reservation_id AND t.passenger_id = p.passenger_id
       )
       WHERE p.passenger_id IN (
           SELECT t.passenger_id
           FROM Tickets t
           WHERE t.reservation_id = :NEW.reservation_id
       );
   END IF;
END;


-- Ensuring the email is unique.
CREATE OR REPLACE TRIGGER trg_unique_email
BEFORE INSERT OR UPDATE ON Passengers
FOR EACH ROW
DECLARE
   v_count INT;
BEGIN
   SELECT COUNT(*)
   INTO v_count
   FROM Passengers
   WHERE email = :NEW.email
   AND passenger_id != :NEW.passenger_id;


   IF v_count > 0 THEN
       RAISE_APPLICATION_ERROR(-20002, 'Email must be unique.');
   END IF;
END;


-- Ensuring the phone number format is valid.
CREATE OR REPLACE TRIGGER trg_check_phone_format
BEFORE INSERT OR UPDATE ON Passengers
FOR EACH ROW
BEGIN
  IF NOT REGEXP_LIKE(:NEW.phone, '^\+?[0-9]{10,15}$') THEN
      RAISE_APPLICATION_ERROR(-20007, 'Invalid phone number format. It must contain only digits, optionally start with a "+", and have a length between 10 and 15 characters.');
  END IF;
END;


--Packages

-- The airline package contains 4 procedures already created before.
CREATE OR REPLACE PACKAGE AirlinePackage AS
   PROCEDURE RegisterPayment (
       p_reservation_id IN INT,
       p_payment_method IN VARCHAR2,
       p_amount IN DECIMAL,
       p_transaction_date IN DATE
   );

   PROCEDURE RegisterReservation (
       p_flight_id IN INT,
       p_passenger_id IN INT,
       p_reservation_date IN DATE,
       p_travel_date IN DATE,
       p_status IN VARCHAR2
   );

   PROCEDURE AddNewPassenger(
       p_first_name VARCHAR2,
       p_last_name VARCHAR2,
       p_gender VARCHAR2,
       p_email VARCHAR2,
       p_phone VARCHAR2
   );

   PROCEDURE AddNewFlight(
       p_aircraft_id VARCHAR2,
       p_origin VARCHAR2,
       p_destination VARCHAR2,
       p_departure_time DATE,
       p_arrival_time DATE,
       p_status VARCHAR2 DEFAULT 'scheduled'
   );
END AirlinePackage;


CREATE OR REPLACE PACKAGE BODY AirlinePackage AS
   PROCEDURE RegisterPayment (
       p_reservation_id IN INT,
       p_payment_method IN VARCHAR2,
       p_amount IN DECIMAL,
       p_transaction_date IN DATE
   ) AS
       v_transaction_id INT;
   BEGIN
       SELECT NVL(MAX(transaction_id), 0) + 1 INTO v_transaction_id FROM FinancialTransactions;

       INSERT INTO FinancialTransactions (
           transaction_id, reservation_id, payment_method, amount, transaction_date
       ) VALUES (
           v_transaction_id, p_reservation_id, p_payment_method, p_amount, p_transaction_date
       );

       COMMIT;
       DBMS_OUTPUT.PUT_LINE('Payment registered successfully.');
   EXCEPTION
       WHEN OTHERS THEN
           ROLLBACK;
           DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
   END RegisterPayment;

   PROCEDURE RegisterReservation (
       p_flight_id IN INT,
       p_passenger_id IN INT,
       p_reservation_date IN DATE,
       p_travel_date IN DATE,
       p_status IN VARCHAR2
   ) AS
       v_reservation_id INT;
   BEGIN
       SELECT NVL(MAX(reservation_id), 0) + 1 INTO v_reservation_id FROM Reservations;

       INSERT INTO Reservations (
           reservation_id,
           flight_id,
           passenger_id,
           reservation_date,
           travel_date,
           status
       ) VALUES (
           v_reservation_id,
           p_flight_id,
           p_passenger_id,
           p_reservation_date,
           p_travel_date,
           p_status
       );
       COMMIT;
   EXCEPTION
       WHEN OTHERS THEN
           ROLLBACK;
           RAISE;
   END RegisterReservation;

   PROCEDURE AddNewPassenger(
       p_first_name VARCHAR2,
       p_last_name VARCHAR2,
       p_gender VARCHAR2,
       p_email VARCHAR2,
       p_phone VARCHAR2
   ) AS
       v_passenger_id INT;
   BEGIN
       SELECT COALESCE(MAX(passenger_id), 0) + 1 INTO v_passenger_id FROM Passengers;

       INSERT INTO Passengers (passenger_id, first_name, last_name, gender, email, phone, loyalty_program)
       VALUES (v_passenger_id, p_first_name, p_last_name, p_gender, p_email, p_phone, 0);
   EXCEPTION
       WHEN DUP_VAL_ON_INDEX THEN
           DBMS_OUTPUT.PUT_LINE('An error occurred: Duplicate email.');
       WHEN OTHERS THEN
           DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
   END AddNewPassenger;

   PROCEDURE AddNewFlight(
       p_aircraft_id VARCHAR2,
       p_origin VARCHAR2,
       p_destination VARCHAR2,
       p_departure_time DATE,
       p_arrival_time DATE,
       p_status VARCHAR2 DEFAULT 'scheduled'
   ) AS
       v_flight_id INT;
   BEGIN
       SELECT COALESCE(MAX(flight_id), 0) + 1 INTO v_flight_id FROM Flights;

       INSERT INTO Flights (flight_id, aircraft_id, origin, destination, departure_time, arrival_time, status)
       VALUES (v_flight_id, p_aircraft_id, p_origin, p_destination, p_departure_time, p_arrival_time, p_status);
   EXCEPTION
       WHEN OTHERS THEN
           DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
   END AddNewFlight;
END AirlinePackage;


