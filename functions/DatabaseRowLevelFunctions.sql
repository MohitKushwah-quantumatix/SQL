
--Get the full name of each employee in uppercase.
select concat(upper(firstname), '  ' ,upper(lastname)) as Full_Name from Employees;

--Get the length of each employee’s full name.
select len((firstname) + ' ' +(lastname)) as Len_of_Full_Name from Employees;

--Get only the domain part from each employee's email.
select email, right(email, 12) as Domain_Part from employees
where email is not null;

--Replace all dots in email addresses with underscores.
select replace(email, '.', '_') from Employees;

--Trim any leading or trailing spaces from first names.
select trim(firstname) from Employees;

--Find employees whose last name starts with 'S'.
select lastname from Employees where lastname like 'S%';

--Find employees whose email contains 'example'.
select email from employees where email like  '%example%';

--Return the first three letters of each first name.
select substring(firstname, 1,1)from Employees;

--Find the position of '@' in each email. (hint: CHARINDEX)
select charindex( '@',email, 1) from Employees;

--Concatenate first name and last name with a space in between.
select (firstname) + ' ' +(lastname) as Full_Name from Employees;

--Find employees whose last name ends with 'a'.
select lastname from Employees where lastname like '%a';

--Get only the first name in lowercase.
select lower(FirstName) from Employees;

--Get the number of characters in email addresses.
select len(email) from Employees;

--Find employees with no email assigned.
select firstname from Employees where len(email) is null;

--Replace the country code in phone numbers with just the number.
 select replace(phone, '+91-', '') as just_phone_number from Employees ;

 --Extract first name initials.
 select substring(firstname, 1,1)from Employees;

 --Use PATINDEX to find the position of '@' in emails.(hint: PATINDEX('%@%', Email))
select PATINDEX('%@%', email) from Employees;
select charindex( '@',email, 1) from Employees;

--Use REPLACE to remove all hyphens from phone numbers.
select replace(phone, '-', '') from Employees;

--Get last name reversed using REVERSE.
select reverse(lastname) from employees;

--Use LEFT and RIGHT to get first and last three characters of last names.
select lastname, left(lastname, 3) as left_3, right(lastname, 3) as right_3 from Employees; 

--Round off salaries to nearest 100.               INCORRECT
select ROUND(salary, 100) from Employees;
select Salary from Employees;

--Get absolute value of salary differences from 70000. ABS()
select ABS(salary) from Employees where salary > 70000;

--Get the square root of salaries SQRT()
select sqrt(salary) from Employees;

--Get ceiling value of all salary entries. CEILING()
select ceiling(salary) from Employees;

--Get floor value of all salary entries. FLOOR(Salary)
select floor(salary) from Employees;

--Use POWER to square the salaries POWER(Salary, 2)
select POWER(Salary, 2) from Employees;

--Use PI() to return the constant SELECT PI()
select pi()

--Use RAND() to generate a random number per row hint :  SELECT RAND(CHECKSUM(NEWID())) AS RandomValue FROM Employees;
SELECT RAND(CHECKSUM(NEWID())) AS RandomValue FROM Employees;

--Multiply salary by 1.10 (10% hike).
select (salary * 1.10) as hiked_salary from Employees;

--Divide salary by 30 to get per day salary.
select salary / 30 from Employees;

--Use POWER to calculate square of each salary.
select POWER(salary, 2) from Employees;

--Get modulus of EmployeeID by 2.
select EmployeeID % 2 from Employees;

--Find average salary of all employees.
select avg(salary) from Employees;

--Find min, max, sum of salaries.
select min(salary) as minimum_salary, max(salary) as maximum_salary, sum(salary) as sum_of_salaries from Employees;

--Find employees with salary greater than average salary.
select firstname from Employees 
where salary > (select avg(salary) from Employees);

--Get rounded salary to 2 decimal places.
select round(salary, 5) from Employees;

--Get year, month, day from DateOfJoining.
select dateofjoining, year(dateofjoining), month(dateofjoining), day(dateofjoining) from Employees;

--Get only the name of the day (Monday, etc.).
select format(dateofjoining, 'dddd') from Employees;

--Find employees who joined in the last 3 years.
select firstname from Employees where year(dateofjoining) > 2022;

--Get number of days since each employee joined.
select firstname, datediff(day, dateofjoining, getdate()) as number_of_days from Employees;


select * from Departments;
select * from Employees;


--Find who joined on a weekend.
select firstname
from Employees
where datename(weekday, DateOfJoining) in ('Saturday', 'Sunday');

