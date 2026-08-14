-- Create the HospitalDB
-- PURPOSE CREATES the main database used.
CREATE DATABASE HospitalDB;
-- Selects HospitalDB as the active database.

USE HospitalDB;

-- CREATE THE PATIENTS TABLE
-- Creates a structured table for storing patient demographics, medical, visits and billing info.
CREATE TABLE Patients(
PatientID INT PRIMARY KEY,
FirstName VARCHAR(50),
LastName VARCHAR(50),
Age INT,
Gender VARCHAR(50),
Diagnosis VARCHAR(100),
Doctor VARCHAR(100),
VisitDate DATE,
BillAmount DECIMAL(10,2)
);


SHOW TABLES;

-- Verifies that patient records were successfully imported.
SELECT *
FROM Patients;

SELECT *
FROM Patients
LIMIT 10;

DESCRIBE Patients;

-- Counts the total number of patient records. 
SELECT COUNT(*) AS TotalPatients
FROM Patients;

-- DATA QUALITY VALIDATION 
-- Checks for patients with missing first names.
SELECT *
FROM Patients
WHERE FirstName IS NULL;

-- Checks for patients with missing last name.
SELECT *
FROM Patients
WHERE LastName IS NULL;

-- Checks for invalid patient ages outisde the expected range of 0 to 120.
SELECT * 
FROM Patients
WHERE Age < 0 OR Age >120;

-- Checks whether any patient records have a missing diagnosis.
SELECT *
FROM Patients
WHERE Diagnosis IS NULL;

-- Checks whether any patient records have a missing billing amount.
SELECT *
FROM Patients
WHERE BillAmount IS NULL;

-- Checks for duplicate Patient IDs.
-- PatientID should be unique because it is a primary key.
SELECT PatientID,COUNT(*) AS NumberOfRecords
FROM Patients 
GROUP BY PatientID
HAVING COUNT(*) >1;

-- INITIAL PATIENT ANALYSIS
-- Generates basic statistical measures from the patient billing data.
SELECT MIN(BillAmount) AS MinimumBill,MAX(BillAmount) AS MaximumBill,AVG(BillAmount) AS AverageBill
FROM Patients;

-- Displays the unique diagnoses recorded in the patied dataset.
SELECT DISTINCT Diagnosis
FROM Patients;

-- Counts the number of patient within each diagnosis category.
SELECT Diagnosis,COUNT(*) AS PatientCount
FROM Patients
GROUP BY Diagnosis
ORDER BY PatientCount DESC;

-- Calculates the number of patients recorded for each gender.
SELECT Gender,COUNT(*) AS PatientCount
FROM Patients
GROUP BY Gender;

-- Calculates the number of patient records associated with each doctor.
SELECT Doctor,COUNT(*) AS PatientCount
FROM Patients
GROUP BY Doctor
ORDER BY PatientCount DESC; 

-- CREATE DOCTORS TABLE
CREATE TABLE Doctors(
DoctorID INT PRIMARY KEY,
DoctorName VARCHAR(100) NOT NULL,
Department VARCHAR(100) NOT NULL
);

-- INSERT DOCTOR DATA
INSERT INTO Doctors(DoctorID, DoctorName, Department)
VALUES(1,'Dr Adams', 'General Medicine'),
(2,'Dr Singh', 'Cardiology'),
(3,'Dr Naidoo','Internal Medicine');

-- Displays all doctors currently stored in the Doctors table.
SELECT *
FROM Doctors;

-- CREATE APPOINTMENTS TABLE
CREATE TABLE Appointments(
AppointmentID INT PRIMARY KEY,
PatientID INT,
DoctorID INT,
AppointmentDate DATE,
STATUS VARCHAR(30),
FOREIGN KEY(PatientID)
REFERENCES Patients(PatientID),
FOREIGN KEY (DoctorID)
REFERENCES Doctors(DoctorID)
);

SHOW TABLES;

-- INSERT APPOINTMENT DATA
INSERT INTO Appointments
(AppointmentID, PatientID, DoctorID, AppointmentDate, Status)
VALUES
(1, 1, 1, '2026-07-05', 'Completed'),
(2, 2, 2, '2026-07-06', 'Completed'),
(3, 3, 3, '2026-07-07', 'Scheduled'),
(4, 4, 1, '2026-07-08', 'Cancelled'),
(5, 5, 2, '2026-07-09', 'Completed'),
(6, 6, 3, '2026-07-10', 'Completed'),
(7, 7, 1, '2026-07-11', 'Scheduled'),
(8, 8, 2, '2026-07-12', 'Completed'),
(9, 9, 3, '2026-07-13', 'Cancelled'),
(10, 10, 1, '2026-07-14', 'Completed');

