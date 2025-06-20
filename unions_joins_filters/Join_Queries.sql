--List all orders with customer names and product names. 
select customers.CustomerName, Orders.OrderID, Products.ProductName
from Orders left join customers
on customers.CustomerID = Orders.CustomerID
left join Products
on Orders.ProductID = Products.ProductID;


--Show each order with product price included.
select Orders.OrderDate, Orders.OrderID, Orders.Quantity, Products.ProductName, Products.Price
from Orders inner join products
on Orders.ProductID = products.ProductID;

--Find all customers who have placed at least one order.
select customers.CustomerName
from customers inner join Orders
on Orders.CustomerID = customers.CustomerID
where Orders.CustomerID is not null;

--Show each product that has been ordered and by whom.
select Customers.CustomerName, Orders.OrderID , Orders.ProductID,Products.ProductName
from Products inner join Orders
on Products.ProductID = Orders.ProductID 
inner join customers
on Orders.CustomerID = customers.CustomerID ;

--Display all customers along with order dates and products they bought.  
select customers.CustomerName, Orders.OrderDate, Products.ProductName 
from Customers inner join orders
on customers.CustomerID = Orders.CustomerID
inner join Products
on Orders.ProductID = Products.ProductID;

--List all customers and their orders (if any).    
select customers.CustomerName, Orders.Quantity
from customers inner join Orders   
on customers.CustomerID = Orders.CustomerID
where Orders.Quantity >= 1;

--Show customers who have not placed any orders.
select customers.CustomerName, Orders.Quantity
from customers left join Orders
on customers.CustomerID = Orders.CustomerID
where Orders.OrderID is null;

--List all products and their order info (if ordered).
select Products.ProductName, Orders.OrderDate, Orders.OrderDate, orders.Quantity
from Products left join Orders
on Orders.ProductID = Products.ProductID
where Orders.Quantity >= 1;

--Find products that have never been ordered.
select Products.ProductName 
from Products left join Orders
on Products.ProductID = Orders.ProductID
where Orders.OrderID is null;


select * from customers;
select * from Products;
select * from Orders;


--Get all orders and include customer info even if customer doesn't exist in Customers table.
select customers.CustomerName, Orders.OrderDate, orders.OrderID
from Orders left join customers
on customers.CustomerID = Orders.CustomerID;

--Show all orders with product details, even if the product doesn't exist in Products.
select Orders.OrderID, Orders.OrderDate, Products.ProductID, Products.ProductName 
from Orders left join Products
on Products.ProductID = orders.ProductID;

--Get all customers who placed orders, including products even if they are invalid.
select customers.CustomerName, Products.ProductName
from customers inner join Orders
on customers.CustomerID = Orders.CustomerID
left join Products
on Products.ProductID = Orders.ProductID;

--List all products and any order associated with them.
select Products.ProductID, Products.ProductName, Orders.OrderDate, Orders.OrderDate, Orders.Quantity
from Products left join Orders
on Products.ProductID = Orders.ProductID;

--Show which orders were made with missing customer info.
select Orders.OrderDate, Orders.OrderID, customers.CustomerName, customers.CustomerID
from orders left join customers
on Orders.CustomerID = customers.CustomerID
where customers.CustomerID is null;

--List all customers and their orders, including customers and orders that don't match.
select customers.CustomerName, customers.CustomerID, Orders.OrderID, Orders.OrderDate
from customers full outer join Orders
on customers.CustomerID = Orders.CustomerID;

--Show all orders and products whether matched or not.
select Orders.OrderDate, Orders.OrderDate, Products.ProductID, Products.ProductName
from Products full outer join Orders
on Products.ProductID = Orders.ProductID;

--Display all unmatched customers and orders.
select customers.CustomerName, customers.CustomerID, Orders.OrderID, Orders.OrderDate
from customers full outer join Orders
on customers.CustomerID = Orders.CustomerID
where Orders.OrderID is null
or customers.CustomerID is null;

--Show unmatched products and their attempted orders.
select Products.ProductName, Products.ProductID, Orders.OrderID, Orders.OrderDate
from Products full outer join Orders
on Products.ProductID = Orders.CustomerID
where Orders.OrderID is null
or Products.ProductID is null;

