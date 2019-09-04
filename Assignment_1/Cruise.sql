DROP TABLE Reservation;
DROP TABLE Cruise;
DROP TABLE Company;
DROP TABLE Customer;
DROP TABLE TravelAgent;

DROP SEQUENCE reservationID_seq;
DROP SEQUENCE customerID_seq;
DROP SEQUENCE cruiseID_seq;
DROP SEQUENCE travelAgentID_seq;

CREATE TABLE Customer(
  customerID number,
  firstName varchar2(15),
  lastName varchar2(15),
  address varchar2(30),
  phone number(10),
  age number(3),
  CONSTRAINT customerID_PK PRIMARY KEY (customerID),
  CONSTRAINT phone_notNull CHECK (phone IS NOT NULL),
  CONSTRAINT canidateKey1 UNIQUE (firstName, lastName, phone)
);

CREATE SEQUENCE customerID_seq START WITH 1 INCREMENT BY 1;


CREATE TABLE TravelAgent(
  travelAgentID number,
  firstName varchar2(15),
  lastName varchar2(20),
  title varchar2(15),
  salary number(7,2),
  CONSTRAINT travelAgentID_PK PRIMARY KEY (travelAgentID),
  CONSTRAINT title_check CHECK (title='Assistant' OR title='Agent' OR title='Manager')
);

CREATE SEQUENCE travelAgentID_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE Company(
  companyName varchar2(15),
  stockSymbol char(4),
  website varchar2(40),
  CONSTRAINT companyName_PK PRIMARY KEY (companyName),
  CONSTRAINT stockSymbol_UQ UNIQUE (stockSymbol)
);

CREATE TABLE Cruise(
  cruiseID number,
  cruiseName varchar2(25),
  departurePort varchar2(20),
  days number(2),
  companyName varchar2(15),
  shipName varchar2(30),
  price number(7,2),
  CONSTRAINT cruiseID_PK PRIMARY KEY (cruiseID),
  CONSTRAINT companyName_FK FOREIGN KEY (companyName) REFERENCES Company (companyName) ON DELETE SET NULL
);

CREATE SEQUENCE cruiseID_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE Reservation(
  reservationID number,
  customerID number,
  cruiseID number,
  travelAgentID number,
  travelDate date,
  CONSTRAINT reservationID_PK PRIMARY KEY (reservationID),
  CONSTRAINT customerID_FK FOREIGN KEY (customerID) REFERENCES Customer (customerID) ON DELETE CASCADE,
  CONSTRAINT cruiseID_FK FOREIGN KEY (cruiseID) REFERENCES Cruise (cruiseID) ON DELETE CASCADE,
  CONSTRAINT travelAgentID_FK FOREIGN KEY (travelAgentID) REFERENCES TravelAgent (travelAgentID) ON DELETE CASCADE
);

CREATE SEQUENCE reservationID_seq START WITH 1 INCREMENT BY 1;

INSERT INTO Customer VALUES(customerID_seq.nextval, 'Dylan', 'Ward', '42 Elm Place', 8915367188, 22);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Austin', 'Ross', '657 Redondo Ave.', 1233753684, 25);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Lisa', 'Powell', '5 Jefferson Ave.', 6428369619, 17);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Brian', 'Martin', '143 Cambridge Ave.', 5082328798, 45);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Nicole', 'White', '77 Massachusetts Ave.', 6174153059, 29);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Tyler', 'Garcia', '175 Forest St.', 9864752346, 57);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Anna', 'Allen', '35 Tremont St.', 8946557732, 73);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Michael', 'Sanchez', '9 Washington Court', 1946825344, 18);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Justin', 'Myers', '98 Lake Hill Drive', 7988641411, 26);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Bruce', 'Clark', '100 Main St.', 2324648888, 68);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Rachel', 'Lee', '42 Oak St.', 2497873464, 19);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Kelly', 'Gray', '1414 Cedar St.', 9865553232, 82);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Madison', 'Young', '8711 Meadow St.', 4546667821, 67);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Ashley', 'Powell', '17 Valley Drive', 2123043923, 20);
INSERT INTO Customer VALUES(customerID_seq.nextval, 'Joshua', 'Davis', '1212 8th St.', 7818914567, 18);

