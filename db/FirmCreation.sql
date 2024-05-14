USE master; 
GO

DROP DATABASE IF EXISTS FirmDB;
GO

CREATE DATABASE FirmDB; 
GO

USE FirmDB; 
GO

-- 1. Создание таблиц узлов
CREATE TABLE Employee (
    EmployeeID INT IDENTITY NOT NULL,
    EmployeeName NVARCHAR(100) NOT NULL,
	EmployeeSurname NVARCHAR(100) NOT NULL,
    Position NVARCHAR(100) NOT NULL,
    Salary INT NOT NULL,
    CONSTRAINT PK_Employee PRIMARY KEY (EmployeeID),
    CONSTRAINT UQ_EmployeeName UNIQUE (EmployeeName),
    CONSTRAINT CK_SalaryNonNegative CHECK (Salary >= 0)
) AS NODE;
GO

CREATE TABLE Department (
    DepartmentID INT IDENTITY NOT NULL,
    DepartmentName NVARCHAR(100) NOT NULL,
	[Location] NVARCHAR(100) NOT NULL,
	CONSTRAINT PK_Department PRIMARY KEY (DepartmentID),
	CONSTRAINT UQ_DepartmentName UNIQUE (DepartmentName)
) AS NODE;
GO

CREATE TABLE Project (
    ProjectID INT IDENTITY(1,1) NOT NULL,
    ProjectName NVARCHAR(100) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    CONSTRAINT PK_Project PRIMARY KEY (ProjectID),
    CONSTRAINT UQ_ProjectName UNIQUE (ProjectName),
    CONSTRAINT CHK_DateRange CHECK (StartDate < EndDate)
) AS NODE;
GO

-- 2. Создание таблиц ребер

CREATE TABLE Knows AS EDGE;
GO
ALTER TABLE Knows ADD CONSTRAINT EC_Knows CONNECTION (Employee to Employee);

CREATE TABLE EmployeeDepartment AS EDGE;
GO
ALTER TABLE EmployeeDepartment ADD CONSTRAINT EC_EmployeeDepartment CONNECTION (Employee to Department);

CREATE TABLE EmployeeProject AS EDGE;
GO
ALTER TABLE EmployeeProject ADD CONSTRAINT EC_EmployeeProject CONNECTION (Employee to Project);

CREATE TABLE DepartmentProject AS EDGE;
GO
ALTER TABLE DepartmentProject ADD CONSTRAINT EC_DepartmentProject CONNECTION (Department to Project);

-- 3. Заполнение таблиц узлов

INSERT INTO Employee (EmployeeName, EmployeeSurname, Position, Salary)
VALUES
  ('John', 'Doe', 'Manager', 5000), --1
  ('Jane', 'Smith', 'Developer', 4000), --2
  ('Michael', 'Jordan', 'Analyst', 3500), --3
  ('Emily', 'Davis', 'Designer', 3800), --4
  ('David', 'Wilson', 'Engineer', 4200), --5
  ('Sarah', 'Thompson', 'Assistant', 3000), --6
  ('Daniel', 'Brown', 'Developer', 4000), --7
  ('Jennifer', 'Lee', 'Manager', 4800), --8
  ('Andrew', 'Miller', 'Designer', 3800), --9
  ('Olivia', 'Anderson', 'Engineer', 4200) --10
; 
GO

INSERT INTO Department (DepartmentName, Location)
VALUES
  ('HR', 'New York'),
  ('Finance', 'London'),
  ('Marketing', 'Paris'),
  ('IT', 'San Francisco'),
  ('Sales', 'Tokyo'),
  ('Operations', 'Berlin')
;
GO

INSERT INTO Project (ProjectName, StartDate, EndDate)
VALUES
  ('Website Redesign', '2022-01-01', '2022-06-30'),
  ('Product Launch', '2022-03-15', '2022-09-30'),
  ('Marketing Campaign', '2022-02-01', '2022-07-31'),
  ('Software Development', '2022-04-01', '2022-11-30'),
  ('International Expansion', '2022-05-01', '2022-12-31'),
  ('Data Analytics', '2022-03-01', '2022-08-31'),
  ('Supply Chain Optimization', '2022-02-15', '2022-09-15'),
  ('Customer Relationship Management', '2022-06-01', '2022-12-31')
;
GO

-- 4. Заполнение таблиц ребер

INSERT INTO Knows ($from_id, $to_id)
VALUES
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 6), -- Sarah
		(SELECT $node_id FROM Employee WHERE EmployeeID = 1) -- John
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 6), -- Sarah
		(SELECT $node_id FROM Employee WHERE EmployeeID = 2) -- Jane
	),	
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 6), -- Sarah
		(SELECT $node_id FROM Employee WHERE EmployeeID = 5) -- David
	),	
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 6), -- Sarah
		(SELECT $node_id FROM Employee WHERE EmployeeID = 9) -- Andrew
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 2), -- Jane
		(SELECT $node_id FROM Employee WHERE EmployeeID = 6) -- Sarah
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 2), -- Jane
		(SELECT $node_id FROM Employee WHERE EmployeeID = 3) -- Micheal
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 2), -- Jane
		(SELECT $node_id FROM Employee WHERE EmployeeID = 7) -- Daniel
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 3), -- Micheal
		(SELECT $node_id FROM Employee WHERE EmployeeID = 4) -- Emily
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 3), -- Micheal
		(SELECT $node_id FROM Employee WHERE EmployeeID = 8) -- Jennifer
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 8), -- Daniel
		(SELECT $node_id FROM Employee WHERE EmployeeID = 10) -- Olivia
	)
