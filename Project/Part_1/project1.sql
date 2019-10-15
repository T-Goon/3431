-- Timothy Goon, Patrick Houlihan

DROP Table Operation;
DROP TABLE Patient;
DROP TABLE PCP;
DROP TABLE Organ;
DROP TABLE OP;
DROP TABLE Surgeon;
DROP TABLE Doctor;

DROP SEQUENCE OrganID_seq;
DROP SEQUENCE PhysicianNum_seq;
DROP SEQUENCE InvoiceNum_seq;
DROP SEQUENCE healthCareID_seq;

CREATE TABLE Doctor(
PhysicianNum number,
firstName varchar2(25),
lastName varchar2(25),
type varchar2(25),
CONSTRAINT physicianNum PRIMARY KEY (physicianNum),
CONSTRAINT doc_UK UNIQUE (PhysicianNum, type)
);

CREATE TABLE OP (
PhysicianNum number,
OrganBank varchar2(25),
OrganType varchar2(25),
type varchar2(25) DEFAULT 'OP' NOT NULL,
CONSTRAINT physicianNum_FKop FOREIGN KEY (physicianNum, type) REFERENCES Doctor (physicianNum, type) ON DELETE CASCADE,
CONSTRAINT physicianNum_PK PRIMARY KEY (physicianNum),
CONSTRAINT type_CHKop CHECK (type IN ('OP'))
);

