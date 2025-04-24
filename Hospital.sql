create database Hospital

-- Create Departments Table
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL
);

-- Create Doctors Table
CREATE TABLE Doctors (
    DoctorID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100) NOT NULL,
    Specialty VARCHAR(100),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Create Patients Table
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100),
    Gender CHAR(1),
    BirthDate DATE
);

-- Create Appointments Table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY IDENTITY(1,1),
    PatientID INT,
    DoctorID INT,
    AppointmentDate DATETIME,
    Reason VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- Create Visits Table
CREATE TABLE Visits (
    VisitID INT PRIMARY KEY IDENTITY(1,1),
    AppointmentID INT,
    VisitDate DATETIME,
    Diagnosis VARCHAR(255),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- Create Medications Table
CREATE TABLE Medications (
    MedicationID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(100),
    Dosage VARCHAR(50)
);

-- Create Prescriptions Table
CREATE TABLE Prescriptions (
    PrescriptionID INT PRIMARY KEY IDENTITY(1,1),
    VisitID INT,
    MedicationID INT,
    Quantity INT,
    Instructions VARCHAR(255),
    FOREIGN KEY (VisitID) REFERENCES Visits(VisitID),
    FOREIGN KEY (MedicationID) REFERENCES Medications(MedicationID)
);


-- Departments

INSERT INTO Departments (Name) VALUES
('Cardiology'), ('Neurology'), ('Orthopedics');

-- Doctors
INSERT INTO Doctors (Name, Specialty, DepartmentID) VALUES
('Dr. Ahmed Youssef', 'Cardiologist', 1),
('Dr. Sara Adel', 'Neurologist', 2),
('Dr. Omar Samir', 'Orthopedic Surgeon', 3);

-- Patients
INSERT INTO Patients (Name, Gender, BirthDate) VALUES
('Mohamed Ali', 'M', '1980-05-22'),
('Laila Hassan', 'F', '1992-11-14'),
('Khaled Saeed', 'M', '2000-01-09');

-- Appointments
INSERT INTO Appointments (PatientID, DoctorID, AppointmentDate, Reason) VALUES
(1, 1, '2025-04-10 09:00', 'Chest pain'),
(2, 2, '2025-04-11 10:30', 'Frequent headaches'),
(3, 3, '2025-04-12 14:00', 'Knee pain');

-- Visits
INSERT INTO Visits (AppointmentID, VisitDate, Diagnosis) VALUES
(1, '2025-04-10 09:30', 'Mild angina'),
(2, '2025-04-11 10:45', 'Migraine'),
(3, '2025-04-12 14:30', 'Ligament strain');

-- Medications
INSERT INTO Medications (Name, Dosage) VALUES
('Aspirin', '100mg'), ('Paracetamol', '500mg'), ('Ibuprofen', '200mg');

-- Prescriptions
INSERT INTO Prescriptions (VisitID, MedicationID, Quantity, Instructions) VALUES
(1, 1, 30, '1 tablet daily after breakfast'),
(2, 2, 20, '2 tablets when needed'),
(3, 3, 15, '1 tablet every 8 hours');


--TotalVisits for each doctor
SELECT d.Name AS DoctorName, COUNT(v.VisitID) AS TotalVisits
FROM Doctors d
JOIN Appointments a ON d.DoctorID = a.DoctorID
JOIN Visits v ON a.AppointmentID = v.AppointmentID
GROUP BY d.Name;

--Number Of Patients for each doctor
SELECT d.Name AS DoctorName, COUNT(DISTINCT a.PatientID) AS [Number Of Patients]
FROM Doctors d
LEFT JOIN Appointments a ON d.DoctorID = a.DoctorID
GROUP BY d.Name;
--


-- All patient visits within a specific week + doctor's name and diagnosis
SELECT 
    p.Name AS Patient,
    d.Name AS Doctor,
    v.VisitDate,
    v.Diagnosis
FROM Visits v
JOIN Appointments a ON v.AppointmentID = a.AppointmentID
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
WHERE v.VisitDate BETWEEN '2025-04-07' AND '2025-04-14';

-- Medications prescribed and frequency
SELECT 
    m.Name AS Medication,
    COUNT(pr.PrescriptionID) AS TimesPrescribed
FROM Prescriptions pr
JOIN Medications m ON pr.MedicationID = m.MedicationID
GROUP BY m.Name
ORDER BY TimesPrescribed DESC;

--
--Patients who took a prescription containing "Ibuprofen"
SELECT DISTINCT p.Name AS PatientName
FROM Prescriptions pr
JOIN Visits v ON pr.VisitID = v.VisitID
JOIN Appointments a ON v.AppointmentID = a.AppointmentID
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Medications m ON pr.MedicationID = m.MedicationID
WHERE m.Name = 'Ibuprofen';
--

--Patients who have an appointment with a doctor in the Department of Cardiology
SELECT p.Name AS PatientName, d.Name AS DoctorName, dp.Name AS Department
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
JOIN Doctors d ON a.DoctorID = d.DoctorID
JOIN Departments dp ON d.DepartmentID = dp.DepartmentID
WHERE dp.Name = 'Cardiology';
