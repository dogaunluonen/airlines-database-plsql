-- TABLES

CREATE TABLE Airports (
   	airport_id_code VARCHAR2(5)  PRIMARY KEY,
   	name VARCHAR2(55) NOT NULL,
   	city VARCHAR2(35)NOT NULL,
   	country VARCHAR2(30)NOT NULL
);

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    first_name VARCHAR2(100) NOT NULL,
    last_name VARCHAR2(100)NOT NULL,
    Gender VARCHAR2(8) CHECK (Gender IN ('Man', 'Woman'))NOT NULL,
    email VARCHAR2(100) UNIQUE,
    phone VARCHAR2(20),
    loyalty_program INT 
);

CREATE TABLE Aircrafts (
   	aircraft_id VARCHAR2(9) PRIMARY KEY,
   	model VARCHAR(50) NOT NULL,
   	capacity INT CHECK (capacity  BETWEEN 30 AND 600) NOT NULL
 );

CREATE TABLE Flights (
    flight_id INT PRIMARY KEY,
    aircraft_id VARCHAR2(9),        
    origin VARCHAR2(3) NOT NULL,
    destination VARCHAR2(3)NOT NULL,
    departure_time DATE ,
    arrival_time DATE,
    status VARCHAR2(20) CHECK (status IN(‘delayed’, 'departed’, 'scheduled’)),

    FOREIGN KEY (aircraft_id) REFERENCES Aircrafts(aircraft_id),
    FOREIGN KEY (origin ) REFERENCES Airport(airport_id_code ),
    FOREIGN KEY (destination  ) REFERENCES Airport(airport_id_code )
);

CREATE TABLE Reservations (
    reservation_id INT PRIMARY KEY,
    flight_id INT NOT NULL,
    passenger_id INT, 
    reservation_date DATE NOT NULL,
    travel_date DATE NOT NULL,
    status VARCHAR2(20) CHECK (status IN ('confirmed', 'canceled', 'pending','completed')),


    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id)
);

CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY,
    reservation_id INT,
    passenger_id INT,
    flight_id INT,
    seat VARCHAR2(5) NOT NULL,
    class VARCHAR2(15) CHECK (class IN('Economy','Business')) NOT NULL,
    price DECIMAL(8,2) NOT NULL,
    status VARCHAR(20) CHECK (status IN('issued', 'canceled', 'modified')),


    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id),
    FOREIGN KEY (flight_id ) REFERENCES Flights(flight_id),
    FOREIGN KEY (passenger_id ) REFERENCES Passengers (passenger_id)
   
);

CREATE TABLE FinancialTransactions (
    transaction_id INT PRIMARY KEY,
    reservation_id INT NOT NULL,
    payment_method VARCHAR(50)  CHECK ( payment_method IN( 'credit_card', 'paypal')) NOT NULL,
    amount DECIMAL(9, 2) NOT NULL,
    transaction_date DATE NOT NULL,

    FOREIGN KEY (reservation_id) REFERENCES Reservations(reservation_id)
);


-- DATA


