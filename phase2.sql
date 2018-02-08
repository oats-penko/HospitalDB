DROP TABLE roomService;
DROP TABLE empAccess;
DROP TABLE Examine;
DROP TABLE AptRoom;
DROP TABLE Unit;
DROP TABLE Employee;
DROP TABLE Room;
DROP TABLE Equipment;
DROP TABLE Appointment;
DROP TABLE Patient;
DROP TABLE Doctor;

/*PART 1 CREATING THE DATABASE */

CREATE TABLE Employee( 
	ID INTEGER PRIMARY KEY, 
	salary REAL DEFAULT 0, 
	officeNumber INTEGER NOT NULL, 
	jobTitle VARCHAR2(20),  
	firstName VARCHAR2(20),  
	lastName VARCHAR2(20), 
	managerID INTEGER, 
	CONSTRAINT manager_FK FOREIGN KEY (managerID) REFERENCES Employee(ID) 
	    ON DELETE CASCADE, 
	CONSTRAINT jobPsn CHECK (jobTitle in ('Regular', 'DivisionManager', 'GeneralManager')) 
);

CREATE TABLE Room( 
	roomNumber INTEGER PRIMARY KEY,  
	occupied NUMBER(1), 
	CONSTRAINT flag CHECK (occupied in (1,0)) 
);

CREATE TABLE empAccess( 
	empID INTEGER NOT NULL,  
	roomNumber INTEGER NOT NULL, 
	CONSTRAINT id_FK FOREIGN KEY (empID) REFERENCES Employee(ID) 
	   ON DELETE CASCADE, 
	CONSTRAINT room_FK FOREIGN KEY (roomNumber) REFERENCES Room(roomNumber) 
	   ON DELETE CASCADE,     
	CONSTRAINT access_PK PRIMARY KEY (empID, roomNumber) 
);

CREATE TABLE roomService( 
	roomNumber INTEGER,  
	rService VARCHAR2(100), 
	CONSTRAINT service_PK PRIMARY KEY (roomNumber, rService), 
	CONSTRAINT service_FK  FOREIGN KEY (roomNumber) REFERENCES Room(roomNumber) 
	    ON DELETE CASCADE 
);

CREATE TABLE Equipment ( 
	typeID INTEGER PRIMARY KEY,  
	numberOfUnits INTEGER DEFAULT 0, 
	model VARCHAR2(20),  
	eqDescr VARCHAR2(100),  
	instruct VARCHAR2(100) 
);

CREATE TABLE Unit( 
	serialNumber VARCHAR2(20) PRIMARY KEY, 
	eqTypeID INTEGER NOT NULL,  
	roomNumber INTEGER NOT NULL, 
	yearOfPurchase INTEGER NOT NULL,  
	lastInspectionTime DATE, 
	CONSTRAINT unitEID_FK FOREIGN KEY (eqTypeID) REFERENCES Equipment(typeID) 
	    ON DELETE CASCADE,  
	CONSTRAINT unitRoom_FK FOREIGN KEY (roomNumber) REFERENCES Room(roomNumber) 
	    ON DELETE CASCADE 
);

CREATE TABLE Patient( 
	SSN INTEGER PRIMARY KEY, 
	phoneNum INTEGER, 
	firstName VARCHAR2(20), 
	lastName VARCHAR2(20), 
	addr VARCHAR2(127) 
);

CREATE TABLE Doctor( 
	ID INTEGER PRIMARY KEY, 
	speciality VARCHAR2(31), 
	gender VARCHAR2(15), 
	firstName VARCHAR2(63), 
	lastName VARCHAR2(63) 
);

CREATE TABLE Appointment( 
	AptID INTEGER PRIMARY KEY, 
	totalPayment NUMBER(38, 2),  
	insuranceCoverage NUMBER(38,2),  
	patientSSN INTEGER NOT NULL, 
	/*futureAptID INTEGER FOREIGN KEY REFERENCES Appointment(AptID),*/ 
	admissionDate TIMESTAMP, 
	leaveDate TIMESTAMP,  
	futureAptDate TIMESTAMP, 
	CONSTRAINT patient_FK FOREIGN KEY (patientSSN) REFERENCES Patient(SSN) 
	    ON DELETE CASCADE 
);

CREATE TABLE AptRoom( 
	aptID INTEGER NOT NULL,   
	roomNumber INTEGER NOT NULL,  
	startDate DATE NOT NULL, 
	endDate DATE NOT NULL, 
	CONSTRAINT aptRoom_PK PRIMARY KEY(aptID, roomNumber, startDate), 
	CONSTRAINT aptID_FK FOREIGN KEY (aptID) REFERENCES Appointment(AptID) 
	    ON DELETE CASCADE, 
    CONSTRAINT roomNum_FK FOREIGN KEY (roomNumber) REFERENCES Room(roomNumber) 
        ON DELETE CASCADE 
);