CREATE TABLE Organ (
OrganID number,
OPNum number,
BloodType varchar2(25),
DateRemoved date,
Constraint OrganOP_FK Foreign Key (OPNum) references OP (PhysicianNum),
Constraint Organ_PK Primary Key (OrganID, OPNum),
CONSTRAINT bloodType_CHKorgan CHECK (bloodType IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'))
);

CREATE TABLE PCP(
PhysicianNum number,
Specialty varchar2(25),
Facility varchar2(25),
type varchar2(25) DEFAULT 'PCP' NOT NULL,
CONSTRAINT physicianNum_FKpcp FOREIGN KEY (physicianNum, type) REFERENCES Doctor (PhysicianNum, type) ON DELETE CASCADE,
CONSTRAINT physician_PK PRIMARY KEY (physicianNum),
CONSTRAINT type_CHKpcp CHECK (type in ('PCP'))
);

CREATE TABLE Patient (
healthCareID number,
bloodType varchar2(25),
firstName varchar2(25),
lastName varchar2(25),
City varchar2(25),
State varchar2(25),
birthDate date,
MatchedOrganID number,
matchedOrganOP number,
PCPNum number,
CONSTRAINT healthCareID_PK PRIMARY KEY (healthCareID),
CONSTRAINT MatchedOrganID_FK FOREIGN KEY (MatchedOrganID, matchedOrganOP) REFERENCES Organ (organID, OPNum),
CONSTRAINT PCPNum_FK FOREIGN KEY (PCPNum) REFERENCES PCP (physicianNum),
CONSTRAINT bloodType_CHKpatient CHECK (bloodType IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'))
);

CREATE TABLE Surgeon(
PhysicianNum number,
boardCertified char(1),
type varchar2(25) DEFAULT 'surgeon' NOT NULL,
Constraint boardCertified_bool CHECK (boardCertified in ('T', 'F')),
CONSTRAINT physicianNum_FK FOREIGN KEY (physicianNum, type) REFERENCES Doctor (physicianNum, type) ON DELETE CASCADE,
CONSTRAINT physicianNumsurgeon PRIMARY KEY (physicianNum),
CONSTRAINT type_CHKsurgeon CHECK (type IN ('surgeon'))
);

CREATE TABLE Operation (
invoiceNum number,
PhysicianNum number,
PatientID number,
Cost number,
Success char(1),
dateOP date,
Constraint Success_bool CHECK (Success in ('T', 'F')),
Constraint invoice_PK Primary Key (invoiceNum, physicianNum, PatientID),
Constraint Operation_FK Foreign Key (PhysicianNum) References Surgeon (PhysicianNum),
Constraint Patient_FK Foreign Key (PatientID) References Patient (healthCareID)
);

Create sequence OrganID_seq
Start with 100
Increment by 5;
Create sequence PhysicianNum_seq
Start with 100
Increment by 5;
Create sequence InvoiceNum_seq
Start with 100
Increment by 5;
Create sequence healthCareID_seq
Start with 100
Increment by 5;

INSERT INTO Doctor VALUES(PhysicianNum_seq.nextval, 'Charlie', 'Day', 'surgeon');
INSERT INTO Doctor VALUES(PhysicianNum_seq.nextval, 'Hunter', 'Pinkleby', 'surgeon');
INSERT INTO Doctor VALUES(PhysicianNum_seq.nextval, 'Chase', 'Chalker', 'surgeon');
INSERT INTO Doctor VALUES(PhysicianNum_seq.nextval, 'Lindsay', 'Lindor', 'surgeon');
INSERT INTO Doctor VALUES(PhysicianNum_seq.nextval, 'Danny', 'Devito', 'surgeon');
INSERT INTO Doctor VALUES(PhysicianNum_seq.nextval, 'Lindsey', 'Aglet', 'PCP');
INSERT INTO Doctor VALUES(PhysicianNum_seq.nextval, 'Lana', 'Capulet', 'PCP');
INSERT INTO Doctor VALUES(PhysicianNum_seq.nextval, 'Marissa', 'Montague', 'PCP');
INSERT INTO Doctor VALUES(PhysicianNum_seq.nextval, 'Maurice', 'Jackson', 'PCP');
INSERT INTO Doctor VALUES(PhysicianNum_seq.nextval, 'James', 'Toldeo', 'PCP');
INSERT INTO Doctor VALUES(PhysicianNum_seq.nextval, 'Frank', 'Schwartz', 'OP');
INSERT INTO Doctor VALUES(PhysicianNum_seq.nextval, 'Dennis', 'Reynolds', 'OP');
INSERT INTO Doctor VALUES(PhysicianNum_seq.nextval, 'Burt', 'Macklin', 'OP');

INSERT INTO PCP (physicianNum, Specialty, Facility) VALUES(125, 'Family Practitioner', 'Hope Hospital');
INSERT INTO PCP (physicianNum, Specialty, Facility) VALUES(130, 'Physician Assistant', 'Sacred Heart Hospital');
INSERT INTO PCP (physicianNum, Specialty, Facility) VALUES(135, 'Osteopath', 'iHospital');
INSERT INTO PCP (physicianNum, Specialty, Facility) VALUES(140, 'Geriatric Practitioner', 'Death U');
INSERT INTO PCP (physicianNum, Specialty, Facility) VALUES(145, 'General Pediatrician', 'Nuclear University');

INSERT INTO Surgeon (physicianNum, boardCertified) VALUES(100, 'T');
INSERT INTO Surgeon (physicianNum, boardCertified) VALUES(105, 'F');
INSERT INTO Surgeon (physicianNum, boardCertified) VALUES(110, 'T');
INSERT INTO Surgeon (physicianNum, boardCertified) VALUES(115, 'F');
INSERT INTO Surgeon (physicianNum, boardCertified) VALUES(120, 'F');

INSERT INTO OP (PhysicianNum, OrganType, OrganBank) VALUES(150, 'Heart', 'North Star Hospital');
INSERT INTO OP (PhysicianNum, OrganType, OrganBank) VALUES(155, 'Skin', 'Paddys Pub');
INSERT INTO OP (PhysicianNum, OrganType, OrganBank) VALUES(160, 'Brain', 'Pawnee Health Clinic');

INSERT INTO Organ VALUES(OrganID_seq.nextVal, 150, 'AB-', '25-DEC-1959');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 155, 'AB+', '25-JAN-1549');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 155, 'A-', '25-MAR-1999');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 155, 'B+', '15-DEC-1929');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 160, 'O-', '25-DEC-1959');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 150, 'AB-', '25-AUG-1959');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 150, 'O+', '15-APR-1865');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 150, 'A+', '04-JUN-1929');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 160, 'B+', '25-MAY-1959');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 150, 'O-', '25-JUN-4000');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 155, 'O-', '25-DEC-0010');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 150, 'AB+', '25-DEC-1309');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 160, 'A+', '01-JAN-2000');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 160, 'B+', '25-JUL-1959');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 155, 'B+', '12-SEP-2001');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 150, 'AB-', '25-NOV-1959');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 160, 'A-', '25-DEC-1959');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 155, 'O-', '25-FEB-1959');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 160, 'O+', '31-AUG-1999');
INSERT INTO Organ VALUES(OrganID_seq.nextVal, 155, 'AB-', '25-OCT-1959');

INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'A-', 'Jane', 'Smith', 'Worcester', 'Massachusetts', '1-Jan-1979', 100, 150, 125);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'A+', 'Janet', 'Smith', 'Worcester', 'Massachusetts', '10-Jan-1979', 105, 155, 130);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'A+', 'Janice', 'Brown', 'Boston', 'Massachusetts', '1-Jan-1979', 110, 155, 135);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'A+', 'Rob', 'DiPario', 'Worcester', 'Massachusetts', '12-Jan-1979', 115, 155, 130);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'O-', 'Rick', 'Bomple', 'Boston', 'Massachusetts', '13-Jan-1979', 120, 160, 135);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'O-', 'Earl', 'Whitworth', 'Jaffery', 'New Hampshire', '1-Jan-1979', 125, 150, 125);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'AB+', 'Thebe', 'Anaka', 'Rindge', 'New Hampshire', '7-Jan-1979', 130, 150, 130);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'B-', 'Roxanne', 'Brown', 'Boston', 'Massachusetts', '9-Jan-1979', 135, 150, 135);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'B+', 'Jeeves', 'Braun', 'Worcester', 'Massachusetts', '24-Jan-1979', 140, 160, 130);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'AB+', 'Paul', 'Marshon', 'Lowell', 'Massachusetts', '24-Feb-1979', 145, 150, 125);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'O-', 'Raul', 'Thurnbock', 'Keene', 'New Hampshire', '24-Dec-1979', 150, 155, 135);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'A-', 'Saul', 'Brown', 'Worcester', 'Massachusetts', '24-Aug-1979', 155, 150, 140);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'O+', 'Kaitlynn', 'Peddler', 'Boston', 'Massachusetts', '17-Aug-1979', 160, 160, 125);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'AB-', 'Jake', 'Dipple', 'Fitchburg', 'Massachusetts', '17-Aug-1989', 165, 160, 130);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'O+', 'Jack', 'Swack', 'Worcester', 'Massachusetts', '17-Aug-1999', 170, 155, 135);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'B+', 'Susan', 'Blonda', 'Lowell', 'Massachusetts', '9-Jan-1969', 175, 150, 145);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'B+', 'Susanne', 'Ponkle', 'Boston', 'Massachusetts', '1-Jan-1972', 180, 160, 125);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'B-', 'Mike', 'James', 'Worcester', 'Massachusetts', '17-May-1963', 185, 155, 145);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'AB+', 'Dennis', 'Durnbo', 'Lowell', 'Massachusetts', '12-May-1963', 190, 160, 145);
INSERT INTO Patient VALUES(healthCareID_seq.nextval, 'O+', 'Denise', 'Deckhart', 'Fitchburg', 'Massachusetts', '2-May-1963', 195, 155, 140);

INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 100, 100, 999.99, 'F', '1-Feb-1999');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 100, 105, 170000.99, 'F', '10-Jan-2009');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 100, 110, 55, 'F', '1-Jan-1999');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 100, 115, 10, 'F', '12-Jan-2013');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 100, 120, 15000, 'F', '13-Jan-2029');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 105, 125, 30000, 'F', '1-Jan-1979');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 105, 130, 20009, 'F', '7-Jan-2009');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 105, 135, 1999, 'F', '9-Jan-2000');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 110, 140, 5, 'F', '24-Jan-1989');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 110, 145, 2, 'F', '24-Feb-1988');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 110, 150, 10, 'T', '24-Dec-1987');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 110, 155, 300, 'F', '24-Aug-1999');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 115, 160, 750, 'T', '17-Aug-2049');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 115, 165, 75000, 'T', '17-Aug-1989');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 115, 170, 2000000, 'T', '17-Aug-1999');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 115, 175, 20000, 'T', '9-Mar-1970');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 115, 180, 10000, 'T', '1-Jan-1973');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 120, 185, 7777, 'F', '17-May-1972');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 120, 190, 6666, 'F', '12-May-1983');
INSERT INTO Operation VALUES(invoiceNum_seq.nextval, 120, 195, 0, 'T', '2-May-1993');

SELECT * FROM Doctor;
SELECT * FROM PCP;
SELECT * FROM OP;
SELECT * FROM Surgeon;
SELECT * FROM Organ;
SELECT * FROM Patient;
SELECT * FROM Operation;
