-- Create Tables
CREATE TABLE Employees_USA (
    EmpID INT,
    EmpName VARCHAR(50)
);

CREATE TABLE Employees_UK (
    EmpID INT,
    EmpName VARCHAR(50)
);

CREATE TABLE Project_A (
    EmpID INT,
    ProjectName VARCHAR(50)
);

CREATE TABLE Project_B (
    EmpID INT,
    ProjectName VARCHAR(50)
);

-- Insert Data into Employees_USA
INSERT INTO Employees_USA VALUES 
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie'),
(4, 'Diana');

-- Insert Data into Employees_UK
INSERT INTO Employees_UK VALUES 
(3, 'Charlie'),
(4, 'Diana'),
(5, 'Ethan'),
(6, 'Fiona');

-- Insert Data into Project_A
INSERT INTO Project_A VALUES
(1, 'AI Research'),
(2, 'Web Dev'),
(3, 'Data Analysis');

-- Insert Data into Project_B
INSERT INTO Project_B VALUES
(2, 'Web Dev'),
(3, 'Security Audit'),
(5, 'Cloud Migration');


select * from Employees_USA;
select * from Employees_UK;
select * from Project_A;
select * from Project_B;