--Add 100 days to the joining date.
select dateofjoining, dateadd(day, 100 ,dateofjoining) from Employees;

--Subtract 100 days from the joining date.
select dateofjoining, dateadd(day, -100 ,dateofjoining) from Employees;

--Use EOMONTH to get end of month for each joining date.
select eomonth(dateofjoining) from Employees;

--Truncate date to the start of the year using DATETRUNC.
select datetrunc(year, dateofjoining) from Employees;

--Use DATEDIFF to find experience in years.
select firstname, datediff(year, dateofjoining, getdate()) as Experience_in_years from Employees;

--Use DATEPART(quarter) to find quarter of joining.
select datepart(quarter, dateofjoining) from Employees;

--Get current date and time using GETDATE().
select getdate()

--Format date as dd-mm-yyyy.
select format(dateofjoining, 'dd-MM-yyyy') from Employees;

--Use CONVERT to format DateOfJoining as mm/dd/yyyy.
select CONVERT(VARCHAR, DateOfJoining, 32) from Employees;

--Use FORMAT(DateOfJoining, 'MMM yyyy').
select format(dateofjoining, 'MMM-yyyy') from Employees;

--Get time difference in minutes between GETDATE() and DateOfJoining.
select datediff(minute,dateofjoining, getdate()) from Employees;

--Find employees who joined on same month as today.
select firstname ,month(dateofjoining) as joining_Month,  month(getdate()) as current_month from Employees
where month(dateofjoining) = month(getdate()) +3 ;

--Show date in yyyy-MM-dd format.
select format(dateofjoining, 'yyyy-MM-dd') from Employees;

--Extract only month name from DateOfJoining.
select format(dateofjoining, 'MMMM') from Employees;

--Show first day of the joining month.
select dateofjoining, datepart(day, dateofjoining), format(DateOfJoining, 'dddd')from Employees;

--Show last day of joining year.
select dateofjoining, 
format(eomonth(dateadd(month, 11, datetrunc(year, DateOfJoining))), 'dddd'),
eomonth(dateadd(month, 11, datetrunc(year, DateOfJoining)))
from Employees;

--Find employees who joined in current year.
select firstname , dateofjoining from Employees where year(DateOfJoining) = year(getdate());

--Display joining date as dd MMMM, yyyy.
select format(dateofjoining, 'dd MM yyyy') from Employees;

--Show month and year together (like 'March 2019').
select dateofjoining, format(dateofjoining, 'MMMM yyyy') from Employees;

--Show employees whose anniversary is today (match only day and month).
select DateOfJoining, firstname from Employees
where datepart(day, DateOfJoining) = datepart(day, getdate()) and 
datepart(month, DateOfJoining) = datepart(month, getdate());


select * from Employees;

--Add 6 months to the joining date.
select dateofjoining,
dateadd(month, 6, dateofjoining)
from Employees;

--Subtract 3 years from DateOfJoining.
select dateofjoining,
dateadd(year, -3, dateofjoining)
from Employees;

--Use DATENAME to display weekday name of joining.
select dateofjoining, datename(weekday, dateofjoining) from Employees;

--Get ISO week number of joining date.


--Show full formatted string like: "Joined on 15th March, 2019 (Friday)"
select dateofjoining,
concat('Joined on' , CONVERT(VARCHAR, dateofjoining, 13) , format(dateofjoining, ' dddd'))
from Employees;

--Convert salary to VARCHAR and append " INR".
select Salary,
CAST(salary as varchar) + 'INR'
from Employees;

--Convert DateOfJoining to string.
select dateofjoining, cast(dateofjoining as VARCHAR) from Employees;

--Convert string "100.25" to decimal using CAST.
 select cast('100.25' as float); 

 --Use CONVERT to get date in dd/mm/yyyy format.
select dateofjoining, convert(VARCHAR, dateofjoining, 101) from Employees;

--Convert NULL emails to "No Email Provided".
select email,
isnull(email, 'No Email Provided') from Employees;

--Convert phone number to INT (what happens?).
select right(phone, 10), 
cast(right(phone, 10) as int) from Employees;

--Cast EmployeeID to VARCHAR and concatenate with name.
select concat(cast(employeeid as VARCHAR),' ' ,firstname)from Employees;

--Convert date to datetime and add time '09:00:00'.
select dateofjoining, convert(datetime, dateofjoining, 20)+ '09:00:00' from Employees;

