CREATE DATABASE Academy

USE Academy

CREATE TABLE Faculties (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (Name <> '')
);

CREATE TABLE Departments (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Financing MONEY NOT NULL CHECK (Financing >= 0) DEFAULT 0,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (Name <> ''),
    FacultyId INT NOT NULL,
    FOREIGN KEY (FacultyId) REFERENCES Faculties(Id)
    
);

CREATE TABLE Groups (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name NVARCHAR(10) NOT NULL UNIQUE CHECK (Name <> ''),
    Year INT NOT NULL CHECK (Year BETWEEN 1 AND 5),
    DepartmentId INT NOT NULL,
    FOREIGN KEY (DepartmentId) REFERENCES Departments(Id)
);

CREATE TABLE Subjects (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL UNIQUE CHECK (Name <> '')
);

CREATE TABLE Teachers (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    Name NVARCHAR(MAX) NOT NULL CHECK (Name <> ''),
    Salary MONEY NOT NULL CHECK (Salary > 0),
    Surname NVARCHAR(MAX) NOT NULL CHECK (Surname <> '')
);


CREATE TABLE Lectures (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    DayOfWeek INT NOT NULL CHECK (DayOfWeek BETWEEN 1 AND 7),
    LectureRoom NVARCHAR(MAX) NOT NULL CHECK (LectureRoom <> ''),
    SubjectId INT NOT NULL,
    TeacherId INT NOT NULL,
    FOREIGN KEY (SubjectId) REFERENCES Subjects(Id),
    FOREIGN KEY (TeacherId) REFERENCES Teachers(Id)
);

CREATE TABLE GroupsLectures (
    Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    GroupId INT NOT NULL,
    LectureId INT NOT NULL,
    FOREIGN KEY (GroupId) REFERENCES Groups(Id),
    FOREIGN KEY (LectureId) REFERENCES Lectures(Id)
);

-- INSERTING COMMANDS

INSERT INTO Faculties (Name) VALUES 
('Faculty of Information Technology'),
('Faculty of Economics and Management'),
('Faculty of Engineering');

INSERT INTO Departments (Financing, Name, FacultyId) VALUES 
(50000, 'Department of Software Engineering', 1),
(45000, 'Department of Network Technologies', 1),
(60000, 'Department of Finance', 2),
(55000, 'Department of Marketing', 2),
(70000, 'Department of Mechanics', 3);

INSERT INTO Groups (Name, Year, DepartmentId) VALUES 
('SE-21', 2, 1),
('SE-31', 3, 1),
('NT-22', 2, 2),
('FN-41', 4, 3),
('MK-32', 3, 4),
('ME-21', 2, 5);

INSERT INTO Subjects (Name) VALUES 
('Python Programming'),
('Networks and Internet'),
('Financial Analysis'),
('Marketing Research'),
('Theory of Mechanisms');


INSERT INTO Teachers (Name, Salary, Surname) VALUES 
('Ivan', 15000, 'Petrenko'),
('Olena', 16000, 'Ivanova'),
('Mykhailo', 17000, 'Sydorenko'),
('Natalia', 18000, 'Kovalenko'),
('Andrii', 19000, 'Shevchenko');

INSERT INTO Lectures (DayOfWeek, LectureRoom, SubjectId, TeacherId) VALUES 
(1, 'Room 101', 1, 1),
(2, 'Room 102', 2, 2),
(3, 'Room 103', 3, 3),
(4, 'Room 104', 4, 4),
(5, 'Room 105', 5, 5);

INSERT INTO GroupsLectures (GroupId, LectureId) VALUES 
(1, 1),
(2, 1),
(3, 2),
(4, 3),
(5, 4),
(6, 5);

-- updating db

UPDATE Subjects
SET Name = 'Software Development'
WHERE Subjects.Id = 1;

UPDATE Teachers
SET Name = 'Dave McQueen'
WHERE Teachers.Id = 1;

UPDATE Lectures
SET LectureRoom = 'D201'
WHERE Id = 1;

UPDATE Teachers
SET Name = 'Jack Underhill'
WHERE Teachers.Id = 2;

