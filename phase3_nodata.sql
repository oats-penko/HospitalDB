/* Phase 3
-----
Alissa Ostapenko 
Daniel Song */
spool phase3_out.txt
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
	jobTitle INTEGER NOT NULL,  
	firstName VARCHAR2(20),  
	lastName VARCHAR2(20), 
	managerID INTEGER, 
	CONSTRAINT manager_FK FOREIGN KEY (managerID) REFERENCES Employee(ID) 
	    ON DELETE CASCADE, 
	CONSTRAINT jobPsn CHECK (jobTitle in (0, 1, 2)) 
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
	typeID VARCHAR2(30) PRIMARY KEY,  
	numberOfUnits INTEGER DEFAULT 0, 
	model VARCHAR2(20),  
	eqDescr VARCHAR2(100),  
	instruct VARCHAR2(100) 
);

CREATE TABLE Unit( 
	serialNumber VARCHAR2(20) PRIMARY KEY, 
	eqtypeID VARCHAR2(30) NOT NULL,  
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
	lastName VARCHAR2(63), 
	CONSTRAINT genderVals CHECK (gender in ('female', 'male', 'other'))
);

CREATE TABLE Appointment( 
	AptID INTEGER PRIMARY KEY, 
	totalPayment NUMBER(38, 2),  
	insuranceCoverage NUMBER(38,2),  
	patientSSN INTEGER NOT NULL, 
	admissionDate DATE, 
	leaveDate DATE,  
	futureAptDate DATE, 
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


INSERT INTO roomService VALUES(2, 'MRI'); 
INSERT INTO roomService VALUES(2, 'OperatingRoom');
INSERT INTO roomService VALUES(2, 'Bathrrom');
INSERT INTO roomService VALUES(1, 'EmergencyRoom');
INSERT INTO roomService VALUES(1, 'ICU');
INSERT INTO roomService VALUES(1, 'Bathroom');
INSERT INTO roomService VALUES(3, 'InformationCenter');
INSERT INTO roomService VALUES(3, 'WaitingArea');
INSERT INTO roomService VALUES(3, 'Bathroom');


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



INSERT INTO Appointment VALUES(1, 100000, 5000, 123421234, TO_DATE('01/01/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'),
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
INSERT INTO Appointment VALUES(18, 2919, 50, 304421202, TO_DATE('03/05/2018 11:30:00', 'DD/MM/YYYY hh:mi:ss'), 
TO_DATE('03/05/2018 02:30:00', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('04/05/2018 11:30:00', 'DD/MM/YYYY hh:mi:ss'));


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


INSERT INTO AptRoom VALUES(1, 1, TO_DATE('17/01/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('17/01/2014 12:40:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(1, 1, TO_DATE('17/02/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('17/02/2014 12:40:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(1, 1, TO_DATE('17/03/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('17/03/2014 12:40:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(1, 1, TO_DATE('17/04/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('17/04/2014 12:40:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(1, 1, TO_DATE('17/05/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('17/05/2014 12:50:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(6, 1, TO_DATE('17/05/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('17/05/2014 12:50:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(7, 1, TO_DATE('18/05/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('17/05/2014 12:50:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(8, 1, TO_DATE('19/05/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('18/05/2014 12:50:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(8, 1, TO_DATE('20/05/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('20/05/2014 12:50:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(6, 1, TO_DATE('21/05/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('22/05/2014 12:50:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(3, 1, TO_DATE('23/05/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('23/05/2014 12:50:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(4, 1, TO_DATE('24/05/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('24/05/2014 12:50:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(14, 1, TO_DATE('24/05/2014 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('24/05/2015 12:50:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO AptRoom VALUES(14, 4, TO_DATE('24/05/2018 12:33:37', 'DD/MM/YYYY hh:mi:ss'), TO_DATE('24/05/2018 12:50:37', 'DD/MM/YYYY hh:mi:ss'));






/* doctor David O'Neill and Julia Jones should be overloaded */
INSERT INTO Examine VALUES(1, 1, 'ok');
INSERT INTO Examine VALUES(1, 2, 'ok');
INSERT INTO Examine VALUES(1, 3, 'ok');
INSERT INTO Examine VALUES(1, 4, 'ok');
INSERT INTO Examine VALUES(1, 5, 'ok');
INSERT INTO Examine VALUES(1, 6, 'ok');
INSERT INTO Examine VALUES(1, 7, 'ok');
INSERT INTO Examine VALUES(1, 8, 'ok');
INSERT INTO Examine VALUES(1, 9, 'ok');
INSERT INTO Examine VALUES(1, 10, 'ok');
INSERT INTO Examine VALUES(1, 11, 'ok');

INSERT INTO Examine VALUES(2, 1, 'good vitals');
INSERT INTO Examine VALUES(2, 2, 'good vitals');
INSERT INTO Examine VALUES(2, 3, 'high blood pressure');
INSERT INTO Examine VALUES(2, 4, 'high blood sugar');
INSERT INTO Examine VALUES(2, 6, 'stable condition');
INSERT INTO Examine VALUES(2, 7, 'good vitals');
INSERT INTO Examine VALUES(2, 8, 'good vitals');
INSERT INTO Examine VALUES(2, 9, 'good vitals');
INSERT INTO Examine VALUES(2, 10, 'good vitals');
INSERT INTO Examine VALUES(2, 11, 'good vitals');
INSERT INTO Examine VALUES(2, 12, 'good vitals');

INSERT INTO Examine VALUES(8, 1, 'joint pain');
INSERT INTO Examine VALUES(8, 2, 'joint pain');
INSERT INTO Examine VALUES(8, 3, 'joint pain');
INSERT INTO Examine VALUES(8, 4, 'joint pain');
INSERT INTO Examine VALUES(8, 5, 'joint pain');
INSERT INTO Examine VALUES(8, 6, 'joint pain');
INSERT INTO Examine VALUES(8, 7, 'joint pain');
INSERT INTO Examine VALUES(8, 8, 'joint pain');
INSERT INTO Examine VALUES(8, 9, 'joint pain');
INSERT INTO Examine VALUES(8, 10, 'headache');
INSERT INTO Examine VALUES(8, 14, 'headache');

INSERT INTO Examine VALUES(9, 4, 'heartburn');
INSERT INTO Examine VALUES(9, 3, 'hyperactive');
INSERT INTO Examine VALUES(9, 5, 'fatigued');
INSERT INTO Examine VALUES(9, 1, 'fatigued');
INSERT INTO Examine VALUES(18, 5, 'back pain');
INSERT INTO Examine VALUES(3, 5, 'heartburn');



INSERT INTO Examine VALUES(10, 5, 'back pain');
INSERT INTO Examine VALUES(5, 6, 'back pain');
INSERT INTO Examine VALUES(3, 7, 'back pain');
INSERT INTO Examine VALUES(5, 4, 'joint pain');
INSERT INTO Examine VALUES(5, 5, 'joint pain');
INSERT INTO Examine VALUES(5, 16, 'joint pain');
INSERT INTO Examine VALUES(5, 7, 'joint pain');
INSERT INTO Examine VALUES(4, 8, 'doing well');
INSERT INTO Examine VALUES(6, 9, 'good reflexes');
INSERT INTO Examine VALUES(10, 10, 'doing well');
INSERT INTO Examine VALUES(9, 11, 'very stressed');
INSERT INTO Examine VALUES(5, 12, 'needs exercise');
INSERT INTO Examine VALUES(8, 13, 'back pain');
INSERT INTO Examine VALUES(3, 15, 'healthy blood pressure');
INSERT INTO Examine VALUES(4, 16, 'good heart rate');

/* Part 1 */
CREATE OR REPLACE VIEW CriticalCases(Patient_SSN, firstName, lastName, numberOfAdmissionsToICU) AS  
	SELECT q.patientSSN, P.firstName, p.lastName, q.numberOfAdmissionsToICU
	FROM Patient P, 
	(SELECT A.patientSSN, COUNT(*) as numberOfAdmissionsToICU
	from Appointment A,
	(SELECT AptID FROM AptRoom A WHERE A.roomNumber in  
								(SELECT roomNumber FROM roomService WHERE rService = 'ICU')) q
	WHERE A.AptID = q.AptID
	GROUP BY patientSSN) q
	WHERE q.patientSSN = P.SSN AND q.numberOfAdmissionsToICU >= 2;


/* SHOULD HAVE 123421234, 304421202, 111223333 */
SELECT * FROM CriticalCases;

CREATE OR REPLACE VIEW DoctorsLoad(DoctorID, gender, load) AS  
	(SELECT D.ID as DoctorID, D.gender, 'Underloaded' as load  
	FROM Doctor D,
        (SELECT D.ID
        FROM Doctor D,Examine E 
	   WHERE D.ID = E.docID 
	    GROUP BY  D.ID  
	    HAVING COUNT(*) <= 10) c
	WHERE D.ID = c.ID)
	UNION 
	(SELECT D.ID as DoctorID, D.gender, 'Overloaded' as load  
	FROM Doctor D,
        (SELECT D.ID
        FROM Doctor D,Examine E 
	   WHERE D.ID = E.docID 
	    GROUP BY  D.ID  
	    HAVING COUNT(*) >= 10) c
	WHERE D.ID = c.ID);

/* PART  1 */

/* Use the views created above (you may need the original tables as well) to report the critical-case patients with number of admissions to ICU greater than 4. */ 
/* SHOULD HAVE 123421234, 304421202 */

SELECT C.Patient_SSN, C.firstName, C.lastname 
FROM CriticalCases C
WHERE C.numberOfAdmissionsToICU > 4;

/* Use the views created above (you may need the original tables as well) to report the female overloaded doctors. You should report the doctor ID, firstName, and lastName. */
SELECT L.DoctorID, D.firstName, D.lastName 
FROM DoctorsLoad L, Doctor D
WHERE L.gender = 'female' AND L.load = 'Overloaded' L.DoctorID = D.ID;

 /* Use the views created above (you may need the original tables as well) to report the comments 
 inserted by underloaded doctors when examining critical-case patients. You should report the doctor Id, patient SSN, and the comment. */
 SELECT d.DoctorID, c.patientSSN, d.result
 FROM 
 (SELECT D.DoctorID, E.result, E.aptID
 FROM DoctorsLoad D, Examine E
 WHERE E.docID = D.DoctorID AND D.load = 'Underloaded') d,
(SELECT A.AptID, A.patientSSN
 FROM Appointment A 
 WHERE A.patientSSN in (SELECT C.Patient_SSN FROM CriticalCases C)) c
WHERE d.aptID = c.AptID; 

/* PART 2 */
/*
-Any room in the hospital cannot offer more than three services.
-The insurance payment should be calculated automatically as 70% of the total payment. If the total payment changes then the insurance amount should also change.
o If in your DB you store the insurance payment as a percent, then it should be always set to 70%.
-Ensure that regular employees (with rank 0) must have their supervisors as division managers (with rank 1). Also each regular employee must have a supervisor at all times.
-Similarly, division managers (with rank 1) must have their supervisors as general managers (with rank 2). Division managers must have supervisors at all times.
-When a patient is admitted to ICU room on date D, the futureVisitDate should be automatically set to 3 months after that date, i.e., D + 3 months. The futureVisitDate may be manually changed later, but when the ICU admission happens, the date should be set to default as mentioned above.
-If an equipment of type ‘MRI’, then the purchase year must be not null and after 2005.
-When a patient is admitted to the hospital, i.e., a new record is inserted into the Admission table; the system should print out the names of the doctors who previously examined this patient (if any).
o Hint: Use function dbms_output.put_line() also make sure to run the following line so you can see the output lines.
Sql> set serveroutput on;
*/

/* Any room in the hospital cannot offer more than three services. */
CREATE OR REPLACE TRIGGER roomServices 
	BEFORE INSERT OR UPDATE ON roomService
	FOR EACH ROW
DECLARE 
	numServices int;
BEGIN 
    SELECT COUNT(*) into numServices
    FROM roomService R
    WHERE R.roomNumber = :new.roomNumber;
    IF numServices = 3 THEN
        RAISE_APPLICATION_ERROR(-20345, 'Room already has 3 services.');
    END IF;
END;
/

/* -The insurance payment should be calculated automatically as 70% of the total payment. If the total payment changes then the insurance amount should also change.
o If in your DB you store the insurance payment as a percent, then it should be always set to 70%. */
CREATE OR REPLACE TRIGGER insurance 
	BEFORE INSERT OR UPDATE ON Appointment
	FOR EACH ROW
BEGIN 
    :new.insuranceCoverage := :new.totalPayment * 0.7; 
END;
/

/* 
-Ensure that regular employees (with rank 0) must have their supervisors as division managers (with rank 1). Also each regular employee must have a supervisor at all times.
-Similarly, division managers (with rank 1) must have their supervisors as general managers (with rank 2). Division managers must have supervisors at all times.
*/
CREATE OR REPLACE TRIGGER empManager 
	BEFORE INSERT OR UPDATE ON Employee
	FOR EACH ROW
	WHEN (new.jobTitle < 2)
	DECLARE 
	    managerTitle int;
BEGIN 
    IF :new.managerID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'This employee must have a supervisor.');
    ELSE
		SELECT E.jobTitle INTO managerTitle FROM Employee E WHERE E.ID = :new.managerID;
		IF :new.jobTitle = 0 AND managerTitle != 1 THEN
			RAISE_APPLICATION_ERROR(-20002, 'Regular employees must be supervised by a Division Manager.');
		ELSIF :new.jobTitle = 1 AND managerTitle != 2 THEN
			RAISE_APPLICATION_ERROR(-20003, 'Division managers must be supervised by a General Manager.');
		END IF;
    END IF;
END;
/

/* -If an equipment of type ‘MRI’, then the purchase year must be not null and after 2005. */
CREATE OR REPLACE TRIGGER MRIPurchase 
	BEFORE INSERT ON Unit
	FOR EACH ROW
	WHEN (new.eqTypeID = 'MRI')
BEGIN 
    IF (:new.yearOfPurchase IS NULL) THEN
        RAISE_APPLICATION_ERROR(-20120, 'Year of purchase cannot be null');
    ELSE 
        IF :new.yearOfPurchase <= 2005 THEN
            RAISE_APPLICATION_ERROR(-20121, 'Year of purchase must be after 2005');
        END IF;
    END IF;
END;
/
/* -When a patient is admitted to ICU room on date D, the futureVisitDate should be automatically set to 3 months after that date, 
i.e., D + 3 months. The futureVisitDate may be manually changed later, but when the ICU admission happens, the date should be set to default as mentioned above.
*/
CREATE OR REPLACE TRIGGER futureVisitDate   
	BEFORE INSERT ON AptRoom  
	FOR EACH ROW  
	DECLARE 
	    service VARCHAR(20);
BEGIN   
    SELECT S.rService INTO service FROM roomService S WHERE S.roomNumber = :new.roomNumber;
    if (service = 'ICU') THEN
        UPDATE Appointment A   
        SET A.futureAptDate = ADD_MONTHS(:new.startDate, 3) 
        WHERE A.AptID = :new.aptID;  
    END IF;     
      
END;
/
/* -When a patient is admitted to the hospital, i.e., a new record is inserted into the Admission table; the system 
should print out the names of the doctors who previously examined this patient (if any).
o Hint: Use function dbms_output.put_line() also make sure to run the following line so you can see the output lines. */

CREATE OR REPLACE TRIGGER newAdmission 
	AFTER INSERT ON Appointment
	FOR EACH ROW
	DECLARE 
	    SSN int;
	    
	    CURSOR allApts(patientSSN INTEGER) IS 
	        SELECT AptID
	        FROM Appointment A
	        WHERE A.patientSSN = patientSSN;
	     
	    CURSOR allDocs(aptID INTEGER) IS
	        SELECT D.firstName, D.lastName
	        FROM Doctor D
	        WHERE D.ID IN (SELECT E.docID FROM Examine E WHERE E.aptID = aptID)
	        ORDER BY D.lastName, D.firstName;
	
BEGIN 

    SELECT A.patientSSN INTO SSN FROM Appointment A WHERE A.AptID = :new.AptID;
	
    FOR apt IN allApts(SSN) Loop
        FOR doc IN allDocs(apt.AptID) Loop
            DBMS_OUTPUT.PUT_LINE ('Name: ' || doc.LastName || ', ' || doc.firstName);
        END LOOP;
    END LOOP;
	
    
END;
/


INSERT INTO Employee VALUES(300, 80000, 300, 2,'Rodica', 'Neamtu', NULL);
INSERT INTO Employee VALUES(301, 80000, 300, 2,'Pablo', 'Picasso', NULL);
INSERT INTO Employee VALUES(302, 80000, 300, 2,'Freddie', 'Mercury', NULL);

INSERT INTO Employee VALUES(200, 80000, 200, 1,'Dan', 'Song', 300);
INSERT INTO Employee VALUES(202, 80000, 200, 1,'David', 'Bowie', 300);
/* Should return an error because manager is not a General Manager */ 
INSERT INTO Employee VALUES(206, 120000, 202, 1,'Trevor', 'Valcourt', 200); 
/* Should return an error because manager field is NULL */
INSERT INTO Employee VALUES(207, 110000, 201, 1,'Ryan', 'Cooney', NULL);

INSERT INTO Employee VALUES(100, 80000, 100, 0,'Stan', 'Smith', 200); 
INSERT INTO Employee VALUES(102, 80000, 100, 0,'Patrick', 'Star', 201);
/* Should return an error because manager is not a Division Manager */ 
INSERT INTO Employee VALUES(103, 80000, 100, 0,'Robert', 'Sponge', 301);
/* Should return an error because manager field is NULL */ 
INSERT INTO Employee VALUES(104, 80000, 100, 0,'Julia', 'Roberts', NULL); 
INSERT INTO Employee VALUES(105, 80000, 100, 0,'Meryl', 'Streep', 204); 

/* SHOULD RETURN AN ERROR, can't change Div Manager to be managed by another Div Manager: */
UPDATE Employee
SET managerID = 200 
WHERE ID = 200;

/* SHOULD RETURN AN ERROR, every employee must have a manager: */
UPDATE Employee
SET managerID = NULL 
WHERE ID = 100;
/* should return error, not managed by a Division Manager */ 
UPDATE Employee
SET managerID = 300 
WHERE ID = 100;

/* SHOULD RETURN AN ERROR, every employee must have a manager: */
UPDATE Employee
SET managerID = NULL 
WHERE ID = 200;

/* TEST TRIGGERS: */


/* Should throw an error: */
INSERT INTO roomService VALUES(3, 'Cafe');


INSERT INTO Equipment VALUES('MRI', 9, 'SS30', 'used for scans', 'operate wisely');



INSERT INTO Unit VALUES('1000', 'MRI', 1, 2013, TO_DATE('17/12/2011 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('1001', 'MRI', 2, 2010, TO_DATE('14/02/2010 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('1002', 'MRI', 4, 2007, TO_DATE('10/10/2013 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('2000', 'MRI', 9, 2006, TO_DATE('01/01/2014 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('3001', 'MRI', 2, 2015, TO_DATE('04/12/2011 12:33:37', 'DD/MM/YYYY hh:mi:ss'));

/* SHOULD RETURN AN ERROR */
INSERT INTO Unit VALUES('2001', 'MRI', 11, 2004, TO_DATE('17/12/2016 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('2002', 'MRI', 8, 2005, TO_DATE('17/12/2010 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('3000', 'MRI', 7, NULL, TO_DATE('17/12/2017 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
INSERT INTO Unit VALUES('3002', 'MRI', 3, 2003, TO_DATE('17/12/2010 12:33:37', 'DD/MM/YYYY hh:mi:ss'));
spool off