-- Displays all appointment records.
SELECT *
FROM Appointments;

-- Combines patients, appointment and doctor  informations using JOINS.
SELECT
    p.PatientID,
    p.FirstName,
    p.LastName,
    a.AppointmentDate,
    a.Status,
    d.DoctorName,
    d.Department
FROM Patients p
JOIN Appointments a
    ON p.PatientID = a.PatientID
JOIN Doctors d
    ON a.DoctorID = d.DoctorID;
    
-- Adds a new patient record
    INSERT INTO Patients
(PatientID, FirstName, LastName, Age, Gender, Diagnosis, Doctor, VisitDate, BillAmount)
VALUES
(101, 'Marcel', 'Govender', 26, 'M', 'Flu', 'Dr Adams', '2026-08-14', 350.00);

-- Retrieves the newly created patient.
SELECT *
FROM Patients
WHERE PatientID = 101;

-- UPDATE and CHANGE diagnosis.
UPDATE Patients
SET Diagnosis='Asthma'
WHERE PatientID=101;

SELECT*
FROM Patients
WHERE PatientID=101;

-- Change the diagnosis for Patient 101.
INSERT INTO Patients
(PatientID, FirstName, LastName, Age, Gender, Diagnosis, Doctor, VisitDate, BillAmount)
VALUES
(102, 'Test', 'Patient', 30, 'M', 'Flu', 'Dr Singh', '2026-08-14', 250.00);

SELECT*
FROM Patients
WHERE PatientID=102;

-- DELETE and REMOVE test record.
DELETE FROM Patients
WHERE PatientID=102;

SELECT*
FROM Patients
WHERE PatientID=102;

-- BUSINESS ANALYSIS
-- Determines the total number of patient records in the database.
SELECT COUNT(*) AS TotalPatients 
FROM Patients;

-- Calculates the average age of patients in the database.
SELECT ROUND(AVG(Age), 1) AS AverageAge
FROM Patients;

-- Calculates the total billing amount recorded for all patients.
SELECT ROUND(SUM(BillAmount), 2) AS TotalBilling
FROM Patients;

-- Calculates the average billing amount per patient.
SELECT ROUND(AVG(BillAmount), 2) AS AverageBill
FROM Patients;

-- Identifies the highest billing amount recorded in the database.
SELECT MAX(BillAmount) AS HighestBill
FROM Patients;

-- Identifies the lowest billing amount recorded in the database.
SELECT MIN(BillAmount) AS LowestBill
FROM Patients;

-- Identifies the most common diagnoses among patients.
SELECT Diagnosis,COUNT(*) AS PatientCount
FROM Patients
GROUP BY Diagnosis
ORDER BY PatientCount DESC;

-- Determines how many patients are associated with each doctor.
SELECT Doctor,COUNT(*) AS PatientCount
FROM Patients
GROUP BY Doctor
ORDER BY PatientCount DESC;

-- Analyses the distribution of patients by gender.
SELECT Gender,COUNT(*) AS PatientCount
FROM Patients 
GROUP BY Gender
ORDER BY PatientCount DESC;

-- Identifies patients with bills greater than R350.
SELECT 
PatientID,
FirstName,
LastName,
Diagnosis,
BillAmount
FROM Patients
WHERE BillAmount > 350
ORDER BY BillAmount DESC;

-- Identifies the ten patients with the highest recorded billing amounts.
SELECT 
PatientID,
FirstName,
LastName,
Diagnosis,
BillAmount
FROM Patients
ORDER BY BillAmount DESC
LIMIT 20;

-- Determines the number of patient visits recorded for each date.
SELECT VisitDate,COUNT(*) AS PatientVisits
FROM Patients
GROUP BY VisitDate
ORDER BY VisitDate;

-- Creates a combined report using data from three related tables.
SELECT
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    p.Diagnosis,
    d.DoctorName,
    d.Department,
    a.AppointmentDate,
    a.Status
FROM Patients p
JOIN Appointments a
    ON p.PatientID = a.PatientID
