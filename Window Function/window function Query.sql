use customers;
-- Create the EmployeesPerformance table
CREATE TABLE EmployeesPerformance (
    EmpID INT,
    EmpName VARCHAR(100),
    Department VARCHAR(50),
    Salary INT,
    JoiningDate DATE,
    PerformanceRating INT
);

-- Insert sample data
INSERT INTO EmployeesPerformance VALUES
(1, 'Alice', 'Sales', 60000, '2020-03-01', 5),
(2, 'Bob', 'Sales', 55000, '2021-07-15', 4),
(3, 'Charlie', 'HR', 50000, '2019-02-10', 3),
(4, 'Diana', 'HR', 52000, '2020-08-23', 5),
(5, 'Evan', 'IT', 70000, '2018-06-12', 2),
(6, 'Fiona', 'IT', 72000, '2019-11-30', 4),
(7, 'George', 'IT', 68000, '2021-04-18', 5),
(8, 'Hannah', 'Marketing', 48000, '2020-01-20', 3),
(9, 'Ian', 'Marketing', 50000, '2021-05-22', 4),
(10, 'Jane', 'Sales', 58000, '2019-12-01', 3);

select * from EmployeesPerformance;

--1. Rank employees based on Salary (highest salary = rank 1).
select EmployeesPerformance.EmpName, EmployeesPerformance.Salary,
rank() over (order by salary desc) as Ranking
from EmployeesPerformance;

--2. Dense Rank employees based on PerformanceRating (highest rating first).
select EmployeesPerformance.EmpName,
DENSE_RANK() over (order by PerformanceRating Desc)
from EmployeesPerformance;

--3. Assign Row Numbers to employees ordered by JoiningDate.
select EmployeesPerformance.EmpName, 
ROW_NUMBER() over(order by joiningDate Asc) as Row_Number
from EmployeesPerformance;

--4. Find the employee with the 2nd highest salary using RANK().
select EmpName, Salary
from (
select EmployeesPerformance.EmpName, EmployeesPerformance.Salary,
rank() over (order by salary desc)  as ranking
from EmployeesPerformance ) as Ranked
where Ranking = 2;

--5. Find the employee with the 2nd highest salary using DENSE_RANK().
select EmpName, Salary
from (
select EmployeesPerformance.EmpName, EmployeesPerformance.Salary,
dense_rank() over (order by salary desc)  as ranking
from EmployeesPerformance ) as Ranked
where Ranking = 2;

--6. Find the 2nd most recent joiner using ROW_NUMBER().
select top 2 empname, joiningdate,
ROW_NUMBER() over(order by joiningdate asc) as top_joining
from EmployeesPerformance;

select * from EmployeesPerformance;

--7. Rank employees within each Department based on Salary.
select empname, Department, Salary,
rank() over(partition by department order by salary desc) as top_joining
from EmployeesPerformance;

--8. Row Number employees within each Department ordered by JoiningDate.
select empname, Department, JoiningDate,
row_number() over(partition by department order by joiningdate desc) as top_joining
from EmployeesPerformance;

--9. Dense Rank employees within each Department based on PerformanceRating.
select empname, department, performancerating,
DENSE_RANK() over (partition by Department order by performancerating desc) as dense_performance 
from EmployeesPerformance;

--10. Find all employees who have the same salary rank.
SELECT *
FROM (
    SELECT EmpID, EmpName, Department, Salary,
           RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
    FROM EmployeesPerformance
) AS ranked
WHERE SalaryRank IN (
    SELECT SalaryRank
    FROM (
        SELECT RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
        FROM EmployeesPerformance
    ) AS all_ranks
    GROUP BY SalaryRank
    HAVING COUNT(*) > 1
);

	--11. Show each employees salary along with the next employee's salary (based on salary descending).
	select empname, salary,
	lead(salary) over(order by salary desc) as next_emp_salary
	from EmployeesPerformance;

	--12. Show each employees salary along with the previous employees salary.
		select empname, salary,
	lag(salary) over(order by salary desc) as previous_emp_salary
	from EmployeesPerformance;

	--13. Find the salary difference between an employee and the next employee.
	select empname, salary,
	lead(salary) over(order by salary desc) as next_emp_salary,
	Salary - lead(salary) over(order by salary desc) as diff_salary
	from EmployeesPerformance;
	
	--14. Find the salary difference between an employee and the previous employee.
	select empname, salary,
	lag(salary) over(order by salary desc) as next_emp_salary,
	Salary - lag(salary) over(order by salary desc) as diff_salary
	from EmployeesPerformance;


	select * from EmployeesPerformance;

	--15. For each department, show each employee and the next joining employee.