INSERT INTO TravelAgent VALUES(travelAgentID_seq.nextval, 'Chloe', 'Rodriguez', 'Assistant', 31750);
INSERT INTO TravelAgent VALUES(travelAgentID_seq.nextval, 'Ben', 'Wilson', 'Agent', 47000.22);
INSERT INTO TravelAgent VALUES(travelAgentID_seq.nextval, 'Mia', 'Smith', 'Manager', 75250);
INSERT INTO TravelAgent VALUES(travelAgentID_seq.nextval, 'Noah', 'Williams', 'Assistant', 32080.9);
INSERT INTO TravelAgent VALUES(travelAgentID_seq.nextval, 'Liam', 'Brown', 'Manager', 60500.75);
INSERT INTO TravelAgent VALUES(travelAgentID_seq.nextval, 'Mason', 'Jones', 'Manager', 79000);
INSERT INTO TravelAgent VALUES(travelAgentID_seq.nextval, 'Olivia', 'Miller', 'Agent', 54000.5);
INSERT INTO TravelAgent VALUES(travelAgentID_seq.nextval, 'Sofia', 'Davis', 'Agent', 45000);
INSERT INTO TravelAgent VALUES(travelAgentID_seq.nextval, 'Jason', 'Garcia', 'Manager', 52025.95);
INSERT INTO TravelAgent VALUES(travelAgentID_seq.nextval, 'Emily', 'Johnson', 'Assistant', 22000.5);
INSERT INTO TravelAgent VALUES(travelAgentID_seq.nextval, 'Ethan', 'Elm', 'Agent', 27044.52);

INSERT INTO Company VALUES('Carnival', 'CRVL', 'http://www.carnival.com');
INSERT INTO Company VALUES('Celebrity', 'CELB', 'http://www.celebritycruises.com');
INSERT INTO Company VALUES('NCL', 'NCLC', 'http://www.ncl.com');
INSERT INTO Company VALUES('Princess', 'PRCS', 'http://www.princess.com');

INSERT INTO Cruise VALUES(cruiseID_seq.nextval, 'Mexico', 'Miami', 7, 'NCL', 'Norwegian Pearl', 799);
INSERT INTO Cruise VALUES(cruiseID_seq.nextval, 'New England', 'Boston', 7, 'NCL', 'Norwegian Jewel', 895.75);
INSERT INTO Cruise VALUES(cruiseID_seq.nextval, 'ABC Islands', 'Miami', 4, 'Celebrity', 'Equinox', 450.5);
INSERT INTO Cruise VALUES(cruiseID_seq.nextval, 'Hawaii', 'San Francisco', 14, 'Princess', 'Crown Princess', 2310);
INSERT INTO Cruise VALUES(cruiseID_seq.nextval, 'Panama Canal', 'Miami', 10, 'Carnival', 'Carnival Spirit', 1432.99);

INSERT INTO Reservation VALUES(reservationID_seq.nextval, 12, 1, 2, '9-Nov-18');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 14, 4, 5, '21-Jan-19');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 5, 4, 1, '11-Dec-18');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 9, 5, 4, '31-Aug-19');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 13, 1, 2, '10-Apr-19');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 5, 4, 6, '29-Jul-18');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 2, 2, 2, '17-May-19');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 4, 1, 10, '11-Apr-19');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 10, 5, 3, '3-Jun-18');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 5, 3, 9, '15-Oct-18');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 1, 2, 7, '8-Mar-19');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 5, 4, 7, '24-Nov-18');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 8, 1, 1, '3-Aug-19');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 15, 5, 10, '13-Dec-18');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 4, 3, 7, '6-Feb-19');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 6, 4, 5, '12-Aug-19');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 14, 2, 8, '22-Jun-19');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 11, 5, 9, '1-Feb-19');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 7, 4, 8, '15-Mar-19');
INSERT INTO Reservation VALUES(reservationID_seq.nextval, 14, 4, 3, '28-Feb-19');

UPDATE Cruise SET price = price * 1.15 WHERE departurePort = 'Miami';

SELECT cruiseName, departurePort, shipName, TO_CHAR(price,'L9999D99') AS NEWPRICE FROM Cruise WHERE departurePort = 'Miami';

SELECT DISTINCT Cruise.companyName, Cruise.cruiseName FROM Reservation
JOIN Cruise ON Cruise.cruiseID = Reservation.cruiseID
JOIN Customer ON Customer.customerID = Reservation.customerID
WHERE Customer.age > 50 AND Cruise.departurePort = 'Miami'
ORDER BY Cruise.companyName;

SELECT companyName || ' ' || stockSymbol AS CruiseCompany, cruiseName, travelDate
FROM Reservation
NATURAL JOIN Cruise
NATURAL JOIN Company
WHERE days >= 10 AND travelDate > '31-Dec-2018'
ORDER BY cruiseName, travelDate;

SELECT TravelAgent.firstName, TravelAgent.lastName, TravelAgent.title FROM Reservation
RIGHT JOIN TravelAgent on Reservation.travelAgentID = TravelAgent.travelAgentID
WHERE CustomerID IS NULL;
