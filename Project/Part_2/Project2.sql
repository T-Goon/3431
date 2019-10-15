set serveroutput on;

drop table Doctor cascade constraint;
drop table OP cascade constraint;
drop table PCP cascade constraint;
drop table Surgeon cascade constraint;
drop table Organ cascade constraint;
drop table Patient cascade constraint;
drop table Operation cascade constraint;
drop table SurgeonPatient cascade constraint;
drop sequence physicianID_seq;
drop sequence healthCareID_seq;
drop sequence invoiceNumber_seq;

create table Doctor (
physicianID number,
Role varchar2(25),
firstName varchar2(25),
lastName varchar2(25),
constraint Doctor_PK primary key (physicianID),
constraint Doctor_UN unique (physicianID, Role),
constraint DoctorRoleVal check (Role in ('OP', 'PCP', 'Surgeon', 'Other'))
);
create sequence physicianID_seq
start with 100
increment by 5;

create table OP (
physicianID number,
Role varchar2(25) default 'OP' not null,
organType varchar2(25),
organBank varchar2(25),
constraint OP_PK primary key (physicianID),
constraint OPRoleVal check (Role in ('OP')),
constraint OP_FK foreign key (physicianID, Role) references Doctor
(physicianID, Role)
);

create table PCP (
physicianID number,
Role varchar2(25) default 'PCP' not null,
specialty varchar2(25),
medicalFacility varchar2(25),
constraint PCP_PK primary key (physicianID),
constraint PCPRoleVal check (Role in ('PCP')),
constraint PCP_FK foreign key (physicianID, Role) references Doctor
(physicianID, Role)
);
create table Surgeon (
physicianID number,
Role varchar2(25) default 'Surgeon' not null,
boardCertified char(1),
constraint Surgeon_PK primary key (physicianID),
constraint SurgeonRoleVal check (Role in ('Surgeon')),
constraint SurgeonBoardCertifiedVal check (boardCertified in ('T', 'F')),
constraint Surgeon_FK foreign key (physicianID, Role) references Doctor
(physicianID, Role)
);

create table Patient (
healthCareID number,
firstName varchar2(25),
lastName varchar2(25),
city varchar2(25),
state char(2),
birthDate date,
bloodType varchar2(25),
physicianID number,
constraint Patient_PK primary key (healthCareID),
constraint Patient_FK foreign key (physicianID) references PCP(physicianID),
constraint PatientVal check (bloodType in ('A', 'B', 'AB', 'O'))
);

-- You could have included a value check for blood type as one of the following:
-- A, B, AB, O

create sequence healthCareID_seq
start with 100
increment by 5;

create table Organ (
organID number,
physicianID number,
bloodType varchar2(25),
dateRemoved date,
healthCareID number,
constraint Organ_PK primary key (organID, physicianID),
constraint Organ_FK1 foreign key (physicianID) references OP(physicianID),
constraint Organ_FK2 foreign key (healthCareID) references
Patient(healthCareID),
constraint OrganVal check (bloodType in ('A', 'B', 'AB', 'O'))
);

create table Operation (
invoiceNumber number,
operationDate date,
isSuccessful char(1),
cost number(9,2),
physicianID number,
healthCareID number,
constraint Operation_PK primary key (invoiceNumber),
constraint Operation_FK1 foreign key (physicianID) references Surgeon
(physicianID),
constraint Operation_FK2 foreign key (healthCareID) references
Patient(healthCareID),
constraint OperationVal check (isSuccessful in ('T', 'F'))
);

create sequence invoiceNumber_seq
start with 100
increment by 5;

create table SurgeonPatient (
physicianID number,
healthCareID number,
constraint SurgeonPatient_PK primary key (physicianID, healthCareID),
constraint SurgeonPatient_FK1 foreign key (physicianID) references Surgeon
(physicianID),
constraint SurgeonPatient_FK2 foreign key (healthCareID) references
Patient(healthCareID)
);