select empname, joiningdate, department,
lead(JoiningDate) over(partition by department order by joiningdate asc) as next_joining
from EmployeesPerformance;

--16. Find who joined immediately before and after each employee.
select empname, joiningdate,
lead(joiningdate) over(order by joiningdate asc) as next_joining,
lag(joiningdate) over(order by joiningdate asc) as previous_joining
from EmployeesPerformance;

--17. Find employees whose salary increased compared to the previous employee (based on salary order).
SELECT 
    EmpName,
    Salary
	from(
	select empname, salary,
	    LAG(Salary) OVER (ORDER BY Salary DESC) AS PrevSalary
		FROM EmployeesPerformance) as increased_salary
		WHERE Salary > PrevSalary;
	

--18. Show employees with lower salaries than the next employee.
select empname, salary
from ( select empname, salary,
lead(salary) over(order by salary desc) as next_emp_sal,
salary - lead(salary) over(order by salary desc) as diff_salary
from EmployeesPerformance) as sal_comparison
where diff_salary < 0;

--19. Compare each employee's performance rating with the next employee.
select empname, performancerating,
lead(performancerating) over(order by performancerating desc) as comp_perf
from EmployeesPerformance;

--20. Find the employee whose salary is immediately higher than Bob's salary.
select top 1 empname, salary
from EmployeesPerformance
where Salary > 55000
order by salary asc;

--21. Find cumulative salary total ordered by salary descending.
select empname, salary, 
sum(Salary) over(order by salary desc) as cumulative_sal
from EmployeesPerformance;

--22. Find cumulative count of employees based on joining date.
select empname, salary, 
count(EmpID) over(order by joiningdate asc) as cumulative_count
from EmployeesPerformance;

--23. Calculate running average salary for all employees.
select empname, salary, 
avg(salary) over(order by salary desc rows between unbounded preceding and current row) as running_avg_sal
from EmployeesPerformance;

--24. Find the maximum salary within each department.
with cte as (
select empname, salary, department,
rank() over(partition by department order by salary desc) as max_dept_sal
from EmployeesPerformance
)

select empname, salary, department, max_dept_sal from cte
where max_dept_sal = 1
--25. Find the minimum performance rating within each department.
select empname, PerformanceRating, department,
min(PerformanceRating) over(partition by department) as min_dept_rating
from EmployeesPerformance;

--26. Find average salary within each department.
select empname, salary, department, 
avg(salary) over(partition by department) as avg_sal
from EmployeesPerformance;

--27. Find the difference between each employee's salary and department average salary.
select empname, salary, department, 
avg(salary) over(partition by department) as avg_sal,
salary - avg(salary) over(partition by department) as diff_sal
from EmployeesPerformance;

--28. Find total salary per department using window function.
select empname, salary, department,
sum(salary) over(partition by department) as total_dept_sal
from EmployeesPerformance;

--29. Find the employee with the minimum joining date in each department.
select empname, JoiningDate, department,
min(JoiningDate) over(partition by department) as min_join_date
from EmployeesPerformance;

--30. Find employees earning more than the average salary in their department.
select empname, salary, department,
avg(salary) over(partition by department) as avg_dept_sal,
salary - avg(salary) over(partition by department) as more_than_avg_sal
from EmployeesPerformance;


select empname, salary, department
from (
select empname, salary, department,
avg(salary) over(partition by department) as avg_dept_sal
from EmployeesPerformance) as d
where salary > avg_dept_sal;



avg(salary) over(partition by department) as avg_dept_sal,
salary - avg(salary) over(partition by department) as more_than_avg_sal
from EmployeesPerformance;

--31. Find row number of employees partitioned by Department and ordered by Salary descending.
select empname, salary, department, 
ROW_NUMBER() over(partition by department order by salary desc) as row_num_for_desc_sal
from EmployeesPerformance;

--32. Find the highest paid employee in each department.
select empname, salary, department
from( select empname, salary, department,
rank() over(partition by department order by salary desc) as dept_highest_paid_emp
from EmployeesPerformance) as highest_sal_emp
where dept_highest_paid_emp = 1;