;
GO

INSERT INTO EmployeeDepartment ($from_id, $to_id)
VALUES
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 1), -- John Doe
		(SELECT $node_id FROM Department WHERE DepartmentID = 1) -- работает в отделе HR
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 2), -- Jane Smith
		(SELECT $node_id FROM Department WHERE DepartmentID = 4) -- работает в отделе IT
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 3), -- Michael Jordan
		(SELECT $node_id FROM Department WHERE DepartmentID = 4) -- работает в отделе IT
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 4), -- Emily Davis
		(SELECT $node_id FROM Department WHERE DepartmentID = 3) -- работает в отделе Marketing
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 5), -- David Wilson
		(SELECT $node_id FROM Department WHERE DepartmentID = 6) -- работает в отделе Operations
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 6), -- Sarah Thompson
		(SELECT $node_id FROM Department WHERE DepartmentID = 2) -- работает в отделе Finance
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 7), -- Daniel Brown
		(SELECT $node_id FROM Department WHERE DepartmentID = 4) -- работает в отделе IT
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 8), -- Jennifer Lee
		(SELECT $node_id FROM Department WHERE DepartmentID = 1) -- работает в отделе HR
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 9), -- Andrew Miller
		(SELECT $node_id FROM Department WHERE DepartmentID = 5) -- работает в отделе Sales
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 10), -- Olivia Anderson
		(SELECT $node_id FROM Department WHERE DepartmentID = 4) -- работает в отделе IT
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 1), -- John Doe
		(SELECT $node_id FROM Department WHERE DepartmentID = 2) -- работает в отделе Finance
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 2), -- Jane Smith
		(SELECT $node_id FROM Department WHERE DepartmentID = 3) -- работает в отделе Marketing
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 3), -- Micheal Jordan
		(SELECT $node_id FROM Department WHERE DepartmentID = 5) -- работает в отделе Sales
	)
	;
GO

INSERT INTO EmployeeProject ($from_id, $to_id)
VALUES
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 1), -- John Doe
		(SELECT $node_id FROM Project WHERE ProjectID = 1) -- работает над проектом "Website Redesign"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 2), -- Jane Smith
		(SELECT $node_id FROM Project WHERE ProjectID = 4) -- работает над проектом "Software Development"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 3), -- Michael Jordan
		(SELECT $node_id FROM Project WHERE ProjectID = 3) -- работает над проектом "Marketing Campaign"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 4), -- Emily Davis
		(SELECT $node_id FROM Project WHERE ProjectID = 2) -- работает над проектом "Product Launch"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 5), -- David Wilson
		(SELECT $node_id FROM Project WHERE ProjectID = 5) -- работает над проектом "International Expansion"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 6), -- Sarah Thompson
		(SELECT $node_id FROM Project WHERE ProjectID = 7) -- работает над проектом "Supply Chain Optimization"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 6), -- Sarah Thompson
		(SELECT $node_id FROM Project WHERE ProjectID = 8) -- работает над проектом "Customer Relationship Management"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 7), -- Daniel Brown
		(SELECT $node_id FROM Project WHERE ProjectID = 4) -- работает над проектом "Software Development"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 8), -- Jennifer Lee
		(SELECT $node_id FROM Project WHERE ProjectID = 1) -- работает над проектом "Website Redesign"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 9), -- Andrew Miller
		(SELECT $node_id FROM Project WHERE ProjectID = 5) -- работает над проектом "International Expansion"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 10), -- Olivia Anderson
		(SELECT $node_id FROM Project WHERE ProjectID = 3) -- работает над проектом "Marketing Campaign"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 1), -- John Doe
		(SELECT $node_id FROM Project WHERE ProjectID = 2) -- работает над проектом "Product Launch"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 2), -- Jane Smith
		(SELECT $node_id FROM Project WHERE ProjectID = 3) -- работает над проектом "Marketing Campaign"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 3), -- Micheal Jordan
		(SELECT $node_id FROM Project WHERE ProjectID = 7) -- работает над проектом "Supply Chain Optimization"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 4), -- Emily Davis
		(SELECT $node_id FROM Project WHERE ProjectID = 5) -- работает над проектом "International Expansion"
	),
	(
		(SELECT $node_id FROM Employee WHERE EmployeeID = 5), -- David Wilson
		(SELECT $node_id FROM Project WHERE ProjectID = 6) -- работает над проектом "Data Analitics"
	)
;
GO

