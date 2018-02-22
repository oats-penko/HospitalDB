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
	typeID VARCHAR2(30) NOT NULL,  
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



/* Part 1 */

CREATE OR REPLACE VIEW CriticalCases(Patient_SSN, firstName, lastName, numberOfAdmissionsToICU) AS  
	SELECT P.SSN, P.firstName, P.lastName, q.numberOfAdmissionsToICU 
	FROM Patient P,
	(SELECT P.SSN, COUNT(*) AS numberOfAdmissionsToICU
	FROM Patient P, (SELECT A.patientSSN as patientSSN, A.aptID as aptID 
					FROM Appointment A 
					WHERE A.aptID in (SELECT AptID FROM AptRoom A WHERE A.roomNumber in  
							(SELECT roomNumber FROM roomService WHERE rService = 'ICU'))) apts 
	WHERE P.SSN = apts.patientSSN  
	GROUP BY P.SSN  
	HAVING COUNT(*) > 2) q
	WHERE q.SSN = P.SSN;

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
SELECT C.Patient_SSN, C.firstName, C.lastname 
FROM CriticalCases C
WHERE C.numberOfAdmissionsToICU > 4;

/* Use the views created above (you may need the original tables as well) to report the female overloaded doctors. You should report the doctor ID, firstName, and lastName. */
SELECT L.DoctorID, D.firstName, D.lastName 
FROM DoctorsLoad L, Doctor D
WHERE L.gender = 'female' AND L.DoctorID = D.ID;

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
    IF numServices > 3 THEN
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
	    managerID int;
	    managerTitle int;
BEGIN 
    SELECT E.managerID INTO managerID FROM Employee E WHERE E.ID = :new.ID;
    SELECT E.jobTitle INTO managerTitle FROM Employee E WHERE E.ID = managerID;
    IF managerID IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'This employee must have a supervisor.');
    ELSIF :new.jobTitle = 0 AND managerTitle != 1 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Regular employees must be supervised by a Division Manager.');
    ELSIF :new.jobTitle = 1 AND managerTitle != 2 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Division managers must be supervised by a General Manager.');
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
spool off