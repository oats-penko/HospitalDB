/* Phase 2
-----
Alissa Ostapenko 
Daniel Song */
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

/* PART 1 CREATING THE DATABASE */

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

/* PART 3 - POPULATE THE DATABASE */


INSERT INTO Employee VALUES(300, 80000, 300, 'GeneralManager','Rodica', 'Neamtu', NULL);
INSERT INTO Employee VALUES(301, 80000, 300, 'GeneralManager','Pablo', 'Picasso', NULL);
INSERT INTO Employee VALUES(302, 80000, 300, 'GeneralManager','Freddie', 'Mercury', NULL);

INSERT INTO Employee VALUES(200, 80000, 200, 'DivisionManager','Dan', 'Song', 300);
INSERT INTO Employee VALUES(201, 80000, 200, 'DivisionManager','Elaine', 'Smith', 300);
INSERT INTO Employee VALUES(202, 80000, 200, 'DivisionManager','David', 'Bowie', 300);
INSERT INTO Employee VALUES(203, 80000, 200, 'DivisionManager','Frida', 'Kahlo', 301);
INSERT INTO Employee VALUES(204, 80000, 200, 'DivisionManager','John', 'Lennon', 301);
INSERT INTO Employee VALUES(205, 80000, 200, 'DivisionManager','Margaret', 'Thatcher', 302);
INSERT INTO Employee VALUES(206, 120000, 202, 'DivisionManager','Trevor', 'Valcourt', 300);
INSERT INTO Employee VALUES(207, 110000, 201, 'DivisionManager','Ryan', 'Cooney', 300);
INSERT INTO Employee VALUES(208, 80000, 200, 'DivisionManager','Dan', 'Song', 300);

INSERT INTO Employee VALUES(100, 80000, 100, 'Regular','Stan', 'Smith', 200); 
INSERT INTO Employee VALUES(101, 80000, 100, 'Regular','Jackie', 'Chan', 200); 
INSERT INTO Employee VALUES(102, 80000, 100, 'Regular','Patrick', 'Star', 201); 
INSERT INTO Employee VALUES(103, 80000, 100, 'Regular','Robert', 'Sponge', 202); 
INSERT INTO Employee VALUES(104, 80000, 100, 'Regular','Julia', 'Roberts', 203); 
INSERT INTO Employee VALUES(105, 80000, 100, 'Regular','Meryl', 'Priest', 204); 
INSERT INTO Employee VALUES(106, 80000, 100, 'Regular','Daniella', 'Rodriguez', 205); 
INSERT INTO Employee VALUES(107, 80000, 100, 'Regular','Eric', 'Jones', 203); 
INSERT INTO Employee VALUES(108, 80000, 100, 'Regular','Sylvia', 'Jackson', 203); 
INSERT INTO Employee VALUES(109, 80000, 100, 'Regular','Jennifer', 'Michaels', 201); 
INSERT INTO Employee VALUES(110, 80000, 100, 'Regular','Alan', 'Poe', 202); 
INSERT INTO Employee VALUES(111, 80000, 100, 'Regular','Jack', 'London', 204); 
INSERT INTO Employee VALUES(112, 100000, 105, 'Regular','Toph', 'Aldenderfer', 201);
INSERT INTO Employee VALUES(113, 62000, 104, 'Regular','Mango', 'Marquez', 200);
INSERT INTO Employee VALUES(114, 50000, 103, 'Regular','Stan', 'Go', 200);	
INSERT INTO Employee VALUES(115, 100000, 102, 'Regular','Robert', 'Scarduzio', 201);
INSERT INTO Employee VALUES(116, 70000, 101, 'Regular','Mike', 'Ross', 200);
INSERT INTO Employee VALUES(117, 80000, 100, 'Regular','Stan', 'Smith', 200);

/* SELECT * FROM Employee; */

INSERT INTO Room VALUES(1,0);
INSERT INTO Room VALUES(2,1);
INSERT INTO Room VALUES(3,1);
INSERT INTO Room VALUES(4,0);
INSERT INTO Room VALUES(5,1);
INSERT INTO Room VALUES(6,1);
INSERT INTO Room VALUES(7,0);
INSERT INTO Room VALUES(8,0);
INSERT INTO Room VALUES(9,1);
INSERT INTO Room VALUES(10,0);
INSERT INTO Room VALUES(11,1);
INSERT INTO Room VALUES(100,0);
INSERT INTO Room VALUES(200,1);
INSERT INTO Room VALUES(300,1);

