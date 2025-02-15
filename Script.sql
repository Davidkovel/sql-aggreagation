CREATE DATABASE Hospital

USE Hospital


CREATE TABLE Departments(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Building INT NOT NULL CHECK (Building BETWEEN 1 AND 5),
	Name NVARCHAR(100) NOT NULL UNIQUE CHECK (Name <> '')
	
);


CREATE TABLE Doctors(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Name NVARCHAR(MAX) NOT NULL CHECK (Name <> ''),
	Premium MONEY NOT NULL CHECK (Premium > 0) DEFAULT 0,
	Salary MONEY NOT NULL CHECK (Salary > 0),
	Surname NVARCHAR(MAX) NOT NULL CHECK(Surname <> '')
);


CREATE TABLE Examinations(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Name NVARCHAR(100) NOT NULL UNIQUE CHECK (Name <> '')

);

CREATE TABLE Wards(
	Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
	Name NVARCHAR(20) NOT NULL UNIQUE CHECK (Name <> ''),
	Places INT NOT NULL CHECK (Places >= 1),
	DepartmentId INT NOT NULL,
	FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);


CREATE TABLE DoctorsExaminations(
	Id INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,
	EndTime TIME NOT NULL,
	StartTime TIME NOT NULL CHECK (StartTime BETWEEN '8:00' AND '18:00'),
	DoctorId INT NOT NULL,
	ExaminationId INT NOT NULL,
	WardId INT NOT NULL,
	FOREIGN KEY (DoctorId) REFERENCES Doctors(Id),
	FOREIGN KEY (ExaminationId) REFERENCES Examinations(Id),
	FOREIGN KEY (WardId) REFERENCES Wards(Id),
	CHECK (EndTime > StartTime)
);





-- INSERTING COMMANDS

INSERT INTO Departments (Building, Name) VALUES 
(1, 'Surgery'),
(2, 'Therapy'),
(3, 'Pediatrics'),
(4, 'Neurology'),
(5, 'Cardiology');


INSERT INTO Doctors (Name, Premium, Salary, Surname) VALUES
('John', 500, 15000, 'Doe'),
('Jane', 300, 12000, 'Smith'),
('Michael', 400, 13000, 'Johnson'),
('Emily', 200, 11000, 'Brown'),
('Andrew', 600, 16000, 'Wilson');


INSERT INTO Examinations (Name) VALUES
('Ultrasound'),
('Blood Test'),
('X-Ray'),
('MRI'),
('ECG');


INSERT INTO Wards (Name, Places, DepartmentId) VALUES
('Ward 101', 4, 1),
('Ward 102', 3, 2),
('Ward 103', 5, 3),
('Ward 104', 2, 4),
('Ward 105', 6, 5);


INSERT INTO DoctorsExaminations (EndTime, StartTime, DoctorId, ExaminationId, WardId) VALUES
('10:30', '09:00', 1, 1, 1),
('12:00', '11:00', 2, 2, 2),
('14:00', '13:00', 3, 3, 3),
('16:00', '15:00', 4, 4, 4),
('18:00', '17:00', 5, 5, 5);

-- SELECTING COMMANDS

SELECT COUNT(Name) AS Ward_Count FROM Wards
WHERE Places > 10;

SELECT D.Building AS Building_Number, COUNT(W.Id) AS Ward_Count
FROM Departments D
INNER JOIN Wards W ON D.Id = W.DepartmentId
GROUP BY D.Building;

SELECT D.Name As Department_Name, COUNT(W.Id) As Ward_Count
FROM Departments D
LEFT JOIN Wards W ON D.Id = W.DepartmentId
GROUP BY D.Name;

SELECT D.Name, SUM(DOC.Premium) FROM Departments D
LEFT JOIN Wards W ON D.Id = W.DepartmentId
LEFT JOIN DoctorsExaminations DoctorE ON W.ID = DoctorE.WardId
LEFT JOIN Doctors DOC ON DoctorE.DoctorId = DOC.Id
GROUP BY D.Name;


SELECT D.Name FROM Departments D
JOIN Wards W ON D.Id = W.DepartmentId
JOIN DoctorsExaminations DE ON W.ID = DE.WardId
GROUP BY D.Name
HAVING COUNT(DISTINCT DE.DoctorId) >= 5;

SELECT COUNT(Id), SUM(Salary + Premium) AS TOTAL_SALARY FROM Doctors;

SELECT AVG(Salary + Premium) AS AVERAGE_SALARY FROM Doctors;

SELECT Name FROM WARDS
WHERE Places = (SELECT MIN(Places) FROM Wards);

SELECT D.BUILDING , SUM(W.Places) FROM Departments D
INNER JOIN Wards W ON D.ID = W.DepartmentId
WHERE D.Building IN (1, 6, 7, 8) AND W.Places > 10
GROUP BY D.Building
HAVING SUM(W.Places) > 100;

-- deleting db

DROP TABLE DoctorsExaminations;

DROP TABLE Wards;

DROP TABLE Doctors;

DROP TABLE Examinations;

DROP TABLE Departments;

USE MASTER;

DROP DATABASE Hospital;