--Cast salary to INT and compare with original.
select salary, cast(salary as int) from Employees; 

--Show difference between CAST and CONVERT.


--Count how many employees have NULL salary.
select count(*) from Employees where Salary is null;

--Replace NULL phone numbers with 'N/A'.
select isnull(Phone,'N/A') from Employees;

--Use ISNULL(Salary, 0) to calculate total salaries.
select sum(isnull(Salary, 0))
from Employees;

--Use COALESCE(Email, 'No Email').
select coalesce(email, 'No Email') from Employees;

--Compare ISNULL vs COALESCE for multiple NULLs.


--Find employees with either NULL phone or NULL email.
select firstname from Employees where Phone is null or email is null;

--Use NULLIF(Salary, 0) and explain output.
select salary, NULLIF(salary, 0) from Employees;

--Use ISNULL to calculate average salary including NULLs.
select avg(isnull(salary, 0)) from Employees;

--Show employees where Salary is NOT NULL.
select firstname from Employees where salary is not null;


select * from Employees;
select * from Departments;




--Return 'Missing' for NULL email when concatenating names.
select firstname + ' ' + isnull(email, 'Missing') from Employees;


--List employees with formatted string: "Rahul Sharma from Engineering earns 75K".
select firstname, DepartmentName, Salary,  
 left(cast(salary as int),(len(cast(salary as int))-3)) +'K'
 ,FORMAT(salary,'##,##0.##')
from Departments left join Employees
on Departments.departmentID = Employees.departmentID;


select concat(firstname,' ', lastname,' ', ' from ', DepartmentName,' ',' earns ' ,  
 left(cast(salary as int),(len(cast(salary as int))-3)) +'K')
from Departments left join Employees
on Departments.departmentID = Employees.departmentID;


update Employees set salary = 6800000 where EmployeeID =  102;


--Show all employees and their experience in complete years and months.
select DateOfJoining ,datediff(year,dateofjoining, getdate()) as exp_in_years, 
datediff(month, DateOfJoining, getdate()) % 12 as exp_in_months
from Employees;


--Create a query that lists department-wise average salary.
select DepartmentName, avg(Salary) 
from Departments left join Employees
on departments.DepartmentID = Employees.DepartmentID
group by DepartmentName;

--List employees who have been in the company more than average experience.
select FirstName,
avg(cast(datediff(year, dateofjoining, getdate()) as int))
from Employees 
group by FirstName
having  avg(cast(datediff(year, dateofjoining, getdate()) as int)) > 
(select 
avg(cast(datediff(year, dateofjoining, getdate()) as int))
from Employees) ; 

--Find out how many employees don't have phone/email/salary.
select firstname
from Employees
where Phone is null or email is null or Salary is null;

--Show only employees who joined before 2020 and have NULL email.
select firstname, year(DateOfJoining)
from Employees
where year(DateOfJoining) < '2020' and email is null;

--Format salary with commas (e.g., 75,000.50).
select format(salary, ) from Employees


--Find employees with phone numbers containing '9876'.
select firstname from Employees where Phone like '%9876%';

--Display department name along with each employee.
select departmentName, firstname
from Departments left join Employees
on employees.DepartmentID = Departments.DepartmentID

--Show how many employees joined each quarter.
select count(EmployeeID) as Num_of_emp_joined, 
count(datepart(QUARTER,dateofjoining)) as Joining_quarter
from Employees
group by datepart(QUARTER,dateofjoining);

--Show first and last character of each last name.
select lastname,left(lastname, 1) as left_letter, 
right(lastname, 1) as right_letter 
from Employees;

--Display difference between LEN and DATALENGTH for names.
select len(firstname), datalength(firstname) from Employees;

--Format joining date with month name and day (e.g., 15 March 2019).
select format(DateOfJoining, 'dd MMMM yyyy') 
from Employees

--List employees whose names contain vowels only.
select firstname
from Employees
where len(replace(replace(replace(replace(replace(firstname, 'u', ''), 'o', ''), 'i', ''), 'e', ''), 'a', '')) = 0;

update Employees set FirstName = 'aau' where EmployeeID = 101;
select * from Employees;

--Find employees who joined in the same month as today.
select firstname,
month(dateofjoining) as joining_month,
month(getdate()) as current_month
from Employees
where month(dateofjoining) = month(getdate());

--Count number of characters in full name excluding spaces.
select firstname, lastname,
len(concat(trim(firstname), trim(lastname))) as full_name
from Employees;