INSERT INTO Doctor (physicianID, firstName, lastName, Role) VALUES(physicianID_seq.nextval, 'Charlie', 'Day', 'Surgeon');
INSERT INTO Doctor (physicianID, firstName, lastName, Role) VALUES(physicianID_seq.nextval, 'Hunter', 'Pinkleby', 'Surgeon');
INSERT INTO Doctor (physicianID, firstName, lastName, Role) VALUES(physicianID_seq.nextval, 'Chase', 'Chalker', 'Surgeon');
INSERT INTO Doctor (physicianID, firstName, lastName, Role) VALUES(physicianID_seq.nextval, 'Lindsay', 'Lindor', 'Surgeon');
INSERT INTO Doctor (physicianID, firstName, lastName, Role) VALUES(physicianID_seq.nextval, 'Danny', 'Devito', 'Surgeon');
INSERT INTO Doctor (physicianID, firstName, lastName, Role) VALUES(physicianID_seq.nextval, 'Lindsey', 'Aglet', 'PCP');
INSERT INTO Doctor (physicianID, firstName, lastName, Role) VALUES(physicianID_seq.nextval, 'Lana', 'Capulet', 'PCP');
INSERT INTO Doctor (physicianID, firstName, lastName, Role) VALUES(physicianID_seq.nextval, 'Marissa', 'Montague', 'PCP');
INSERT INTO Doctor (physicianID, firstName, lastName, Role) VALUES(physicianID_seq.nextval, 'Maurice', 'Jackson', 'PCP');
INSERT INTO Doctor (physicianID, firstName, lastName, Role) VALUES(physicianID_seq.nextval, 'James', 'Toldeo', 'PCP');
INSERT INTO Doctor (physicianID, firstName, lastName, Role) VALUES(physicianID_seq.nextval, 'Frank', 'Schwartz', 'OP');
INSERT INTO Doctor (physicianID, firstName, lastName, Role) VALUES(physicianID_seq.nextval, 'Dennis', 'Reynolds', 'OP');
INSERT INTO Doctor (physicianID, firstName, lastName, Role) VALUES(physicianID_seq.nextval, 'Burt', 'Macklin', 'OP');

INSERT INTO PCP (physicianID, Specialty, medicalFacility) VALUES(125, 'Family Practitioner', 'Hope Hospital');
INSERT INTO PCP (physicianID, Specialty, medicalFacility) VALUES(130, 'Physician Assistant', 'Sacred Heart Hospital');
INSERT INTO PCP (physicianID, Specialty, medicalFacility) VALUES(135, 'Osteopath', 'iHospital');
INSERT INTO PCP (physicianID, Specialty, medicalFacility) VALUES(140, 'Geriatric Practitioner', 'Death U');
INSERT INTO PCP (physicianID, Specialty, medicalFacility) VALUES(145, 'General Pediatrician', 'Nuclear University');

INSERT INTO Surgeon (physicianID, boardCertified) VALUES(100, 'T');
INSERT INTO Surgeon (physicianID, boardCertified) VALUES(105, 'F');
INSERT INTO Surgeon (physicianID, boardCertified) VALUES(110, 'T');
INSERT INTO Surgeon (physicianID, boardCertified) VALUES(115, 'F');
INSERT INTO Surgeon (physicianID, boardCertified) VALUES(120, 'F');

INSERT INTO OP (physicianID, OrganType, OrganBank) VALUES(150, 'Heart', 'North Star Hospital');
INSERT INTO OP (physicianID, OrganType, OrganBank) VALUES(155, 'Skin', 'Paddys Pub');
INSERT INTO OP (physicianID, OrganType, OrganBank) VALUES(160, 'Brain', 'Pawnee Health Clinic');

INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'A', 'Jane', 'Smith', 'Worcester', 'MA', '1-Jan-1979', 125);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'A', 'Janet', 'Smith', 'Worcester', 'MA', '10-Jan-1979', 130);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'A', 'Janice', 'Brown', 'Boston', 'MA', '1-Jan-1979', 135);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'A', 'Rob', 'DiPario', 'Worcester', 'MA', '12-Jan-1979', 130);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'O', 'Rick', 'Bomple', 'Boston', 'MA', '13-Jan-1979', 135);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'O', 'Earl', 'Whitworth', 'Jaffery', 'NH', '1-Jan-1979', 125);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'AB', 'Thebe', 'Anaka', 'Rindge', 'NH', '7-Jan-1979', 130);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'B', 'Roxanne', 'Brown', 'Boston', 'MA', '9-Jan-1979', 135);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'B', 'Jeeves', 'Braun', 'Worcester', 'MA', '24-Jan-1979', 130);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'AB', 'Paul', 'Marshon', 'Lowell', 'MA', '24-Feb-1979', 125);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'O', 'Raul', 'Thurnbock', 'Keene', 'NH', '24-Dec-1979', 135);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'A', 'Saul', 'Brown', 'Worcester', 'MA', '24-Aug-1979', 140);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'O', 'Kaitlynn', 'Peddler', 'Boston', 'MA', '17-Aug-1979', 125);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'AB', 'Jake', 'Dipple', 'Fitchburg', 'MA', '17-Aug-1989', 130);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'O', 'Jack', 'Swack', 'Worcester', 'MA', '17-Aug-1999', 135);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'B', 'Susan', 'Blonda', 'Lowell', 'MA', '9-Jan-1969', 145);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'B', 'Susanne', 'Ponkle', 'Boston', 'MA', '1-Jan-1972', 125);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'B', 'Mike', 'James', 'Worcester', 'MA', '17-May-1963', 145);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'AB', 'Dennis', 'Durnbo', 'Lowell', 'MA', '12-May-1963', 145);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'O', 'Denise', 'Deckhart', 'Fitchburg', 'MA', '2-May-1963', 140);

INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 100, 100, 999.99, 'F', '1-Feb-1999');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 100, 105, 170000.99, 'F', '10-Jan-2009');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 100, 110, 55, 'F', '1-Jan-1999');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 100, 115, 10, 'F', '12-Jan-2013');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 100, 120, 15000, 'F', '13-Jan-2029');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 105, 125, 30000, 'F', '1-Jan-1979');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 105, 130, 20009, 'F', '7-Jan-2009');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 105, 135, 1999, 'F', '9-Jan-2000');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 110, 140, 5, 'F', '24-Jan-1989');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 110, 145, 2, 'F', '24-Feb-1988');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 110, 150, 10, 'T', '24-Dec-1987');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 110, 155, 300, 'F', '24-Aug-1999');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 115, 160, 750, 'T', '17-Aug-2049');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 115, 165, 75000, 'T', '17-Aug-1989');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 115, 170, 2000000, 'T', '17-Aug-1999');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 115, 175, 20000, 'T', '9-Mar-1970');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 115, 180, 10000, 'T', '1-Jan-1973');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 120, 185, 7777, 'F', '17-May-1972');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 120, 190, 6666, 'F', '12-May-1983');
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 120, 195, 0, 'T', '2-May-1993');

INSERT INTO Organ VALUES(1, 150, 'AB', '25-DEC-1959', 100);
INSERT INTO Organ VALUES(1, 155, 'AB', '25-JAN-1549', 105);
INSERT INTO Organ VALUES(2, 155, 'A', '25-MAR-1999', 110);
INSERT INTO Organ VALUES(3, 155, 'B', '15-DEC-1929', 115);
INSERT INTO Organ VALUES(1, 160, 'O', '25-DEC-1959', 120);
INSERT INTO Organ VALUES(2, 150, 'AB', '25-AUG-1959', 125);
INSERT INTO Organ VALUES(3, 150, 'O', '15-APR-1865', 130);
INSERT INTO Organ VALUES(4, 150, 'A', '04-JUN-1929', 135);
INSERT INTO Organ VALUES(2, 160, 'B', '25-MAY-1959', 140);
INSERT INTO Organ VALUES(5, 150, 'O', '25-JUN-4000', 145);
INSERT INTO Organ VALUES(4, 155, 'O', '25-DEC-0010', 150);
INSERT INTO Organ VALUES(6, 150, 'AB', '25-DEC-1309', 155);
INSERT INTO Organ VALUES(3, 160, 'A', '01-JAN-2000', 160);
INSERT INTO Organ VALUES(4, 160, 'B', '25-JUL-1959', 165);
INSERT INTO Organ VALUES(5, 155, 'B', '12-SEP-2001', 170);
INSERT INTO Organ VALUES(7, 150, 'AB', '25-NOV-1959', 175);
INSERT INTO Organ VALUES(5, 160, 'A', '25-DEC-1959', 180);
INSERT INTO Organ VALUES(6, 155, 'O', '25-FEB-1959', 185);
INSERT INTO Organ VALUES(6, 160, 'O', '31-AUG-1999', 190);
INSERT INTO Organ VALUES(7, 155, 'AB', '25-OCT-1959', 195);

insert into SurgeonPatient values(100, 100);
insert into SurgeonPatient values(100, 105);
insert into SurgeonPatient values(100, 110);
insert into SurgeonPatient values(100, 115);
insert into SurgeonPatient values(100, 120);
insert into SurgeonPatient values(105, 125);
insert into SurgeonPatient values(110, 130);
insert into SurgeonPatient values(110, 135);
insert into SurgeonPatient values(110, 140);
insert into SurgeonPatient values(115, 145);
insert into SurgeonPatient values(115, 150);
insert into SurgeonPatient values(115, 155);
insert into SurgeonPatient values(120, 160);
insert into SurgeonPatient values(120, 165);
insert into SurgeonPatient values(120, 170);
insert into SurgeonPatient values(120, 175);
insert into SurgeonPatient values(120, 180);
insert into SurgeonPatient values(120, 185);
insert into SurgeonPatient values(120, 190);
insert into SurgeonPatient values(120, 195);