CREATE TABLE Examine( 
	docID INTEGER NOT NULL, 
	aptID INTEGER NOT NULL, 
	result VARCHAR2(63), 
	CONSTRAINT doctor_FK FOREIGN KEY (docID) REFERENCES Doctor(ID) 
	    ON DELETE CASCADE, 
	CONSTRAINT exAptID_FK FOREIGN KEY (aptID) REFERENCES Appointment(AptID) 
		ON DELETE CASCADE, 
	CONSTRAINT examine_PK PRIMARY KEY(docID, aptID) 
);

/* PART 3 - POPULATE THE DATABASE*/

/*add more Employees*/

INSERT INTO Employee VALUES(300, 80000, 300, 'GeneralManager','Rodica', 'Neamtu', NULL);
INSERT INTO Employee VALUES(202, 120000, 202, 'DivisionManager','Trevor', 'Valcourt', 300);
INSERT INTO Employee VALUES(201, 110000, 201, 'DivisionManager','Ryan', 'Cooney', 300);
INSERT INTO Employee VALUES(200, 80000, 200, 'DivisionManager','Dan', 'Song', 300);
INSERT INTO Employee VALUES(105, 100000, 105, 'Regular','Toph', 'Aldenderfer', 201);
INSERT INTO Employee VALUES(104, 62000, 104, 'Regular','Mango', 'Marquez', 200);
INSERT INTO Employee VALUES(103, 50000, 103, 'Regular','Stan', 'Go', 200);	
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

INSERT INTO empAccess VALUES(100, 1);
INSERT INTO empAccess VALUES(100, 2);
INSERT INTO empAccess VALUES(200, 2);
INSERT INTO empAccess VALUES(300, 2);
INSERT INTO empAccess VALUES(300, 3);
INSERT INTO empAccess VALUES(300, 3);

SELECT * FROM empAccess;

INSERT INTO roomService VALUES(2, 'MRI'); 
INSERT INTO roomService VALUES(2, 'OperatingRoom');
INSERT INTO roomService VALUES(1, 'EmergencyRoom');
INSERT INTO roomService VALUES(1, 'ICU');
INSERT INTO roomService VALUES(1, 'Bathroom');
INSERT INTO roomService VALUES(3, 'ICU');

SELECT * FROM roomService;

INSERT INTO Equipment VALUES(1, 9, 'Sony', 'drill', 'be careful');
INSERT INTO Equipment VALUES(2, 29, 'Panasonic', 'light', 'be very careful');
INSERT INTO Equipment VALUES(3, 69, 'Samsung', 'stretcher', 'put person on stretcher');
INSERT INTO Equipment VALUES(4, 4, 'Digilent', 'potentiometer', 'plug into socket');
INSERT INTO Equipment VALUES(5, 10, 'Panasonic', 'cattle prod', 'not just for cattle');
INSERT INTO Equipment VALUES(6, 30, 'Samsung', 'syringe', 'poke poke');
INSERT INTO Equipment VALUES(7, 1, 'Samsung', 'tube', 'use');

SELECT * FROM Equipment;