--Show all possible combinations of customers and products.
select Customers.CustomerName, customers.CustomerID, Products.ProductID, Products.ProductName
from customers cross join Products;

--Display all product-customer combinations where country is 'USA'.
SELECT c.CustomerName, c.CustomerID, p.ProductID, p.ProductName, c.Country
FROM Customers c
CROSS JOIN Products p
WHERE c.Country = 'USA';

--Show cross join where price is above $500.
select Products.Price, Products.ProductName, Orders.OrderID 
from Orders cross join Products
where Products.Price > 500;

--Count total number of combinations between customers and products.
select count(*) as total_combination from customers cross join Products;

--Add manager field to Customers and find relationships.
select c.customername as employee, m.customername as manager
from 


--Find customers who have never ordered anything.
select customers.CustomerName, Orders.Quantity
from customers left join Orders
on customers.CustomerID = Orders.CustomerID
where Orders.OrderID is null;

--List products never ordered.
select Products.ProductName, Orders.Quantity
from Products left join Orders
on Products.ProductID = Orders.ProductID
where Orders.OrderID is null;

--Show orders with invalid customers.
select customers.CustomerName, Orders.OrderID
from Orders left join customers
on customers.CustomerID = Orders.CustomerID
where customers.CustomerID is null;


--Find orders with invalid product references.

--left join and product ID is null


--List customers who ordered a laptop.
select c.CustomerName, p.ProductName
from customers as c inner join Orders as o
on c.CustomerID = o.CustomerID
inner join Products as p
on p.ProductID = o.ProductID
where p.ProductName = 'Laptop';

--Show total quantity ordered for each product.
select sum(Orders.Quantity), Products.ProductName
from Products inner join Orders
on Products.ProductID = Orders.ProductID
group by Products.ProductName;

--Get customer names and total amount spent.
select customers.CustomerName, sum(orders.Quantity * Products.Price) as totalspent
from customers inner join Orders
on customers.CustomerID = Orders.CustomerID
inner join Products
on Products.ProductID = Orders.ProductID
group by customers.CustomerName;


select * from customers;
select * from Products;
select * from Orders;

--Show each product with number of times ordered.
select Products.ProductName, count(Orders.Quantity)
from Products left join Orders
on Products.ProductID = Orders.ProductID
group by Products.ProductName;

--Find customers with multiple orders.
select customers.CustomerName, count(Orders.CustomerID) as Max_Count
from customers inner join Orders
on customers.CustomerID = Orders.CustomerID
group by customers.CustomerName
having count(Orders.CustomerID) > 1 ;

--List all products with total revenue generated.
select p.ProductName, sum(p.Price * o.Quantity) as Revenue
from Products as p inner join Orders as o
on p.ProductID = o.ProductID
group by  p.ProductName
order by revenue desc;



--Display all customers and their first order (if any).     
select customers.CustomerName, min(Orders.OrderDate)
from customers left join Orders
on customers.CustomerID = Orders.CustomerID
join Products
on Products.ProductID = Orders.ProductID
group by customers.CustomerName;

--Find products ordered by customers from the UK.
select Products.ProductName, customers.CustomerName
from Products inner join Orders
on Products.ProductID = Orders.ProductID
inner join customers
on customers.CustomerID = Orders.CustomerID
where customers.Country = 'UK';

--Show the most expensive product each customer has ordered.
select customers.CustomerName, max(Products.Price) as Most_Expensive_Order
from customers inner join Orders 
on customers.CustomerID = Orders.CustomerID
inner join Products
on Products.ProductID = Orders.ProductID
group by customers.CustomerName;
--order by max(Products.Price) desc;

--Show customers who ordered both ‘Phone’ and ‘Tablet’.

--inner join where productname in ('phonr', 'Tab') group by customername having count(distinct productname) = 2


--Find which customer has spent the most.
select top 1 customers.CustomerName, sum(Products.Price * Orders.Quantity) as total_spend
from Customers inner join orders
on customers.customerID = orders.customerID
inner join products
on products.productID = orders.productID
group by customers.CustomerName;

--List customers who have placed more than 1 order.
select Customers.CustomerName, count(Orders.OrderID) as order_count
from Customers inner join Orders
on Customers.CustomerID = Orders.CustomerID
group by Customers.CustomerName
having count( Orders.OrderID) > 1;