UPDATE Faculties
SET Name = 'Faculty of Computer Science'
WHERE Id = 1;

-- selecting db

SELECT COUNT(DISTINCT T.Id) AS TeacherCount
FROM Teachers AS T
INNER JOIN Lectures AS L ON T.Id = L.TeacherId
INNER JOIN Subjects AS S ON L.SubjectId = S.Id
INNER JOIN GroupsLectures AS GL ON L.Id = GL.LectureId
INNER JOIN Groups AS G ON GL.GroupId = G.Id
INNER JOIN Departments AS D ON G.DepartmentId = D.Id
WHERE D.Name = 'Department of Software Engineering';

SELECT COUNT(L.Id) AS LectureCount FROM Lectures AS L
INNER JOIN Teachers AS T ON L.TeacherId = T.Id
WHERE T.Name = 'Dave McQueen';

SELECT COUNT(*) AS LectureCount
FROM Lectures
WHERE LectureRoom = 'D201';

SELECT LectureRoom AS LECTURE_ROOM, COUNT(*) AS LECTURE_TOTAL FROM Lectures
GROUP BY LectureRoom;

SELECT COUNT(G.Id) AS StudentCount
FROM Groups AS G
INNER JOIN GroupsLectures AS GL ON G.Id = GL.GroupId
INNER JOIN Lectures AS L ON GL.LectureId = L.Id
INNER JOIN Teachers AS T ON L.TeacherId = T.Id
WHERE T.Name = 'Jack Underhill'
GROUP BY G.Id;

SELECT AVG(T.Salary) AS AverageSalary
FROM Teachers AS T
LEFT JOIN Lectures AS L ON T.Id = L.TeacherId
LEFT JOIN GroupsLectures AS GL ON L.Id = GL.LectureId
LEFT JOIN Groups AS G ON GL.GroupId = G.Id
LEFT JOIN Departments AS D ON G.DepartmentId = D.Id
LEFT JOIN Faculties AS F ON D.FacultyId = F.Id
WHERE F.Name = 'Faculty of Computer Science';


SELECT MIN(G.Year) AS MinYear, MAX(G.Year) AS MaxYear
FROM Groups AS G;

SELECT AVG(D.Financing) FROM Departments AS D;

SELECT T.Name + ' ' + T.Surname AS Teacher_fullname, COUNT(DISTINCT S.Id) AS Subject_Count
FROM GroupsLectures AS GL
INNER JOIN Lectures AS L ON GL.LectureId = L.Id
INNER JOIN Teachers AS T ON L.TeacherId = T.Id
INNER JOIN Subjects AS S ON L.SubjectId = S.Id
GROUP BY T.Name, T.Surname;

SELECT DayOfWeek, COUNT(*) AS Lecture_Count FROM Lectures AS L
GROUP BY DayOfWeek;

SELECT L.LectureRoom, COUNT(DISTINCT D.Id) AS DepartmentCount
FROM Lectures AS L
LEFT JOIN GroupsLectures AS GL ON L.Id = GL.LectureId
LEFT JOIN Groups AS G ON GL.GroupId = G.Id
LEFT JOIN Departments AS D ON G.DepartmentId = D.Id
GROUP BY L.LectureRoom;


SELECT F.Name AS Name_of_Faculties, COUNT(*)
FROM GroupsLectures as GL
LEFT JOIN Groups AS G ON GL.GroupId = G.Id
LEFT JOIN Departments AS D ON G.DepartmentId = D.Id
LEFT JOIN Faculties AS F ON D.FacultyId = F.Id
GROUP BY F.NAME;

SELECT T.Name + ' ' + T.Surname AS TeacherFullName, L.LectureRoom, COUNT(*) AS LectureCount
FROM Teachers AS T
INNER JOIN Lectures AS L ON T.Id = L.TeacherId
GROUP BY T.Name, T.Surname, L.LectureRoom;


-- deleting db

DROP TABLE GroupsLectures;

DROP TABLE Lectures;

DROP TABLE Groups;

DROP TABLE Departments;

DROP TABLE Teachers;

DROP TABLE Subjects;

DROP TABLE Faculties;


USE MASTER;

DROP DATABASE Academy;