INSERT INTO Unit VALUES('A01-02X', 1, 1, 1994, TO_DATE('17/12/2015 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('B01-02X', 2, 2, 1995, TO_DATE('12/12/2017 12:03:17', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('C01-02X', 3, 3, 1996, TO_DATE('30/11/2014 12:13:35', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('A02-02X', 1, 3, 1999, TO_DATE('15/12/2015 12:23:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('B02-02X', 2, 4, 1993, TO_DATE('2/12/2017 11:37:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('C02-02X', 3, 4, 2010, TO_DATE('6/12/2013 12:32:36', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('A03-02X', 1, 5, 2011, TO_DATE('6/12/2015 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('B03-02X', 2, 5, 1995, TO_DATE('20/12/2016 11:23:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('C03-02X', 3, 5, 1990, TO_DATE('17/12/2013 12:13:57', 'DD/MM/YYYY hh:mi:ss'));

SELECT * FROM Unit;

INSERT INTO Patient VALUES(123421234, 8671234567, 'James', 'Woods', '12 Olive St.');
INSERT INTO Patient VALUES(111111234, 5081234567, 'David', 'Johnson', '2 Spruce St.');
INSERT INTO Patient VALUES(111223333, 9876543210, 'Drew', 'Sonjohn', '16 Sparrow St.');
INSERT INTO Patient VALUES(222334444, 3216540987, 'Kate', 'Shirley', '63 Starry St.');
INSERT INTO Patient VALUES(999887777, 1111111111, 'Ashley', 'Sawin', '16 Olive St.');
INSERT INTO Patient VALUES(987654321, 2222222222, 'Faye', 'Falco', '18 Olive St.');
INSERT INTO Patient VALUES(123123123, 3333333333, 'Sam', 'Woods', '31 Sylvester St.');

SELECT * FROM Patient;

INSERT INTO Doctor VALUES(1, 'psychology', 'male', 'David', 'ONeill');
INSERT INTO Doctor VALUES(2, 'pediatrician', 'female', 'J', 'D');
INSERT INTO Doctor VALUES(3, 'vivisection', 'male', 'Perry', 'Cox');
INSERT INTO Doctor VALUES(4, 'immunology', 'male', 'Christopher', 'Turk');
INSERT INTO Doctor VALUES(5, 'radiology', 'female', 'Elliot', 'Reid');
INSERT INTO Doctor VALUES(6, 'dissection', 'male', 'Bob', 'Kelso');
INSERT INTO Doctor VALUES(7, 'anasthesiologist', 'male', 'The', 'Todd');
INSERT INTO Doctor VALUES(8, 'internal medicine', 'female', 'Carla', 'Espinosa');
INSERT INTO Doctor VALUES(9, 'pediatrics', 'male', 'Drew', 'Suffin');
INSERT INTO Doctor VALUES(10, 'dance', 'male', 'Cole', 'Aaronson');

SELECT * FROM Doctor;

INSERT INTO Appointment VALUES(1, 100000, 5000, 123421234, TO_DATE('17/12/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'),
TO_DATE('17/12/2014 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('03/05/2015 11:30:00', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Appointment VALUES(2, 30000, 20000, 123421234, TO_DATE('03/05/2015 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/05/2015 02:30:00', 'DD/MM/YYYY hh:mi:ss'), null);

SELECT * FROM Appointment;

INSERT INTO AptRoom VALUES(1, 1, TO_DATE('17/12/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('17/12/2014 12:33:37', 'DD/MM/YYYY hh:mi:ss'));

INSERT INTO Examine VALUES(1, 1, 'hes dead');

 
/* PART 2 - SQL QUERIES */

/*Q1: Report the hospital rooms (the room number) that are currently occupied. */
SELECT Room.roomNumber
FROM Room
WHERE occupied=1;

/*Q2: For a given division manager (say, ID = 10), report all regular employees 
that are supervised by this manager. Display the employees ID, names, and salary.*/
SELECT ID, firstName, lastName, salary
FROM Employee 
WHERE Employee.managerID = 10;

/*Q3: For each patient, report the sum of amounts paid by the insurance company for
that patient, i.e., report the patients SSN, and the sum of insurance payments over all
visits.*/

SELECT Appointment.patientSSN, sum(Appointment.insuranceCoverage) AS insuranceSum
FROM Appointment
GROUP BY Appointment.patientSSN;

/* Q4: Report the number of visits done for each patient, 
i.e., for each patient, report the patient SSN, first and last names, and the count of visits done by this patient.*/  
SELECT P.SSN, P.firstName, P.lastName, COUNT(A.AptID) AS NumVisits
FROM Patient AS P, Appointment AS A
WHERE P.SSN = A.patientSSN
GROUP BY A.patientSSN;

/*Q5: Report the room number that has an equipment unit with serial number ‘A01-02X’.*/

SELECT Unit.roomNumber
FROM Unit
WHERE Unit.serialNumber = 'A01-02X';

/*Q6: Report the employee who has access to the largest number of rooms. 
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

/*Q7: Report the number of regular employees, division managers, and general
managers in the hospital. */

SELECT Employee.jobTitle, count(Employee.ID) AS CNT
FROM Employee
GROUP BY Employee.jobTitle;

/*Q8: For patients who have a scheduled future visit (which is part of their most recent visit), report that patient 
(SSN, and first and last names) and the visit date. Do not report patients who do not have scheduled visit.*/

SELECT P.SSN, P.firstName, P.lastName, A.aptDate 
FROM Patient AS P, Appointment AS A
WHERE P.SSN = A.patientSSN AND A.futureAptID IS NOT NULL;

/*Q9: For each equipment type that has more than 3 units, report the equipment type ID,
model, and the number of units this type has. */

SELECT Equipment.typeID, Equipment.model, Equipment.numberOfUnits
FROM Equipment
WHERE Equipment.numberOfUnits > 3;

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