CREATE OR REPLACE VIEW MatchingBloodTypes AS
SELECT OP.organType, organ.bloodType, COUNT(patient.healthCareID) AS numCombos
FROM organ LEFT JOIN OP ON organ.physicianID = OP.physicianID
FULL OUTER JOIN patient ON organ.bloodType = patient.bloodType
GROUP BY ROLLUP (OP.organType, organ.bloodType)
ORDER BY OP.organType, organ.bloodType;

SELECT * FROM MatchingBloodTypes;

CREATE OR REPLACE PROCEDURE SurgeonOperations (drFirstName IN VARCHAR2, drLastName IN VARCHAR2)
IS
numOperations number;
name varchar2(50);
BEGIN
SELECT firstName into name FROM surgeon LEFT JOIN Doctor ON surgeon.physicianID = Doctor.physicianID WHERE drFirstName = firstName AND drLastName = lastName;
SELECT COUNT(O.invoiceNumber) INTO numOperations FROM Doctor D RIGHT JOIN Surgeon S RIGHT JOIN Operation O ON O.PhysicianID = S.PhysicianID ON D.PhysicianID = O.PhysicianID WHERE drFirstName = D.firstName AND drLastName = D.lastName;
dbms_output.put_line( 'Dr. ' || drFirstName || ' ' || drLastName || ': ' || numOperations || ' operations');
EXCEPTION
    WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20403, 'There is no surgeon who has operated with the name of Dr. ' || drFirstName||' '||drLastName);
END;
/

EXEC SurgeonOperations ('James', 'Toldeo');

CREATE OR REPLACE TRIGGER InsertErrorBirthDates
BEFORE INSERT ON Patient
FOR EACH ROW
WHEN (NEW.birthDate > SYSDATE)
BEGIN
RAISE_APPLICATION_ERROR(-20001, 'Birthdate cannot be in the future.');
END;
/

INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'O', 'Dense', 'eckhart', 'Fitchburg', 'MA', '2-May-2030', 140);
INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'O', 'Drense', 'ecrkhart', 'Fitchburg', 'MA', '2-May-2010', 140);

CREATE OR REPLACE TRIGGER BadBloodType
AFTER INSERT ON Operation
FOR EACH ROW
DECLARE
orgBType varchar2(25);
patBType varchar2(25);
BEGIN
SELECT bloodType INTO orgBType FROM Organ WHERE healthCareID = :new.healthCareID;
SELECT bloodType INTO patBType FROM Patient WHERE healthCareID = :new.healthCareID;
IF orgBType <> patBType THEN
  RAISE_APPLICATION_ERROR(-20002, 'The organ and patient blood type do not match.');
END IF;
END;
/

CREATE OR REPLACE TRIGGER FailedOperation
AFTER INSERT ON Operation
DECLARE
CURSOR OPID IS SELECT healthCareID FROM Operation;
orgBType varchar2(25);
patBType varchar2(25);
BEGIN
  FOR ID IN OPID LOOP
    SELECT bloodType INTO orgBType FROM Organ WHERE healthCareID = ID.healthCareID;
    SELECT bloodType INTO patBType FROM Patient WHERE healthCareID = ID.healthCareID;
    IF orgBType <> patBType THEN
      UPDATE Operation SET isSuccessful = 'F' WHERE healthCareID = ID.healthCareID;
    END IF;
  END LOOP;
END;
/

CREATE OR REPLACE TRIGGER NoMatch
BEFORE INSERT ON Operation
FOR EACH ROW
DECLARE
SPSurgeonID number;
SPPatientID number;
BEGIN
SELECT healthCareID, physicianID INTO SPPatientID, SPSurgeonID FROM SurgeonPatient
WHERE healthCareID = :NEW.healthCareID AND physicianID = :NEW.physicianID;
EXCEPTION
    WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20433, 'Surgeon and Patient pair does not exist.');
END;
/


insert into SurgeonPatient values(120, 205);

INSERT INTO Organ VALUES(8, 155, 'AB', '25-OCT-1959', 205);
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 120, 205, 0, 'T', '2-May-1993');

INSERT INTO Patient (healthCareID, bloodType, firstName, lastName, city, state, birthDate, physicianID) VALUES(healthCareID_seq.nextval, 'AB', 'Drese', 'ecrkhrt', 'Fitchburg', 'MA', '2-May-2010', 140);
INSERT INTO Organ VALUES(9, 155, 'AB', '25-OCT-1959', 210);
INSERT INTO Operation (invoiceNumber, physicianID, healthCareID, cost, isSuccessful, operationDate) VALUES(invoiceNumber_seq.nextval, 120, 210, 0, 'T', '2-May-1993');

select healthCareID, physicianID from SurgeonPatient;
