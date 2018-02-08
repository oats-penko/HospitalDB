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

CREATE TABLE Employee( 
	ID INTEGER PRIMARY KEY, 
	salary REAL DEFAULT 0, 
	officeNumber INTEGER NOT NULL, 
	jobTitle VARCHAR2(100),  
	firstName VARCHAR2(100),  
	lastName VARCHAR2(100), 
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
	model VARCHAR2(100),  
	eqDescr VARCHAR2(250),  
	instr VARCHAR2(1000) 
);

CREATE TABLE Unit( 
	serialNumber INTEGER PRIMARY KEY, 
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
	firstName VARCHAR2(63), 
	lastName VARCHAR2(63), 
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
	insuranceCoverage NUMBER(6,5),  
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

INSERT INTO Employee VALUES(100, 80000, 100, 'Regular','Stan', 'Smith', 200); /*add more Employees*/
INSERT INTO Employee VALUES(200, 80000, 200, 'DivisionManager','Dan', 'Song', 300);
INSERT INTO Employee VALUES(300, 80000, 300, 'GeneralManager','Rodica', 'Neamtu', NULL);

INSERT INTO Room VALUES(1, 0);
INSERT INTO Room VALUES(2, 1);
INSERT INTO Room VALUES(3, 1);
INSERT INTO Room VALUES(2, 1); /*add more rooms*/
INSERT INTO Room VALUES(2, 1);

INSERT INTO empAccess VALUES(100, 1);
INSERT INTO empAccess VALUES(101, 1);
INSERT INTO empAccess VALUES(200, 2);
INSERT INTO empAccess VALUES(200, 2);
INSERT INTO empAccess VALUES(300, 3);
INSERT INTO empAccess VALUES(300, 3);

INSERT INTO roomService VALUES(2, 'MRI'); /*add more services */
INSERT INTO roomService VALUES(2, 'OperatingRoom');
INSERT INTO roomService VALUES(1, 'EmergencyRoom');
INSERT INTO roomService VALUES(1, 'ICU');
INSERT INTO roomService VALUES(1, 'Bathroom');
INSERT INTO roomService VALUES(3, 'ICU');
INSERT INTO roomService VALUES(3, 'ICU');
INSERT INTO roomService VALUES(3, 'ICU');
INSERT INTO roomService VALUES(3, 'ICU');

INSERT INTO Equipment VALUES(1, 9, 'Sony', 'drill', 'be careful');
INSERT INTO Equipment VALUES(2, 29, 'Panasonic', 'light', 'be very careful');
INSERT INTO Equipment VALUES(3, 69, 'Samsung', 'stretcher', 'put person on stretcher');

INSERT INTO Unit VALUES(1000, 1994, TO_DATE('17/12/2015 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES(1001, 1995, TO_DATE('17/12/2017 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES(1002, 1996, TO_DATE('17/12/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'));

INSERT INTO Patient VALUES(123421234, 8671234567, 'James', 'Woods', '12 Olive St.');
INSERT INTO Patient VALUES(123421234, 8671234567, 'James', 'Woods', '12 Olive St.');
INSERT INTO Patient VALUES(123421234, 8671234567, 'James', 'Woods', '12 Olive St.');

INSERT INTO Doctor VALUES(1, 'psychology', 'male', 'David', 'ONeill');
INSERT INTO Doctor VALUES(2, 'psychology', 'female', 'David', 'ONeill');
INSERT INTO Doctor VALUES(3, 'psychology', 'male', 'David', 'ONeill');

INSERT INTO Appointment VALUES(1, 100000, .50, 123421234, TO_DATE('17/12/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'),
 TO_DATE('17/12/2014 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('03/05/2015 11:30:00', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Appointment VALUES(2, 30000, .20, 123412345, TO_DATE('03/05/2015 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/05/2015 02:30:00', 'DD/MM/YYYY hh:mi:ss'), null);

INSERT INTO AptRoom VALUES(1, 1, TO_DATE('17/12/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('17/12/2014 12:33:37', 'DD/MM/YYYY hh:mi:ss'));

INSERT INTO Examine VALUES(1, 1, 'hes dead');


/* PART 2 - SQL QUERIES*/

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