/* SELECT * FROM Room; */

INSERT INTO empAccess VALUES(100, 1);
INSERT INTO empAccess VALUES(100, 2);
INSERT INTO empAccess VALUES(200, 2);
INSERT INTO empAccess VALUES(300, 2);
INSERT INTO empAccess VALUES(300, 3);
INSERT INTO empAccess VALUES(101, 2);
INSERT INTO empAccess VALUES(102, 3);
INSERT INTO empAccess VALUES(103, 4);
INSERT INTO empAccess VALUES(104, 5);
INSERT INTO empAccess VALUES(105, 6);
INSERT INTO empAccess VALUES(106, 7);
INSERT INTO empAccess VALUES(107, 7);
INSERT INTO empAccess VALUES(108, 8);
INSERT INTO empAccess VALUES(109, 9);
INSERT INTO empAccess VALUES(110, 10);
INSERT INTO empAccess VALUES(111, 11);
INSERT INTO empAccess VALUES(300, 1);
INSERT INTO empAccess VALUES(300, 4);
INSERT INTO empAccess VALUES(301, 5);
INSERT INTO empAccess VALUES(301, 6);
INSERT INTO empAccess VALUES(301, 7);
INSERT INTO empAccess VALUES(301, 8);
INSERT INTO empAccess VALUES(302, 9);
INSERT INTO empAccess VALUES(302, 10);
INSERT INTO empAccess VALUES(302, 11);

/* SELECT * FROM empAccess; */

INSERT INTO roomService VALUES(2, 'MRI'); 
INSERT INTO roomService VALUES(2, 'OperatingRoom');
INSERT INTO roomService VALUES(1, 'EmergencyRoom');
INSERT INTO roomService VALUES(1, 'ICU');
INSERT INTO roomService VALUES(1, 'Bathroom');
INSERT INTO roomService VALUES(3, 'InformationCenter');
INSERT INTO roomService VALUES(3, 'WaitingArea');
INSERT INTO roomService VALUES(3, 'Bathroom');
INSERT INTO roomService VALUES(3, 'Cafe');
INSERT INTO roomService VALUES(4, 'MRI');
INSERT INTO roomService VALUES(5, 'X-Ray');
INSERT INTO roomService VALUES(6, 'OperatingRoom');
INSERT INTO roomService VALUES(7, 'Cafe');
INSERT INTO roomService VALUES(8, 'Nursery');
INSERT INTO roomService VALUES(9, 'CTScan');
INSERT INTO roomService VALUES(10, 'ICU');
INSERT INTO roomService VALUES(11, 'ServiceCloset');
INSERT INTO roomService VALUES(100, 'RegularOffice');
INSERT INTO roomService VALUES(200, 'DMOffice');
INSERT INTO roomService VALUES(300, 'GMOffice');

/* SELECT * FROM roomService; */

INSERT INTO Equipment VALUES(1, 9, 'Sony', 'drill', 'be careful');
INSERT INTO Equipment VALUES(2, 29, 'Panasonic', 'light', 'turn on');
INSERT INTO Equipment VALUES(3, 69, 'Samsung', 'stretcher', 'put person on stretcher');
INSERT INTO Equipment VALUES(4, 7, 'LRMN', 'CTScanner', 'press button');
INSERT INTO Equipment VALUES(5, 3, 'Original', 'X-Ray', 'scan body part');
INSERT INTO Equipment VALUES(6, 3, 'XII', 'CoffeMachine', 'brew coffee and enjoy');
INSERT INTO Equipment VALUES(7, 4, 'Digilent', 'potentiometer', 'plug into socket');
INSERT INTO Equipment VALUES(8, 10, 'Panasonic', 'cattle prod', 'not just for cattle');
INSERT INTO Equipment VALUES(9, 30, 'Samsung', 'syringe', 'poke poke');
INSERT INTO Equipment VALUES(10, 1, 'Samsung', 'tube', 'use');

/* SELECT * FROM Equipment; */

