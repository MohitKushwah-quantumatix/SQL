use SalesDB;

--TASK 1: Calculate the Total Sales Across All Orders

select oi.OrderID, sum(oi.Quantity * p.Price) as total_sales
from OrderItems oi inner join Products p
on oi.ProductID = p.ProductID
group by OrderID;


--TASK 2: Calculate the Total Sales for Each Product
select p.ProductName, sum(oi.Quantity * p.Price) as total_sales
from OrderItems oi inner join Products p
on oi.ProductID = p.ProductID
group by p.ProductName
order by total_sales desc;

--TASK 3: Find the total sales across all orders, additionally providing details such as OrderID and OrderDate
select oi.OrderID, o.orderdate, sum(oi.Quantity * p.Price) as total_sales
from OrderItems oi inner join orders o
on oi.OrderID = o.OrderID
inner join Products p
on p.ProductID = oi.ProductID
group by oi.OrderID, o.OrderDate;

--TASK 4: Find the total sales across all orders and for each product, additionally providing details such as OrderID and OrderDate
select o.orderid, o.orderdate, p.ProductName, sum(oi.Quantity * p.Price) as total_sales
from OrderItems oi inner join Orders o
on oi.OrderID = o.OrderID
inner join Products p
on p.ProductID = oi.ProductID
group by o.OrderID, o.orderdate, p.ProductName;

--TASK 5: Find the total sales across all orders, for each product, 
-- and for each combination of product and order status, 
-- additionally providing details such as OrderID and OrderDate
/*order status, sales, orderID , orderDate - order 
product - product*/
select distinct sum(Sales)  over() as totalsale, 
product, sum(Sales)  over(partition by product) as salesPerProduct ,
orderid, sum(Sales)  over(partition by orderid) as salesPerorder 
from sales.Orders inner join sales.Products
on Sales.Orders.ProductID = sales.Products.ProductID;


--TASK 6: Rank each order by Sales from highest to lowest
select orderid,sales,
rank() over( order by sales desc ) as ranking 
from sales.Orders;

--TASK 7: Calculate Total Sales by Order Status for current and next two orders
select orderid, orderstatus,
sum(sales) over( partition by orderstatus order by sales desc rows between current row and 2 following ) as total_sales_by_OrderStatus
from sales.Orders;

--TASK 8: Calculate Total Sales by Order Status for current and previous two orders
select orderid, orderstatus,
sum(sales) over( partition by orderstatus order by sales desc rows between 2 preceding and current row  ) as total_sales_by_OrderStatus
from sales.Orders;

--TASK 9: Calculate Total Sales by Order Status from previous two orders only
select orderid, orderstatus,
sum(sales) over( partition by orderstatus order by sales desc rows between 2 preceding and 1 preceding) as total_sales_by_OrderStatus
from sales.Orders;

select * from sales.Orders;



----------------------------------------------NOTES-----------------------------------------------------------
/*
1. rows between 2 preceding and current row
2. rows between current row and 2 following
3. rows between 2 preceding and 1 preceding
4. rows between 1 following and 2 following
*/
---------------------------------------------------------------------------------------------------------------




--TASK 10: Calculate cumulative Total Sales by Order Status up to the current order
select orderstatus, sum(sales) over(partition by orderstatus order by sales desc rows between unbounded preceding and current row) as cumulative_sum
from sales.Orders;

--TASK 11: Calculate cumulative Total Sales by Order Status from the start to the current row
select orderstatus, sum(sales) over(partition by orderstatus order by sales desc rows between unbounded preceding and current row) as cumulative_sum
from sales.Orders;

--TASK 12: Rank customers by their total sales
select firstname,
sum(sales) as total_sales,
rank() over(order by sum(sales) desc)
from Sales.Orders inner join Sales.Customers
on Sales.Orders.CustomerID = Sales.Customers.CustomerID
group by FirstName;


--------------------------------------------------------------------------------------------------------------



--TASK 1: Find the Total Number of Orders and the Total Number of Orders for Each Customer
select distinct FirstName,
count(orderid) over() as total_orders,
count(orderID) over(partition by firstname) as orders_each_customer
from Sales.Orders inner join Sales.Customers
on Sales.Customers.CustomerID = Sales.Orders.CustomerID;


