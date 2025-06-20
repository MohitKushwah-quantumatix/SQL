-- Create a test database (optional)
CREATE DATABASE TestDB;
GO
USE TestDB;
GO

-- Drop table if exists
IF OBJECT_ID('dbo.Employees') IS NOT NULL
    DROP TABLE dbo.Employees;
GO

-- Create Employees table
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),   
    Age INT,
    Department NVARCHAR(50),
    Salary DECIMAL(10, 2)
    HireDate DATE,
    IsActive BIT
);
GO

-- Insert sample data
INSERT INTO Employees VALUES
(1, 'Alice', 'Johnson', 28, 'HR', 50000, '2020-01-15', 1),
(2, 'Bob', 'Smith', 35, 'Finance', 75000, '2019-03-12', 1),
(3, 'Charlie', 'Lee', 40, 'IT', 90000, '2015-06-01', 0),
(4, 'Diana', 'Martinez', 25, 'Marketing', 45000, '2022-08-10', 1),
(5, 'Evan', 'Clark', 50, 'Finance', 120000, '2010-10-23', 0),
(6, 'Fiona', 'Garcia', 30, 'HR', 52000, '2021-11-05', 1),
(7, 'George', 'Lopez', 38, 'IT', 85000, '2018-04-20', 1),
(8, 'Hannah', 'Adams', 27, 'Marketing', 47000, '2023-02-14', 1),
(9, 'Ian', 'Wright', 45, 'IT', 110000, '2012-07-19', 0),
(10, 'Julia', 'Chen', 32, 'Finance', 68000, '2020-12-01', 1);
GO

select * from Employees;