INSERT INTO Passengers (passenger_id, first_name, last_name, email, phone, gender,loyalty_program ) VALUES
(1, 'Alice', 'Martin', 'alice.martin@yahoo.com', '+0123456789', 'Woman',0),
(2, 'Bob', 'Smith', 'bob.smith@gmail.com', '+0123456790', 'Man',0),
(3, 'Carmen', 'Diaz', 'carmen.diaz@p.lodz.com', '+33634567915', 'Woman',0),
(4, 'David', 'Rousseau', 'david.rousseau@uni-lodz.com', '+48012345792', 'Man',0),
(5, 'Eva', 'Lambert', 'eva.lambert@gov.fr', '+0123456793', 'Woman',0),
(6, 'Frank', 'Petit', 'frank.petit@gov.it', '+0123456794', 'Man',0),
(7, 'Gina', 'Tessier', 'gina.tessier@orange.com', '+0123456795', 'Woman',0),
(8, 'Hannah', 'Johnson', 'hannah.johnson@gmail.com', '+123456789', 'Woman',0),
(9, 'Ian', 'Wilson', 'ian.wilson@yahoo.com', '+987654321', 'Man',0),
(10, 'Julia', 'Clark', 'julia.clark@gmail.com', '+987654322', 'Woman',0),
(11, 'Kevin', 'Brown', 'kevin.brown@yahoo.com', '+987654323', 'Man',0),
(12, 'Lily', 'Adams', 'lily.adams@gmail.com', '+987654324', 'Woman',0),
(13, 'Michael', 'Taylor', 'michael.taylor@yahoo.com', '+987654325', 'Man',0),
(14, 'Natalie', 'Morris', 'natalie.morris@apple.com', '+987654326', 'Woman',0),
(15, 'Oscar', 'Roberts', 'oscar.roberts@yahoo.com', '+987654327', 'Man',0),
(16, 'Penelope', 'Garcia', 'penelope.garcia@gmail.com', '+987654328', 'Woman',0),
(17, 'Quentin', 'Adams', 'quentin.adams@hotmail.com', '+987654329', 'Man',0),
(18, 'Rachel', 'Stewart', 'rachel.stewart@gmail.com', '+987654330', 'Woman',0),
(19, 'Samuel', 'Wright', 'samuel.wright@yahoo.com', '+987654331', 'Man',0),
(20, 'Tiffany', 'Parker', 'tiffany.parker@plus.pl', '+987654332', 'Woman',0),
(21, 'Ulysses', 'Campbell', 'ulysses.campbell@free.fr', '+987654333', 'Man',0),
(22, 'Victoria', 'Howard', 'victoria.howard@hotmail.com', '+987654334', 'Woman',0),
(23, 'Walter', 'Nelson', 'walter.nelson@hotmail.com', '+987654335', 'Man',0),
(24, 'Xavier', 'Rossi', 'xavier.rossi@orange.com', '+987654336', 'Man',0),
(25, 'Yvonne', 'Lopez', 'yvonne.lopez@yahoo.com', '+987654337', 'Woman',0),
(26, 'Zachary', 'Baker', 'zachary.baker@gmail.com', '+987654338', 'Man',0),
(27, 'Amelia', 'Perez', 'amelia.perez@orange.com', '+987654339', 'Woman',0),
(28, 'Benjamin', 'Evans', 'benjamin.evans@apple.com', '+987654340', 'Man',0),
(29, 'Charlotte', 'Rivera', 'charlotte.rivera@yahoo.com', '+987654341', 'Woman',0),
(30, 'Dylan', 'Mitchell', 'dylan.mitchell@gmail.com', '+987654342', 'Man',0),
(31, 'Emily', 'Gomez', 'emily.gomez@yahoo.com', '+987654343', 'Woman',0),
(32, 'Felix', 'Stewart', 'felix.stewart@example.com', '+987654344', 'Man',0),
(33, 'Grace', 'Collins', 'grace.collins@apple.com', '+987654345', 'Woman',0),
(34, 'Henry', 'Perry', 'henry.perry@yahoo.com', '+987654346', 'Man',0),
(35, 'Isabella', 'Hernandez', 'isabella.hernandez@hotmail.com', '+987654347', 'Woman',0),
(36, 'Jacob', 'Sanchez', 'jacob.sanchez@gmail.com', '+987654348', 'Man',0),
(37, 'Katherine', 'Martinez', 'katherine.martinez@apple.com', '+987654349', 'Woman',0),
(38, 'Liam', 'Gonzalez', 'liam.gonzalez@gmail.com', '+987654350', 'Man',0),
(39, 'Mia', 'Flores', 'mia.flores@hotmail.com', '+987654351', 'Woman',0),
(40, 'Noah', 'Ramirez', 'noah.ramirez@gov.uk', '+987654352', 'Man',0),
(41, 'Olivia', 'Torres', 'olivia.torres@gmail.com', '+987654353', 'Woman',0),
(42, 'Patrick', 'Reyes', 'patrick.reyes@gmail.com', '+987654354', 'Man',0),
(43, 'Quinn', 'Vasquez', 'quinn.vasquez@hotmail.com', '+987654355', 'Woman',0),
(44, 'Ryan', 'Jimenez', 'ryan.jimenez@hotmail.com', '+987654356', 'Man',0),
(45, 'Sophia', 'Nguyen', 'sophia.nguyen@gov.fr', '+987654357', 'Woman',0);