JOIN Doctors d
    ON a.DoctorID = d.DoctorID
ORDER BY a.AppointmentDate;

-- Determines how many appointments are completed, scheduled or cancelled.
SELECT STATUS,COUNT(*) AS AppointmentCount
FROM Appointments
GROUP BY STATUS
ORDER BY AppointmentCount DESC;

-- Calculates the percentage of appointments that were completed.
SELECT
    ROUND(
        100.0 * SUM(CASE WHEN Status = 'Completed' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS CompletionRate
FROM Appointments;

-- Creates a reusable summary of patient information.
CREATE VIEW PatientSummary AS
SELECT
    PatientID,
    CONCAT(FirstName, ' ', LastName) AS PatientName,
    Age,
    Gender,
    Diagnosis,
    Doctor,
    VisitDate,
    BillAmount
FROM Patients;

-- Displays the patient summary.
SELECT*
FROM PatientSummary;

-- Creates a reusable report showing patient workload by doctor.
CREATE VIEW DoctorPatientSummary AS
SELECT
    d.DoctorID,
    d.DoctorName,
    d.Department,
    COUNT(p.PatientID) AS PatientCount
FROM Doctors d
LEFT JOIN Patients p
    ON d.DoctorName = p.Doctor
GROUP BY
    d.DoctorID,
    d.DoctorName,
    d.Department;
    
    -- Displays patient workload by doctor.
    SELECT*
    FROM DoctorPatientSummary
    ORDER BY PatientCount DESC;

-- Creates a reusable reporting combining patient, doctor and appointment information.
CREATE VIEW AppointmentReport AS
SELECT
    a.AppointmentID,
    p.PatientID,
    CONCAT(p.FirstName, ' ', p.LastName) AS PatientName,
    p.Diagnosis,
    d.DoctorName,
    d.Department,
    a.AppointmentDate,
    a.Status
FROM Appointments a
JOIN Patients p
    ON a.PatientID = p.PatientID
JOIN Doctors d
    ON a.DoctorID = d.DoctorID;
    
    -- Displays the appointment report.
    SELECT*
    FROM AppointmentReport
    ORDER BY AppointmentDate;
    -- Analyses appointment outcomes using the reusable AppointmentReport view.
    SELECT STATUS,COUNT(*) AS AppointmentCount
    FROM AppointmentReport
    GROUP BY STATUS
    ORDER BY AppointmentCount DESC;
    
    -- Identifies which doctors have the highest number of appointments.
    SELECT DoctorName,Department,COUNT(*) AS TotalAppointments
    FROM AppointmentReport
    GROUP BY DoctorName, Department
    ORDER BY TotalAppointments DESC;
    
    -- Categories patients into age groups using a CASE statement.
    SELECT
    PatientID,
    FirstName,
    LastName,
    Age,
    CASE
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 39 THEN '18-39'
        WHEN Age BETWEEN 40 AND 59 THEN '40-59'
        ELSE '60+'
    END AS AgeGroup
FROM Patients;

-- Determines the number of patients in each age category.
SELECT
    CASE
        WHEN Age < 18 THEN 'Under 18'
        WHEN Age BETWEEN 18 AND 39 THEN '18-39'
        WHEN Age BETWEEN 40 AND 59 THEN '40-59'
        ELSE '60+'
    END AS AgeGroup,
    COUNT(*) AS PatientCount
FROM Patients
GROUP BY AgeGroup
ORDER BY PatientCount DESC;

-- Identifies patients whose bills are higher than the average patient bill.
SELECT
    PatientID,
    FirstName,
    LastName,
    Diagnosis,
    BillAmount
FROM Patients
WHERE BillAmount > (
    SELECT AVG(BillAmount)
    FROM Patients
)
ORDER BY BillAmount DESC;

-- CTE billing by diagnosis.
WITH DiagnosisBilling AS (
    SELECT
        Diagnosis,
        COUNT(*) AS PatientCount,
        SUM(BillAmount) AS TotalBilling,
        AVG(BillAmount) AS AverageBill
    FROM Patients
    GROUP BY Diagnosis
)

SELECT
    Diagnosis,
    PatientCount,
    ROUND(TotalBilling, 2) AS TotalBilling,
    ROUND(AverageBill, 2) AS AverageBill
FROM DiagnosisBilling
ORDER BY TotalBilling DESC;

