CREATE TABLE Employee(
	ID INTEGER PRIMARY KEY,
	salary REAL DEFAULT 0,
	officeNumber INTEGER NOT NULL, 
	jobTitle VARCHAR2(100), /* add constraint to have the 3 types */
	firstName VARCHAR2(100), 
	lastName VARCHAR2(100), 
	managerID INTEGER FOREIGN KEY REFERENCES EMPLOYEE(ID));
CREATE TABLE Room(
	roomNumber INTEGER PRIMARY KEY, 
	occupied NUMBER(1)); /* add constraint to have 1 or 0 only */

CREATE TABLE empAccess(
	empID INTEGER, 
	roomNumber INTEGER NOT NULL,
	FOREIGN KEY (empID) REFERENCES Employee(ID), 
	FOREIGN KEY (roomNumber) REFERENCES Room(roomNumber),
	PRIMARY KEY (empID, roomNumber));

CREATE TABLE roomService(
	roomNumber INTEGER FOREIGN KEY REFERENCES Room(roomNumber), 
	rService VARCHAR2(100),
	PRIMARY KEY (roomNumber, rService)); 

CREATE TABLE Equipment(
	typeID INTEGER PRIMARY KEY, 
	numberOfUnits INTEGER DEFAULT 0,
	model VARCHAR2(100), 
	eqDescr VARCHAR2(250), 
	instr VARCHAR2(1000)); 

CREATE TABLE Unit(
	serialNumber INTEGER PRIMARY KEY,
	yearOfPurchase INTEGER NOT NULL, 
	lastInspectionTime DATE,
	eqTypeID INTEGER FOREIGN KEY REFERENCES Equipment(typeID), 
	roomNumber INTEGER FOREIGN KEY REFERENCES Room(roomNumber)); 

CREATE TABLE Patient(
	SSN INTEGER PRIMARY KEY,
	phoneNum INTEGER,
	firstName VARCHAR2(63),
	lastName VARCHAR2(63),
	address VARCHAR2(127)); /*should addr be stored as str?*/

CREATE TABLE Doctor(
	ID INTEGER PRIMARY KEY,
	speciality VARCHAR2(31),
	gender VARCHAR2(15),
	firstName VARCHAR2(63),
	lastName VARCHAR2(63));
	
CREATE TABLE Appointment(
	AptID INTEGER PRIMARY KEY,
	totalPayment NUMBER(50, 2), /*try to replace the magical number 50*/
	insuranceCoverage NUMBER(6,5), /*again use less magical of number; storing this percent as decimal*/
	patientSSN INTEGER FOREIGN KEY REFERENCES Patient(SSN),
	origAptID INTEGER PRIMARY KEY REFERENCES Appointment(ID),
	aptDate DATE);

CREATE TABLE AptRoom(
	aptID INTEGER FOREIGN KEY REFERENCES Appointment(AptID),
	roomNumber INTEGER FOREIGN KEY REFERENCES Room(roomNumber), 
	startDate DATE NOT NULL,
	endDate DATE,
	PRIMARY KEY(aptID, roomNumber, startDate));

CREATE TABLE Examine(
	docID INTEGER FOREIGN KEY REFERENCES Doctor(ID),
	aptID INTEGER FOREIGN KEY REFERENCES Appointment(AptID),
	result VARCHAR2(63),
	PRIMARY KEY(docID, aptID));
	 
CREATE TABLE PatientArrival(
	timeIn INTEGER,
	aptID INTEGER FOREIGN KEY REFERENCES Appointment(AptID),
	SSN INTEGER FOREIGN KEY REFERENCES Patient(SSN),
	timeLv INTEGER,
	PRIMARY KEY(timeIn, aptID, SSN)
	);