INSERT INTO Airports (airport_id_code, name, city, country) VALUES 
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'United States'),
('JFK', 'John F. Kennedy International Airport', 'New York City', 'United States'),
('LHR', 'London Heathrow Airport', 'London', 'United Kingdom'),
('CDG', 'Charles de Gaulle Airport', 'Paris', 'France'),
('PEK', 'Beijing Capital International Airport', 'Beijing', 'China'),
('DXB', 'Dubai International Airport', 'Dubai', 'United Arab Emirates'),
('AMS', 'Amsterdam Airport Schiphol', 'Amsterdam', 'Netherlands'),
('HND', 'Tokyo Haneda Airport', 'Tokyo', 'Japan'),
('MUC', 'Munich Airport', 'Munich', 'Germany'),
('ATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'United States'),
('SIN', 'Singapore Changi Airport', 'Singapore', 'Singapore'),
('IST', 'Istanbul Airport', 'Istanbul', 'Turkey'),
('SYD', 'Sydney Kingsford Smith Airport', 'Sydney', 'Australia'),
('DFW', 'Dallas/Fort Worth International Airport', 'Dallas', 'United States'),
('ORD', 'Chicago O\Hare International Airport', 'Chicago', 'United States');

INSERT INTO Aircrafts (aircraft_id, model, capacity) VALUES
('AC001', 'Airbus A320', 180),
('AC002', 'Boeing 737', 160),
('AC003', 'Boeing 747', 366),
('AC004', 'Airbus A380', 555),
('AC005', 'Embraer 190', 114),
('AC006', 'Boeing 777', 396),
('AC007', 'Airbus A330', 335),
('AC008', 'Boeing 767', 375),
('AC009', 'Airbus A350', 440),
('AC010', 'Boeing 787', 290),
('AC011', 'Bombardier CS300', 130),
('AC012', 'Airbus A340', 375),
('AC013', 'Boeing 757', 243),
('AC014', 'Airbus A350-900', 325),
('AC015', 'Airbus A321', 220),
('AC016', 'Boeing 737 MAX', 189),
('AC017', 'Embraer E195', 122),
('AC018', 'Airbus A319', 124),
('AC019', 'Boeing 767-300', 290),
('AC020', 'Airbus A330-200', 247),
('AC021', 'Bombardier Q400', 78),
('AC022', 'Boeing 777-300ER', 396),
('AC023', 'Airbus A350-900', 325),
('AC024', 'Boeing 787-9', 290);

INSERT INTO Flights (flight_id, aircraft_id, origin, destination, departure_time, arrival_time, status) VALUES
(1, 'AC001', 'LAX', 'JFK', TO_DATE('2024-06-01 08:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-01 16:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(2, 'AC002', 'JFK', 'LHR', TO_DATE('2024-06-02 10:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-02 22:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(3, 'AC003', 'LHR', 'CDG', TO_DATE('2024-06-03 12:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-03 14:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(4, 'AC005', 'SYD', 'PEK', TO_DATE('2024-06-06 09:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-06 15:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(5, 'AC006', 'PEK', 'DXB', TO_DATE('2024-06-07 16:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-07 22:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(6, 'AC007', 'DXB', 'AMS', TO_DATE('2024-06-08 08:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-08 14:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(7, 'AC008', 'AMS', 'HND', TO_DATE('2024-06-09 10:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-09 22:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(8, 'AC009', 'HND', 'MUC', TO_DATE('2024-06-10 12:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-10 16:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(9, 'AC010', 'MUC', 'LAX', TO_DATE('2024-06-11 18:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-11 23:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(10, 'AC011', 'ATL', 'ORD', TO_DATE('2024-06-12 08:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-12 11:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(11, 'AC012', 'ORD', 'DFW', TO_DATE('2024-06-13 12:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-13 15:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(12, 'AC013', 'DFW', 'ATL', TO_DATE('2024-06-14 16:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-14 18:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(13, 'AC014', 'SIN', 'IST', TO_DATE('2024-06-15 08:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-15 12:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(14, 'AC017', 'LAX', 'HND', TO_DATE('2024-06-19 15:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-19 23:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(15, 'AC018', 'HND', 'AMS', TO_DATE('2024-06-20 10:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-20 18:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(16, 'AC019', 'AMS', 'CDG', TO_DATE('2024-06-21 12:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-21 14:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(17, 'AC020', 'CDG', 'PEK', TO_DATE('2024-06-22 16:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-23 04:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(18, 'AC021', 'PEK', 'SIN', TO_DATE('2024-06-24 08:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-24 12:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(19, 'AC022', 'SIN', 'LHR', TO_DATE('2024-06-25 14:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-25 20:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(20, 'AC023', 'LHR', 'DXB', TO_DATE('2024-06-26 09:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-26 15:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(21, 'AC024', 'DXB', 'IST', TO_DATE('2024-06-27 18:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-27 22:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(22, 'AC002', 'IST', 'ATL', TO_DATE('2024-06-28 10:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-28 14:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(23, 'AC001', 'JFK', 'AMS', TO_DATE('2024-06-29 08:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-29 14:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(24, 'AC002', 'AMS', 'MUC', TO_DATE('2024-06-30 10:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-06-30 14:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(25, 'AC003', 'MUC', 'LHR', TO_DATE('2024-07-01 12:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-07-01 14:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(26, 'AC004', 'LHR', 'PEK', TO_DATE('2024-07-02 15:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-07-03 08:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(27, 'AC005', 'PEK', 'DXB', TO_DATE('2024-07-04 09:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-07-04 15:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(28, 'AC008', 'HND', 'CDG', TO_DATE('2024-07-07 10:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-07-07 22:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(29, 'AC009', 'CDG', 'ATL', TO_DATE('2024-07-08 12:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-07-08 16:00', 'YYYY-MM-DD HH24:MI'), 'scheduled'),
(30, 'AC010', 'ATL', 'ORD', TO_DATE('2024-07-09 18:00', 'YYYY-MM-DD HH24:MI'), TO_DATE('2024-07-09 21:00', 'YYYY-MM-DD HH24:MI'), 'scheduled');


INSERT INTO Reservations (reservation_id, flight_id, passenger_id, reservation_date, travel_date, status) VALUES
(1, 1, 1, TO_DATE('2024-04-01', 'YYYY-MM-DD'), TO_DATE('2024-06-01', 'YYYY-MM-DD'), 'confirmed'),
(2, 2, 2, TO_DATE('2024-04-02', 'YYYY-MM-DD'), TO_DATE('2024-06-02', 'YYYY-MM-DD'), 'confirmed'),
(3, 3, 3, TO_DATE('2024-04-03', 'YYYY-MM-DD'), TO_DATE('2024-06-03', 'YYYY-MM-DD'), 'confirmed'),
(4, 4, 4, TO_DATE('2024-04-04', 'YYYY-MM-DD'), TO_DATE('2024-06-06', 'YYYY-MM-DD'), 'confirmed'),
(5, 5, 5, TO_DATE('2024-04-05', 'YYYY-MM-DD'), TO_DATE('2024-06-07', 'YYYY-MM-DD'), 'confirmed'),
(6, 6, 6, TO_DATE('2024-04-06', 'YYYY-MM-DD'), TO_DATE('2024-06-08', 'YYYY-MM-DD'), 'confirmed'),
(7, 7, 7, TO_DATE('2024-04-07', 'YYYY-MM-DD'), TO_DATE('2024-06-09', 'YYYY-MM-DD'), 'confirmed'),
(8, 8, 8, TO_DATE('2024-04-08', 'YYYY-MM-DD'), TO_DATE('2024-06-10', 'YYYY-MM-DD'), 'confirmed'),
(9, 9, 9, TO_DATE('2024-04-09', 'YYYY-MM-DD'), TO_DATE('2024-06-11', 'YYYY-MM-DD'), 'confirmed'),
(10, 10, 10, TO_DATE('2024-04-10', 'YYYY-MM-DD'), TO_DATE('2024-06-12', 'YYYY-MM-DD'), 'confirmed'),
(11, 11, 11, TO_DATE('2024-04-11', 'YYYY-MM-DD'), TO_DATE('2024-06-13', 'YYYY-MM-DD'), 'confirmed'),
(12, 12, 12, TO_DATE('2024-04-12', 'YYYY-MM-DD'), TO_DATE('2024-06-14', 'YYYY-MM-DD'), 'confirmed'),
(13, 13, 13, TO_DATE('2024-04-13', 'YYYY-MM-DD'), TO_DATE('2024-06-15', 'YYYY-MM-DD'), 'confirmed'),
(14, 14, 14, TO_DATE('2024-04-14', 'YYYY-MM-DD'), TO_DATE('2024-06-19', 'YYYY-MM-DD'), 'confirmed'),
(15, 15, 15, TO_DATE('2024-04-15', 'YYYY-MM-DD'), TO_DATE('2024-06-20', 'YYYY-MM-DD'), 'confirmed');

INSERT INTO Tickets (ticket_id, reservation_id, flight_id, seat, class, price, passenger_id, status) VALUES
(1, 1, 11, '25D', 'Economy', 950.00, 1, 'issued'),
(2, 2, 2, '28A', 'Economy', 900.00, 2, 'issued'),
(3, 3, 14, '2F', 'Business', 2000.00, 3, 'issued'),
(4, 4, 5, '8A', 'Economy', 1200.00, 4, 'issued'),
(5, 5, 9, '9E', 'Economy', 1100.00, 5, 'issued'),
(6, 6, 1, '22C', 'Economy', 850.00, 6, 'issued'),
(7, 7, 13, '15B', 'Economy', 1000.00, 7, 'issued'),
(8, 8, 6, '32F', 'Economy', 700.00, 8, 'issued'),
(9, 9, 8, '3D', 'Business', 1750.00, 9, 'issued'),
(10, 10, 12, '14F', 'Economy', 1050.00, 10, 'issued'),
(11, 11, 3, '30A', 'Economy', 750.00, 11, 'issued'),
(12, 12, 7, '21E', 'Economy', 700.00, 12, 'issued'),
(13, 13, 10, '17C', 'Economy', 1000.00, 13, 'issued'),
(14, 14, 4, '2A', 'Economy', 1850.00, 14, 'issued'),
(15, 15, 15, '7D', 'Economy', 1100.00, 15, 'issued'),
(16, 1, 8, '12B', 'Economy', 1050.00, 16, 'issued'),
(17, 2, 13, '5F', 'Economy', 1200.00, 17, 'issued'),
(18, 3, 4, '28D', 'Economy', 800.00, 18, 'issued'),
(19, 4, 7, '10A', 'Economy', 1300.00, 19, 'issued'),
(20, 5, 11, '3C', 'Business', 1800.00, 20, 'issued'),
(21, 6, 15, '18B', 'Economy', 1000.00, 21, 'issued'),
(22, 7, 3, '25E', 'Economy', 850.00, 22, 'issued'),
(23, 8, 10, '31A', 'Economy', 800.00, 23, 'issued'),
(24, 9, 14, '1F', 'Business', 1900.00, 24, 'issued'),
(25, 10, 2, '13C', 'Economy', 950.00, 25, 'issued'),
(26, 11, 5, '7B', 'Economy', 1000.00, 26, 'issued'),
(27, 12, 1, '22A', 'Economy', 1100.00, 27, 'issued'),
(28, 13, 12, '8B', 'Economy', 1300.00, 28, 'issued'),
(29, 14, 9, '19E', 'Economy', 1200.00, 29, 'issued'),
(30, 15, 6, '1D', 'Business', 1800.00, 30, 'issued'),
(31, 1, 10, '11C', 'Economy', 950.00, 31, 'issued'),
(32, 2, 7, '9B', 'Economy', 1000.00, 32, 'issued'),
(33, 3, 2, '1A', 'Business', 2200.00, 33, 'issued'),
(34, 4, 11, '30F', 'Economy', 1000.00, 34, 'issued'),
(35, 5, 4, '27B', 'Economy', 800.00, 35, 'issued'),
(36, 6, 14, '6D', 'Economy', 1100.00, 36, 'issued'),
(37, 7, 8, '2B', 'Business', 2100.00, 37, 'issued'),
(38, 8, 5, '9A', 'Economy', 1100.00, 38, 'issued'),
(39, 9, 1, '22E', 'Economy', 900.00, 39, 'issued'),
(40, 10, 13, '10C', 'Economy', 1000.00, 40, 'issued'),
(41, 11, 6, '32C', 'Economy', 500.00, 41, 'issued'),
(42, 12, 3, '7F', 'Economy', 1200.00, 42, 'issued'),
(43, 13, 12, '14B', 'Economy', 900.00, 43, 'issued'),
(44, 14, 9, '3A', 'Business', 1900.00, 44, 'issued');

INSERT INTO FinancialTransactions (transaction_id, reservation_id, payment_method, amount, transaction_date) VALUES
(1, 1, 'credit_card', 2950.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')),
(2, 2, 'credit_card', 3100.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')), 
(3, 3, 'paypal', 5000.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')),      
(4, 4, 'credit_card', 3500.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')), 
(5, 5, 'paypal', 3700.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')),     
(6, 6, 'credit_card', 2950.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')), 
(7, 7, 'paypal', 3950.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')),      
(8, 8, 'credit_card', 2600.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')), 
(9, 9, 'paypal', 4550.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')),      
(10, 10, 'credit_card', 3000.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')),
(11, 11, 'paypal', 2250.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')),  
(12, 12, 'credit_card', 4000.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')),
(13, 13, 'paypal', 3200.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')),    
(14, 14, 'credit_card', 4950.00, TO_DATE('2024-04-26', 'YYYY-MM-DD')),
(15, 15, 'paypal', 2900.00, TO_DATE('2024-04-26', 'YYYY-MM-DD'));