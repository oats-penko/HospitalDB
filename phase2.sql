/*PART 1 CREATING THE DATABASE */

CREATE TABLE Employee
(
	ID INTEGER PRIMARY KEY,
	salary REAL DEFAULT 0,
	officeNumber INTEGER NOT NULL, 
	jobTitle VARCHAR2(20),
	firstName VARCHAR2(20), 
	lastName VARCHAR2(20), 
	managerID INTEGER,
	CONSTRAINT jobPsn CHECK (jobTitle in ('Regular', 'DivisionManager', 'GeneralManager')),
	CONSTRAINT mngID FOREIGN KEY (managerID) REFERENCES EMPLOYEE(ID)
);

CREATE TABLE Room
(
	roomNumber INTEGER PRIMARY KEY, 
	occupied NUMBER(1)
	CONSTRAINT flag CHECK (occupied in (1,0))
); 

CREATE TABLE empAccess(
	empID INTEGER, 
	roomNumber INTEGER NOT NULL,
	FOREIGN KEY (empID) REFERENCES Employee(ID), 
	FOREIGN KEY (roomNumber) REFERENCES Room(roomNumber),
	PRIMARY KEY (empID, roomNumber)
);

INSERT INTO empAccess VALUES(100, 1);
INSERT INTO empAccess VALUES(101, 2);
INSERT INTO empAccess VALUES(101, 3);
INSERT INTO empAccess VALUES(200, 2);
INSERT INTO empAccess VALUES(200, 2);
INSERT INTO empAccess VALUES(300, 3);
INSERT INTO empAccess VALUES(300, 3);

CREATE TABLE roomService(
	roomNumber INTEGER FOREIGN KEY REFERENCES Room(roomNumber), 
	rService VARCHAR2(100),
	PRIMARY KEY (roomNumber, rService)
); 

INSERT INTO roomService VALUES(2, 'MRI'); /*add more services */
INSERT INTO roomService VALUES(2, 'OperatingRoom');
INSERT INTO roomService VALUES(1, 'EmergencyRoom');
INSERT INTO roomService VALUES(1, 'ICU');
INSERT INTO roomService VALUES(1, 'Bathroom');
INSERT INTO roomService VALUES(3, 'ICU');
INSERT INTO roomService VALUES(3, 'ICU');
INSERT INTO roomService VALUES(3, 'ICU');
INSERT INTO roomService VALUES(3, 'ICU');


CREATE TABLE Equipment(
	typeID INTEGER PRIMARY KEY, 
	numberOfUnits INTEGER DEFAULT 0,
	model VARCHAR2(100), 
	eqDescr VARCHAR2(250), 
	instr VARCHAR2(1000)); 

INSERT INTO Equipment VALUES(1, 9, 'Sony', 'drill', 'be careful');
INSERT INTO Equipment VALUES(2, 29, 'Panasonic', 'light', 'be very careful');
INSERT INTO Equipment VALUES(3, 69, 'Samsung', 'stretcher', 'put person on stretcher');


CREATE TABLE Unit(
	serialNumber INTEGER PRIMARY KEY,
	yearOfPurchase INTEGER NOT NULL, 
	lastInspectionTime DATE,
	eqTypeID INTEGER FOREIGN KEY REFERENCES Equipment(typeID), 
	roomNumber INTEGER FOREIGN KEY REFERENCES Room(roomNumber)); 