select * from customers;
select * from Products;
select * from Orders;



--Count number of orders per country.
select customers.Country, count(OrderID)
from Customers left join orders
on Customers.CustomerID = Orders.CustomerID
group by Customers.Country

--Get product details for orders made in March 2023.
select Products.ProductID, Products.ProductName, Products.Price, Orders.OrderID, Orders.Quantity, OrderDate
from products inner join Orders
on Products.ProductID = Orders.ProductID
where year(OrderDate) = 2023 and month(OrderDate) = 03;

--Show all customers who ordered something after Feb 2023.

select customers.CustomerName, customers.CustomerID, Orders.OrderID, Orders.Quantity, OrderDate
from customers inner join Orders
on customers.CustomerID = Orders.CustomerID
where month(OrderDate) > 02;

--List orders with quantities more than 1.
select orders.OrderID, Orders.Quantity
from orders self join Orders
on Orders.Quantity = Orders.Quantity
where Orders.Quantity > 1
--group by orders.orderid;

--Count number of orders per country.
select Customers.Country, count(Orders.Quantity)
from Customers inner join Orders
on Customers.CustomerID = Orders.CustomerID
group by Customers.Country;

--Get product details for orders made in March 2023.
select Products.ProductID, Products.ProductName ,Orders.OrderDate 
from Products inner join Orders
on products.ProductID = Orders.ProductID
where month(Orders.OrderDate) = 03;

--Show all customers who ordered something after Feb 2023.
select Customers.CustomerID, Customers.CustomerName ,Orders.OrderDate 
from Customers inner join Orders
on customers.CustomerID = Orders.CustomerID
where month(Orders.OrderDate) > 02;

--List orders with quantities more than 1.			
select Orders.OrderDate, count(Orders.Quantity)
from Orders self join Orders
on Orders.Quantity = Orders.Quantity
where Orders.Quantity > 1
group by Orders.OrderDate;


--Get total orders placed per customer with total quantity.
select Customers.CustomerName , sum(Orders.Quantity), count(Orders.OrderID)
from Orders inner join Customers
on customers.CustomerID = Orders.CustomerID
group by Customers.CustomerName;

--Show customers and their average order value.
select Customers.CustomerName , avg(Orders.Quantity * Products.Price) as avg_value
from customers inner join Orders
on customers.CustomerID = Orders.CustomerID
inner join Products
on products.ProductID = Orders.ProductID
group by Customers.CustomerName;

--Show all products with unit price above 700 and their orders.

select Products.ProductID, Products.ProductName ,Orders.OrderID, Products.Price 
from Products left join Orders
on products.ProductID = Orders.ProductID
where Products.Price > 700;

--Retrieve all customers whose total spend exceeds $1500.
select Customers.CustomerName , sum(Orders.Quantity * Products.Price) as total_expense
from customers inner join Orders
on customers.CustomerID = Orders.CustomerID
inner join Products
on products.ProductID = Orders.ProductID
group by Customers.CustomerName
having sum(Products.Price) > 1500;

--List all orders where the quantity is not between 1 and 2.






-----------------------------------------------functions--------------------------------------------------------------
use customers;
--concat()
select concat(CustomerName, '-', Country) as full_info from Customers;


--oconvert lower()
select lower(CustomerName) as lower_case_name from customers;


-- convert upper()
select upper(CustomerName) as upper_case_name from customers;


--replace()          remove or replace old values with new values.
--remove - from a phone number
select '123-456-7890' as phone, REPLACE('123-456-7890', '-', '/') as clean_phone;
--replace file ext from txt to csv
select 'report.txt' as old_filename,
REPLACE ('report.txt', '.txt', '.csv') as new_filename;

--len()        calculate length of each customer's name lenghth 
select Customers.CustomerName, len(Customers.CustomerName) as name_length from Customers;

--left()    retrieve first 2 char from each first name
select Customers.CustomerName, left(trim(Customers.CustomerName), 2) as first_2_chars from customers;

--right()    retrieve last 2 char from each first name
select Customers.CustomerName, right(trim(Customers.CustomerName), 2) as first_2_chars from customers;

--substirng()  etrieve a list of customer's firdt name after retreving first letter
select CustomerName(trim(CustomerName), 2, len(CustomerName)) as trimmed_name from customers;