--33. Find the second highest paid employee in each department.
select empname, salary, department
from( select empname, salary, department,
rank() over(partition by department order by salary desc) as dept_highest_paid_emp
from EmployeesPerformance) as highest_sal_emp
where dept_highest_paid_emp = 2;

--34. List employees who are the newest in their department.
select empname, Joiningdate, department
from( select empname, Joiningdate, department,
rank() over(partition by department order by Joiningdate asc) as ranked
from EmployeesPerformance) as new_join
where ranked = 1;

select * from EmployeesPerformance;


--35. Find employees with the highest performance rating per department.
select empname, performancerating, department
from( select empname, performancerating, department,
rank() over(partition by department order by performancerating desc) as ranked
from EmployeesPerformance) as highest_performance
where ranked = 1;

--36. Find employees whose performance rating is lower than the department average.
select empname, performancerating, department
from( select empname, performancerating, department,
avg(performancerating) over(partition by department order by performancerating desc) as avg_performance
from EmployeesPerformance) as highest_performance
where PerformanceRating < avg_performance;

--37. Find employees who have the same salary within their department.
select empname, salary, department 
from( 
select empname, department,salary, 
lag(salary) over(partition by department order by salary asc) as next_emp_sal
from EmployeesPerformance) as same_sal
where salary = next_emp_sal;

--38. Find how many employees joined before each employee in the same department.





--39. Find difference in joining date between each employee and the next one in their department.
select empname,  department,joiningdate,
lead(joiningdate) over(partition by department order by joiningdate asc) as next_date,
datediff(day, JoiningDate, lead(joiningdate) over(partition by department order by joiningdate asc)) as days_diff
from EmployeesPerformance;

--40. Rank employees across the company based on performance, break ties alphabetically by name.
select empname, performancerating, 
rank() over(order by performancerating desc, empname asc) as ranked
from EmployeesPerformance;

--41. Find each employees salary compared to the maximum salary across all employees.
select empname, salary, 
max(salary) over() as max_sal
from EmployeesPerformance;

--42. Find employees who are the second most recent joiners in the company.
select empname, joiningdate
from(
select empname, joiningdate,
rank() over(order by joiningdate desc) as ranked
from EmployeesPerformance) as second_most_recent
where ranked = 2;

--43. Find cumulative sum of performance ratings.
select empname, performancerating, 
sum(performancerating) over( order by performancerating asc rows between unbounded preceding and current row) as cumulative_sum
from EmployeesPerformance;

--44. Show the performance rating of the employee who joined just before each employee.
SELECT empname, joiningdate, performanceRating, 
       LAG(performanceRating) OVER (ORDER BY joiningdate ASC) AS prev_employee_perf_rating
FROM EmployeesPerformance;

--45. Find employees who have better performance than the employee who joined just before them.
SELECT EmpName, JoiningDate, PerformanceRating
from(
SELECT EmpName, JoiningDate, PerformanceRating,
       LAG(PerformanceRating) OVER (ORDER BY JoiningDate ASC) AS PrevPerfRating
FROM EmployeesPerformance) as better_performer
WHERE PerformanceRating > PrevPerfRating;


select * from EmployeesPerformance;


--46. Find each employees rank in company tenure (JoiningDate ASC).
select empname,
rank() over(order by joiningdate asc) as tenure_rank
from EmployeesPerformance;

--47. Find salary gap between an employee and the previous higher salary employee.
select empname, salary, 
lag(salary) over(order by salary desc) as prev_sal,
salary - lag(salary) over(order by salary desc) as sal_gap
from EmployeesPerformance;

--48. Show which employees are earning more than their previous colleague in the same department.
select empname, salary, department
from(
select empname, salary, department,
lag(salary) over(partition by department order by salary desc) as prev_sal
from EmployeesPerformance) as higher_sal
where Salary > prev_sal;

--49. Find employees who had the same joining year.
SELECT 
    EmpName, 
    YEAR(JoiningDate) AS JoinYear,
    COUNT(*) OVER (PARTITION BY YEAR(JoiningDate)) AS EmployeesInSameYear
FROM EmployeesPerformance
ORDER BY JoinYear, EmpName;

--50. Compare each employee's salary with the average salary across the company (without group by).
select empname, salary, 
avg(salary) over() as avg_sal,
salary - avg(salary) over() as sal_diff
from EmployeesPerformance;