INSERT INTO DepartmentProject ($from_id, $to_id)
VALUES
	(
		(SELECT $node_id FROM Department WHERE DepartmentID = 1), -- HR
		(SELECT $node_id FROM Project WHERE ProjectID = 2) -- работает над проектом "Product Launch"
	),
	(
		(SELECT $node_id FROM Department WHERE DepartmentID = 2), -- Finance
		(SELECT $node_id FROM Project WHERE ProjectID = 3) -- работает надпроектом "Marketing Campaign"
	),
	(
		(SELECT $node_id FROM Department WHERE DepartmentID = 3), -- Marketing
		(SELECT $node_id FROM Project WHERE ProjectID = 1) -- работает надпроектом "Website Redesign"
	),
	(
		(SELECT $node_id FROM Department WHERE DepartmentID = 4), -- IT
		(SELECT $node_id FROM Project WHERE ProjectID = 4) -- работает над проектом "Software Development"
	),
	(
		(SELECT $node_id FROM Department WHERE DepartmentID = 5), -- Sales
		(SELECT $node_id FROM Project WHERE ProjectID = 5) -- работает надпроектом "International Expansion"
	),
	(
		(SELECT $node_id FROM Department WHERE DepartmentID = 6), -- Operations
		(SELECT $node_id FROM Project WHERE ProjectID = 7) -- работает надпроектом "Supply Chain Optimization"
	),
	(
		(SELECT $node_id FROM Department WHERE DepartmentID = 1), -- HR
		(SELECT $node_id FROM Project WHERE ProjectID = 6) -- работает надпроектом "Data Analytics"
	),
	(
		(SELECT $node_id FROM Department WHERE DepartmentID = 2), -- Finance
		(SELECT $node_id FROM Project WHERE ProjectID = 8) -- работает надпроектом "Customer Relationship Management"
	),
	(
		(SELECT $node_id FROM Department WHERE DepartmentID = 3), -- Marketing
		(SELECT $node_id FROM Project WHERE ProjectID = 8) -- работает над проектом "Supply Chain Optimization"
	),
	(
		(SELECT $node_id FROM Department WHERE DepartmentID = 4), -- IT 
		(SELECT $node_id FROM Project WHERE ProjectID = 7) -- работает над проектом "Customer Relationship Management"
	)
;
GO

-- 5. Запросы с функцией MATCH

-- Сотрудники, работающие над проектом "Website Redesign":

SELECT E.EmployeeName as [Name], E.EmployeeSurname as [Surname]
FROM 
	Employee as E, 
	EmployeeProject as EP, 
	Project as P
where 
	MATCH (E-(EP)->P) and P.ProjectName = 'Website Redesign'
;

-- Отделы, где работает John Doe:

SELECT D.DepartmentName, D.[Location]
FROM Department as D, EmployeeDepartment as ED, Employee as E
WHERE MATCH (E-(ED)->D) and E.EmployeeName = 'John' and E.EmployeeSurname = 'Doe';

-- Проекты, порученные HR:

select P.ProjectName, P.StartDate, P.EndDate
from Department as D,
	 DepartmentProject as DP,
	 Project as P
where D.DepartmentName = 'HR'
	  and MATCH (D-(DP)->P)

-- Отделы, которые работают над проектами, в которых участвует сотрудник с именем "John":

select distinct D.DepartmentName, D.[Location]
FROM Department as D,
	 DepartmentProject as DP,
	 Project as P,
	 EmployeeProject as EP,
	 Employee as E
WHERE E.EmployeeName = 'John'
	  and MATCH (D-(DP)->P)
	  and MATCH (E-(EP)->P)
;

-- Сотрудники, работающие над проектами, которые поручены отделу "HR":

select distinct E.EmployeeName as [Name], E.EmployeeSurname as [Surname], P.ProjectName as [Project]
FROM Employee as E,
	 EmployeeDepartment as ED,
	 Department as D,
	 DepartmentProject as DP,
	 Project as P,
	 EmployeeProject as EP
WHERE MATCH (E-(EP)->P) and
	  MATCH (D-(DP)->P) and
	  D.DepartmentName = 'HR'
;

-- 6. Запросы с функцией SHORTEST_PATH

SELECT 
    E1.EmployeeName AS Employee1Name,
    STRING_AGG(E2.EmployeeName, '->') WITHIN GROUP (GRAPH PATH) AS EmployeePath
FROM 
    Employee AS E1,
	Employee FOR PATH AS E2, 
	Knows FOR PATH AS Knows
WHERE MATCH(SHORTEST_PATH(E1(-(Knows)->E2)+))
	and E1.EmployeeName = 'Jane';

SELECT 
    E1.EmployeeName AS Employee1Name,
    STRING_AGG(E2.EmployeeName, '->') WITHIN GROUP (GRAPH PATH) AS EmployeePath
FROM 
    Employee AS E1,
	Employee FOR PATH AS E2, 
	Knows FOR PATH AS Knows
WHERE MATCH(SHORTEST_PATH(E1(-(Knows)->E2){1,2}))
	and E1.EmployeeName = 'Jane';