--nesting 
select Customers.CustomerName, upper(lower(Customers.CustomerName)) as nesting from Customers;


select EOMONTH(OrderDate) as EndOfMonth from Orders;

--task 4  
select OrderID, OrderDate,
EOMONTH(OrderDate) as EndOfMonth
from orders;


--task 5    how many orders were placed each year
select year(OrderDate) as OrderYear,
Count(*) as TotalOrders
from orders 
group by year(OrderDate);


--task 6    how many orders were placed each month
select month(OrderDate) as OrderMonth,
Count(*) as TotalOrders
from orders 
group by month(OrderDate);


--task 7    show all orders that were placed during the month of feb
select * from orders where month(orderdate) = 2


--task 8   Format OrderDate into various string representations
select orderid, orderdate,
format(orderdate, 'MM-dd-yyyy') as USA_Format,
format(orderdate, 'dd-MM-yyyy') as EURO_Format,
format(orderdate, 'dd') as dd,
format(orderdate, 'dddd') as dddd,
format(orderdate, 'MM') as MM,
format(orderdate, 'MMM') as MMM,
format(orderdate, 'MMMM') as MMMM	
from orders;

--task 9  display orderdate using a custom format:
--example : day wed jan Q1 2025 12:34:56 PM
select orderid, orderdate,
'Day' + FORMAT(orderdate, 'ddd MMM') +
' Q' + DATENAME(quarter, orderdate) + '' +
FORMAT(orderdate, 'yyyy hh:mm:ss tt') as CustomFormat
from orders;

--task 10   demonstrate conversion using CONVERT
select 
CONVERT(INT, '123') as [String to int convert],
CONVERT(DATE, '2025-08-20') as [String to Date CONVERT],
orderdate,
CONVERT(DATE, orderdate) as [Datetime to Date CONVERT],
CONVERT(VARCHAR, orderdate, 32) as [USA Std.Style:32],
CONVERT(VARCHAR, orderdate, 34) as [EURO Std.Style:34]
from orders;

--task 11  convert data type using CAST

select 
CAST('123' as INT) as [String to INT],
CAST(123 as VARCHAR) as [Int to String],
CAST('2025-08-20' as DATE) as [String to Date],
CAST('2025-08-20' as DATETIME2) as [String to Datetime],
orderdate,
CAST(orderdate as DATE) as [Datetime to Date]
from orders;


--task 12  perform date arithmetic on orderdate
select orderid,
orderdate,
DATEADD(day, -10, orderdate) as TenDaysBefore,
DATEADD(month, 3, Orderdate) as ThreeMonthsLater,
DATEADD(year, 2, orderdate) as TwoYearsLater
from orders;

--task 13     calculate the age of employee
select orderid,
orderdate,
DATEDIFF(year, orderdate, GETDATE()) as Age
from orders;

--task 14  find the avg shipping duration in days for each month 
select 
MONTH(orderdate) as OrderMonth,
AVG(DATEDIFF(day, orderdate, GETDATE())) as AvgShip
from orders 
group by MONTH(orderdate)

--task 15

use SalesDB;
select * from Sales.customers;


select 
Customerid,
firstname,
lastname,
firstname + ' ' + COALESCE(lastname, '') as FullName,
score,
COALESCE(score, 0) + 10 as ScoreWithBonus
from sales.Customers;


--task 16  identify the customer who have no score
select * from sales.customers where score is null;

--task 17    identify the customer who have score
select * from sales.customers where score is not null;

--task 18  retrieve customer details with abbreviated country codes
select 
customerid,
firstname,
lastname,
country,
CASE
	WHEN country = 'Germany' THEN 'GE'
	WHEN country = 'USA' THEN 'US'
ELSE 'n/a'
END AS CountryAbbr
from sales.Customers

--task 19
/*select 
customerid,
firstname,
lastname,
country,
CASE
	WHEN country = 'Germany' THEN 'GE'
	WHEN country = 'USA' THEN 'US'
ELSE 'n/a'
END AS CountryAbbr,*/
CASE Country
	WHEN country  'Germany' THEN 'GE'
	WHEN country  'USA' THEN 'US'
	ELSE 'n/a'
END AS CountryAbbr2,
from sales.Customers