--TASK 2: Find the Total Number of Customers, the Total Number of Scores for Customers, and the Total Number of Countries
select distinct count(customerid) over() as total_customers,
sum(score) over() as total_score,
count(Country) over() as total_Countries
from Sales.Customers;

--TASK 3: Check whether the table 'OrdersArchive' contains any duplicate rows
select distinct * from Sales.OrdersArchive;
select (
select count(*) from Sales.OrdersArchive) -(
select distinct count(*) from Sales.OrdersArchive) as duplicate_row;

--TASK 4: Find the Total Sales Across All Orders and the Total Sales for Each Product

select distinct product, sum(Sales)  over() as total_sale,
sum(sales) over(partition by product) as total_sale_per_product
from Sales.Orders inner join sales.Products
on Sales.Orders.ProductID = Sales.Products.ProductID;

--TASK 5: Find the Percentage Contribution of Each Product's Sales to the Total Sales

select product, c.total_sale_per_product, c.Total_sales, round(((c.total_sale_per_product/ cast(c.Total_sales as float)) * 100), 2) as percentage from (
select distinct product, sum(sales) over() as Total_sales,
sum(sales) over(partition by product ) as total_sale_per_product
from Sales.Orders inner join sales.Products
on Sales.Orders.ProductID = Sales.Products.ProductID
) as c

--TASK 6: Find the Average Sales Across All Orders and the Average Sales for Each Product
select distinct product,
avg(sales) over() as avg_sales,
avg(sales) over(partition by product) as avg_per_product
from Sales.Orders inner join sales.Products
on Sales.Orders.ProductID = Sales.Products.ProductID;

--TASK 7: Find the Average Scores of Customers
select distinct firstname, avg(score) over() as avg_score from sales.Customers;

--TASK 8: Find all orders where Sales exceed the average Sales across all orders
select distinct orderid, sales from( select orderid, sales, 
avg(Sales) over() as avg_sales
from Sales.Orders) as avg_exceeded_orders
where sales > avg_sales;

--TASK 9: Find the Highest and Lowest Sales across all orders
select distinct 
max(sales) over() as highest_sales,
min(sales) over() as lowest_sales
from Sales.Orders;

--TASK 10: Find the Lowest Sales across all orders and by Product
select distinct product, 
min(sales) over(partition by product) as Lowest_sale_product
from sales.Orders inner join sales.Products
on sales.Orders.ProductID = sales.Products.ProductID;

--TASK 11: Show the employees who have the highest salaries
select EmployeeID, firstname, salary , 
max(salary) over(order by salary desc) as Highest_salary_employee
from Sales.Employees;

--other method
select EmployeeID, firstname, Salary from Sales.Employees where salary =( select max(salary) from Sales.Employees) ;


--TASK 12: Find the deviation of each Sale from the minimum and maximum Sales
select sales,
min(sales) over() as min_sales_value,
sales - min(sales) over() as deviation_from_min,
max(sales) over() as max_sales_value,
sales - max(sales) over() as deviation_from_max
from Sales.Orders;


--TASK 13: Calculate the moving average of Sales for each Product over time
SELECT 
    product,
    creation_time,
    sales,
    AVG(sales) OVER (
        PARTITION BY product
        ORDER BY creation_time
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS moving_avg_sales
FROM sales.Orders inner join Sales.Products
on Sales.Orders.ProductID = sales.Products.ProductID;

--TASK 14: Calculate the moving average of Sales for each Product over time, including only the next order
SELECT 
    product,
    creation_time,
    sales,
    AVG(sales) OVER (
        PARTITION BY product
        ORDER BY creation_time
        ROWS BETWEEN 2 PRECEDING AND 1 PRECEDING
    ) AS moving_avg_sales
FROM sales.Orders inner join Sales.Products
on Sales.Orders.ProductID = sales.Products.ProductID;


select * from sales.Customers;
select * from sales.Employees;
select * from sales.Orders;
select * from sales.Products;