INSERT INTO Unit VALUES('1000', 1, 1, 1994, TO_DATE('17/12/2011 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('1001', 1, 2, 1995, TO_DATE('14/02/2010 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('1002', 1, 4, 1996, TO_DATE('10/10/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('2000', 2, 9, 1996, TO_DATE('01/01/2014 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('2001', 2, 11, 2011, TO_DATE('17/12/2011 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('2002', 2, 8, 2010, TO_DATE('17/12/2010 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('3000', 3, 7, 2011, TO_DATE('17/12/2017 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('3001', 3, 2, 2009, TO_DATE('04/12/2011 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('3002', 3, 3, 2003, TO_DATE('17/12/2010 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('4000', 4, 1, 2000, TO_DATE('13/11/2010 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('4001', 4, 5, 2008, TO_DATE('14/12/2010 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('4002', 4, 6, 2017, TO_DATE('17/10/2011 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('5000', 5, 3, 2017, TO_DATE('18/12/2017 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('5001', 5, 2, 2010, TO_DATE('17/12/2012 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('5002', 5, 10, 2011, TO_DATE('17/09/2010 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('6000', 6, 7, 2010, TO_DATE('17/12/2010 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('6001', 6, 3, 2011, TO_DATE('17/03/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('6002', 6, 8, 1986, TO_DATE('17/04/2011 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('A01-02X', 7, 1, 1994, TO_DATE('17/12/2015 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('B01-02X', 8, 2, 1995, TO_DATE('12/12/2017 12:03:17', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('C01-02X', 9, 3, 1996, TO_DATE('30/11/2014 12:13:35', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('A02-02X', 7, 3, 1999, TO_DATE('15/12/2015 12:23:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('B02-02X', 8, 4, 1993, TO_DATE('2/12/2017 11:37:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('C02-02X', 9, 4, 2010, TO_DATE('6/12/2013 12:32:36', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('A03-02X', 7, 5, 2011, TO_DATE('6/12/2015 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('B03-02X', 8, 5, 1995, TO_DATE('20/12/2016 11:23:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('C03-02X', 9, 5, 1990, TO_DATE('17/12/2013 12:13:57', 'DD/MM/YYYY hh:mi:ss'));

/* SELECT * FROM Unit */

INSERT INTO Patient VALUES(123421234, 8671234567, 'James', 'Woods', '12 Olive St.');
INSERT INTO Patient VALUES(111223333, 8671234561, 'Sarah', 'Burk', '111 Central St.');
INSERT INTO Patient VALUES(101208888, 8671234562, 'James', 'Snow', '12 Salisbury St.');
INSERT INTO Patient VALUES(354421234, 8671234563, 'Richard', 'Bennet', '3 Apricot Ln.');
INSERT INTO Patient VALUES(789421554, 8671234564, 'Samantha', 'Davids', '14 Dot Rd.');
INSERT INTO Patient VALUES(010421244, 8671234565, 'Joseph', 'Priestly', '10 Oliver Dr.');
INSERT INTO Patient VALUES(202421234, 8671234569, 'Thomas', 'Sawyer', '13 Juniper Rd.');
INSERT INTO Patient VALUES(605421664, 8671234223, 'Huckleberry', 'Finn', '10 Strawberry Ln.');
INSERT INTO Patient VALUES(304421202, 8671234123, 'Sheila', 'Jones', '6 Jackson St.');
INSERT INTO Patient VALUES(012421290, 8671234333, 'Jeremy', 'Rust', '17 Bridge St.');
INSERT INTO Patient VALUES(123428923, 8671234444, 'Stephen', 'Larsen', '10 Roger St.');
INSERT INTO Patient VALUES(111111234, 5081234567, 'David', 'Johnson', '2 Spruce St.');
INSERT INTO Patient VALUES(222334444, 3216540987, 'Kate', 'Shirley', '63 Starry St.');
INSERT INTO Patient VALUES(999887777, 1111111111, 'Ashley', 'Sawin', '16 Olive St.');
INSERT INTO Patient VALUES(987654321, 2222222222, 'Faye', 'Falco', '18 Olive St.');
INSERT INTO Patient VALUES(123123123, 3333333333, 'Sam', 'Woods', '31 Sylvester St.');

/* SELECT * FROM Patient; */


INSERT INTO Doctor VALUES(1, 'psychology', 'male', 'David', 'ONeill');
INSERT INTO Doctor VALUES(2, 'orthopedic', 'female', 'Julia', 'Jones');
INSERT INTO Doctor VALUES(3, 'surgery', 'male', 'Edward', 'Scissor');
INSERT INTO Doctor VALUES(4, 'endocrinology', 'female', 'Sylvia', 'Nelson');
INSERT INTO Doctor VALUES(5, 'neurology', 'male', 'Thomas', 'Pettigrew');
INSERT INTO Doctor VALUES(6, 'nutrition', 'female', 'Sarah', 'Davids');
INSERT INTO Doctor VALUES(7, 'pediatry', 'male', 'Oliver', 'Twist');
INSERT INTO Doctor VALUES(8, 'gynecology', 'female', 'Selena', 'Michaels');
INSERT INTO Doctor VALUES(9, 'radiology', 'male', 'James', 'Oliver');
INSERT INTO Doctor VALUES(10, 'cardiac', 'female', 'Ida', 'Smith');
INSERT INTO Doctor VALUES(11, 'pediatrician', 'female', 'J', 'D');
INSERT INTO Doctor VALUES(12, 'vivisection', 'male', 'Perry', 'Cox');
INSERT INTO Doctor VALUES(13, 'immunology', 'male', 'Christopher', 'Turk');
INSERT INTO Doctor VALUES(14, 'radiology', 'female', 'Elliot', 'Reid');
INSERT INTO Doctor VALUES(15, 'dissection', 'male', 'Bob', 'Kelso');
INSERT INTO Doctor VALUES(16, 'anasthesiologist', 'male', 'The', 'Todd');
INSERT INTO Doctor VALUES(17, 'internal medicine', 'female', 'Carla', 'Espinosa');
INSERT INTO Doctor VALUES(18, 'pediatrics', 'male', 'Drew', 'Suffin');
INSERT INTO Doctor VALUES(19, 'dance', 'male', 'Cole', 'Aaronson');

/* SELECT * FROM Doctor; */


INSERT INTO Appointment VALUES(1, 100000, 5000, 123421234, TO_DATE('17/12/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'),
TO_DATE('17/12/2014 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('03/05/2015 11:30:00', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Appointment VALUES(2, 30000, 20000, 123421234, TO_DATE('03/05/2015 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/05/2015 02:30:00', 'DD/MM/YYYY hh:mi:ss'), null);

INSERT INTO Appointment VALUES(3, 2020, 1000, 111223333, TO_DATE('03/05/2016 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/05/2018 02:30:00', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('04/05/2016 11:30:00', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Appointment VALUES(4, 100000, 5000, 111223333, TO_DATE('04/05/2016 11:30:00', 'DD/MM/YYYY hh:mi:ss'),
TO_DATE('04/06/2016 11:30:00', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('04/07/2016 11:30:00', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Appointment VALUES(5, 1000, 300, 111223333, TO_DATE('04/07/2016 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('09/07/2016 02:30:00', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('04/02/2017 11:30:00', 'DD/MM/YYYY hh:mi:ss'));



INSERT INTO Appointment VALUES(6, 200, 10, 304421202, TO_DATE('21/09/2015 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('21/01/2016 02:30:00', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('03/03/2016 11:30:00', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Appointment VALUES(7, 23481, 40, 304421202, TO_DATE('03/03/2016 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/06/2016 02:30:00', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('03/05/2017 11:30:00', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Appointment VALUES(8, 1002, 50, 304421202, TO_DATE('03/05/2017 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/05/2017 02:30:00', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('04/05/2018 11:30:00', 'DD/MM/YYYY hh:mi:ss'));

INSERT INTO Appointment VALUES(9, 3838, 1239, 789421554, TO_DATE('01/01/2010 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/03/2010 02:30:00', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('04/05/2013 11:30:00', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Appointment VALUES(10, 4000, 2000, 789421554, TO_DATE('04/05/2013 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/09/2013 02:30:00', 'DD/MM/YYYY hh:mi:ss'), null);

INSERT INTO Appointment VALUES(11, 5000, 2500, 202421234, TO_DATE('01/12/2015 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('09/12/2015 02:30:00', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('03/02/2016 11:30:00', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Appointment VALUES(12, 1802, 901, 202421234, TO_DATE('03/02/2016 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/02/2016 02:30:00', 'DD/MM/YYYY hh:mi:ss'), null);

INSERT INTO Appointment VALUES(13, 9000, 4500, 012421290, TO_DATE('05/05/2015 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/05/2016 02:30:00', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('03/09/2016 11:30:00', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Appointment VALUES(14, 8563, 4000, 012421290, TO_DATE('03/09/2016 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/09/2016 02:30:00', 'DD/MM/YYYY hh:mi:ss'), null);

INSERT INTO Appointment VALUES(15, 1314, 400, 101208888, TO_DATE('01/02/2015 08:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('01/02/2015 05:30:00', 'DD/MM/YYYY hh:mi:ss'), null);
INSERT INTO Appointment VALUES(16, 1872, 1000, 605421664, TO_DATE('03/05/2015 12:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/05/2015 09:30:00', 'DD/MM/YYYY hh:mi:ss'), null);
INSERT INTO Appointment VALUES(17, 1492, 800, 123428923, TO_DATE('01/09/2010 06:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/09/2010 10:30:00', 'DD/MM/YYYY hh:mi:ss'), null);
/* SELECT * FROM Appointment; */


INSERT INTO AptRoom VALUES(1, 1, TO_DATE('17/12/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('17/12/2014 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(2, 10, TO_DATE('17/12/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('17/12/2014 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(3, 2, TO_DATE('17/12/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('17/12/2014 12:33:37', 'DD/MM/YYYY hh:mi:ss'));

INSERT INTO Examine VALUES(1, 3, 'ok');
INSERT INTO Examine VALUES(2, 4, 'good vitals');
INSERT INTO Examine VALUES(2, 3, 'high blood pressure');
INSERT INTO Examine VALUES(2, 5, 'high blood sugar');
INSERT INTO Examine VALUES(8, 5, 'stable condition');
INSERT INTO Examine VALUES(8, 4, 'joint pain');
INSERT INTO Examine VALUES(8, 3, 'headache');
INSERT INTO Examine VALUES(9, 4, 'heartburn');
INSERT INTO Examine VALUES(9, 3, 'hyperactive');
INSERT INTO Examine VALUES(9, 5, 'fatigued');
INSERT INTO Examine VALUES(1, 5, 'dry eyes');
INSERT INTO Examine VALUES(1, 16, 'low blood pressure');
INSERT INTO Examine VALUES(1, 7, 'fast heart rate');
INSERT INTO Examine VALUES(10, 5, 'back pain');
INSERT INTO Examine VALUES(5, 6, 'back pain');
INSERT INTO Examine VALUES(3, 7, 'back pain');
INSERT INTO Examine VALUES(5, 4, 'joint pain');
INSERT INTO Examine VALUES(5, 5, 'joint pain');
INSERT INTO Examine VALUES(5, 16, 'joint pain');
INSERT INTO Examine VALUES(5, 7, 'joint pain');
INSERT INTO Examine VALUES(1, 6, 'arthritis');
INSERT INTO Examine VALUES(4, 8, 'doing well');
INSERT INTO Examine VALUES(6, 9, 'good reflexes');
INSERT INTO Examine VALUES(10, 10, 'doing well');
INSERT INTO Examine VALUES(9, 11, 'very stressed');
INSERT INTO Examine VALUES(5, 12, 'needs exercise');
INSERT INTO Examine VALUES(8, 13, 'back pain');
INSERT INTO Examine VALUES(2, 14, 'trouble breathing');
INSERT INTO Examine VALUES(3, 15, 'healthy blood pressure');
INSERT INTO Examine VALUES(4, 16, 'good heart rate');

/* Part 1 */
GO
CREATE OR REPLACE VIEW CriticalCases(Patient_SSN, firstName, lastName, numberOfAdmissionsToICU) AS 
	SELECT P.SSN, P.firstName, P.lastName, COUNT(*) as numberOfAdmissionsToICU
	FROM Patient P, (SELECT A.patientSSN as patientSSN, A.aptID as aptID
					FROM Appointment A
					WHERE A.aptID in (SELECT AptID FROM AptRoom A WHERE A.roomNumber in 
							(SELECT roomNumber FROM roomService WHERE rService = 'ICU'))) apts
	WHERE P.SSN = apts.patientSSN 
	GROUP BY P.SSN, P.firstName, P.lastName
	HAVING COUNT(*) > 1; 
	
SELECT * FROM CriticalCases;

GO


CREATE VIEW DoctorsLoad(DoctorID, gender, load) AS 
	(SELECT ID as DoctorID, gender, 'Underload' as load 
	FROM Doctor D, Examine E
	WHERE D.ID = E.docID
	GROUP BY  D.ID, D.gender
	HAVING COUNT(*) <= 10)
	UNION
	(SELECT ID as DoctorID, gender, 'Overload' as load 
	FROM Doctor D, Examine E
	WHERE D.ID = E.docID
	GROUP BY  D.ID, D.gender
	HAVING COUNT(*) > 10);
	
SELECT * FROM DoctorsLoad;

SELECT *
FROM CriticalCases
WHERE numberOfAdmissionsToICU > 4

SELECT DoctorID, firstName, lastName
FROM DoctorsLoad, Doctor
WHERE Doctor.ID = DoctorsLoad.DoctorID AND DoctorsLoad.gender = "female"

SELECT DL.DoctorID, Y.Patient_SSN, Y.cmnt
FROM DoctorsLoads DL, (SELECT X.Patient_SSN, E.cmnt, E.docID
						FROM Examine E, 
							(SELECT A.ID CC.Patient_SSN 
							FROM Appointment A, CriticalCases CC 
							WHERE A.patientSSN = CC.Patient_SSN) X
						WHERE X.ID = E.aptID) Y
WHERE DL.load = "underloaded" AND DL.DoctorID = Y.docID

CREATE OR REPLACE TRIGGER rServiceTrig
AFTER UPDATE OR INSERT ON RoomService
FOR EACH STATEMENT
BEGIN
	IF((SELECT count(*)
		FROM RoomService RS
		GROUP BY RS.roomNumber
		HAVING count(RS.rService) > 3) > 0)
		THEN RAISE_APPLICATION_ERROR (-20004, 'Rooms cannot have more than 3 services.');
	END IF;
END;
/


CREATE OR REPLACE TRIGGER insTrig
AFTER UPDATE OR INSERT ON Appointment
FOR EACH ROW
BEGIN
	:new.insuranceCoverage := :new.totalPayment * .7;
END;
/

CREATE OR REPLACE TRIGGER supervisorTrig
AFTER UPDATE OR INSERT OR DELETE ON Employee
FOR EACH ROW
DECLARE
	manID number;
	tRnk number;
	CURSOR Emp IS
		SELECT E.managerID, E.rnk
		FROM Employee E
		WHERE E.jobTitle != 'GeneralManager'
BEGIN
	OPEN Emp;
	LOOP
		FETCH Emp.managerID, Emp.rnk INTO manID, tRnk;
		FETCH 
		IF(manID is NULL) THEN RAISE_APPLICATION_ERROR (-20004, 'managerID cannot be null.');
		END IF;
		IF((SELECT count(*) FROM Employee E WHERE E.ID = manID) != 1)
			THEN RAISE_APPLICATION_ERROR (-20004, 'manager must exist.');
		END IF;
		IF((SELECT rnk FROM Employee E WHERE E.ID = manID) - tRnk != 1)
			THEN RAISE_APPLICATION_ERROR (-20004, 'Rank mismatch.');
		END IF;
	END LOOP;
	close Emp;
END;
/

CREATE OR REPLACE TRIGGER MRITrig
AFTER UPDATE OR INSERT ON Equipment, Unit
FOR EACH STATEMENT
BEGIN
	IF(SELECT *
		FROM Equipment E, Unit U
		WHERE E.ID = U.eqTypeID AND E.model = 'MRI' AND U.yearOfPurchase is not NULL AND U.yearOfPurchase > 2005)
		THEN RAISE_APPLICATION_ERROR (-20004, 'MRI YoP must be after 2005.');
	END IF;
END;
/