INSERT INTO Unit VALUES(1000, 1994, TO_DATE('17/12/2015 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES(1001, 1995, TO_DATE('17/12/2017 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES(1002, 1996, TO_DATE('17/12/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'));


CREATE TABLE Patient(
	SSN INTEGER PRIMARY KEY,
	phoneNum INTEGER,
	firstName VARCHAR2(63),
	lastName VARCHAR2(63),
	addr VARCHAR2(127)); /*should addr be stored as str?*/

INSERT INTO Patient VALUES(123421234, 8671234567, 'James', 'Woods', '12 Olive St.');
INSERT INTO Patient VALUES(123421234, 8671234567, 'James', 'Woods', '12 Olive St.');
INSERT INTO Patient VALUES(123421234, 8671234567, 'James', 'Woods', '12 Olive St.');

CREATE TABLE Doctor(
	ID INTEGER PRIMARY KEY,
	speciality VARCHAR2(31),
	gender VARCHAR2(15),
	firstName VARCHAR2(63),
	lastName VARCHAR2(63));

INSERT INTO Doctor VALUES(1, 'psychology', 'male', 'David', 'ONeill');
INSERT INTO Doctor VALUES(2, 'psychology', 'female', 'David', 'ONeill');
INSERT INTO Doctor VALUES(3, 'psychology', 'male', 'David', 'ONeill');

/*NOTE: We simplified our previous model to match the Phase 1 Solution. We no longer have a separate PatientArrival table, 
and store the future date in the current appointment entry.*/
	
CREATE TABLE Appointment(
	AptID INTEGER PRIMARY KEY,
	totalPayment NUMBER(50, 2), 
	insuranceCoverage NUMBER(6,5), 
	patientSSN INTEGER FOREIGN KEY REFERENCES Patient(SSN),
	/*futureAptID INTEGER FOREIGN KEY REFERENCES Appointment(AptID),*/
	admissionDate DATETIME,
	leaveDate DATETIME, 
	futureAptDate DATETIME);

INSERT INTO Appointment VALUES(1, 100000, .50, 123421234, TO_DATE('17/12/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'),
 TO_DATE('17/12/2014 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('03/05/2015 11:30:00', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Appointment VALUES(2, 30000, .20, 123412345, TO_DATE('03/05/2015 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/05/2015 02:30:00', 'DD/MM/YYYY hh:mi:ss'), null);

CREATE TABLE AptRoom(
	aptID INTEGER FOREIGN KEY REFERENCES Appointment(AptID),
	roomNumber INTEGER FOREIGN KEY REFERENCES Room(roomNumber), 
	startDate DATE NOT NULL,
	endDate DATE,
	PRIMARY KEY(aptID, roomNumber, startDate));

INSERT INTO AptRoom VALUES(1, 1, TO_DATE('17/12/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('17/12/2014 12:33:37', 'DD/MM/YYYY hh:mi:ss'));


CREATE TABLE Examine(
	docID INTEGER FOREIGN KEY REFERENCES Doctor(ID),
	aptID INTEGER FOREIGN KEY REFERENCES Appointment(AptID),
	result VARCHAR2(63),
	PRIMARY KEY(docID, aptID));

INSERT INTO Examine VALUES(1, 1, 'hes dead');


/* PART 3 - POPULATE THE DATABASE*/

/*add more Employees*/

INSERT INTO Employee VALUES(300, 80000, 300, 'GeneralManager','Rodica', 'Neamtu', NULL);
INSERT INTO Employee VALUES(202, 120000, 202, 'DivisionManager','Trevor', 'Valcourt', 300);
INSERT INTO Employee VALUES(201, 110000, 201, 'DivisionManager','Ryan', 'Cooney', 300);
INSERT INTO Employee VALUES(200, 80000, 200, 'DivisionManager','Dan', 'Song', 300);
INSERT INTO Employee VALUES(102, 100000, 102, 'Regular','Robert', 'Scarduzio', 201);
INSERT INTO Employee VALUES(101, 70000, 101, 'Regular','Mike', 'Ross', 200);
INSERT INTO Employee VALUES(100, 80000, 100, 'Regular','Stan', 'Smith', 200);	 

SELECT * FROM Employee;

INSERT INTO Room VALUES(1, 0);
INSERT INTO Room VALUES(2, 1);
INSERT INTO Room VALUES(3, 1);
INSERT INTO Room VALUES(4, 0);
INSERT INTO Room VALUES(5, 0);
INSERT INTO Room VALUES(6, 0);
INSERT INTO Room VALUES(7, 1);
INSERT INTO Room VALUES(8, 1);
INSERT INTO Room VALUES(9, 0);
INSERT INTO Room VALUES(10, 0);

SELECT * FROM Room;

 
/* PART 2 - SQL QUERIES */

/*Q1: Report the hospital rooms (the room number) that are currently occupied. */
SELECT Room.roomNumber
FROM Room
WHERE occupied=1;

/*For a given division manager (say, ID = 10), report all regular employees 
that are supervised by this manager. Display the employees ID, names, and salary.*/
SELECT ID, firstName, lastName, salary
FROM Employee 
WHERE Employee.managerID = 10;



/*Report the number of visits done for each patient, 
i.e., for each patient, report the patient SSN, first and last names, and the count of visits done by this patient.*/  
SELECT P.SSN, P.firstName, P.lastName, COUNT(A.AptID) AS NumVisits
FROM Patient AS P, Appointment AS A
WHERE P.SSN = A.patientSSN
GROUP BY A.patientSSN;

/*Report the employee who has access to the largest number of rooms. 
We need the employee ID, and the number of rooms (s)he can access.
Note: If there are several employess with the same maximum number, then report all of these employees.*/
/*
SELECT cnt.empID, MAX(cnt.NumRooms) AS RoomCount
FROM
(
	SELECT A.empID, COUNT(A.RoomNumber) AS NumRooms
	FROM empAccess AS A
	GROUP BY A.empID
) AS cnt
WHERE cnt.NumRooms = MAX(NumRooms);
*/
SELECT A.empID
FROM empAccess AS A
GROUP BY A.empID
HAVING COUNT(A.RoomNumber) = MAX(COUNT(A.RoomNumber));

/* For patients who have a scheduled future visit (which is part of their most recent visit), report that patient 
(SSN, and first and last names) and the visit date. Do not report patients who do not have scheduled visit.*/

SELECT P.SSN, P.firstName, P.lastName, A.aptDate 
FROM Patient AS P, Appointment AS A
WHERE P.SSN = A.patientSSN AND A.futureAptID IS NOT NULL;

/*Q10: Report the date of the coming future visit for patient with SSN = 111-22-3333.
Note: This date should exist in the last (most recent) visit of that patient.*/
SELECT A.futureAptDate 
FROM Appointment AS A
WHERE A.patientSSN = 111223333;

/*Report the equipment types (only the ID) for which the hospital has purchased equipments (units)
 in both 2010 and 2011. Do not report duplication.*/
 SELECT DISTINCT E.typeID 
 FROM Equipment E, Unit U
 WHERE E.numberOfUnits > 0 AND U.eqTypeID = E.typeID AND U.yearOfPurchase = 2010
 INTERSECT 
 SELECT DISTINCT E.typeID
 FROM Equipment E, Unit U 
 WHERE E.numberOfUnits > 0 AND U.eqTypeID = E.typeID AND U.yearOfPurchase = 2011;