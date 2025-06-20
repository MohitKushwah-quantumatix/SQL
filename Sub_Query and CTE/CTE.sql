use SalesDB;
-- Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    Country VARCHAR(50)
);

INSERT INTO Customers (CustomerID, CustomerName, Country) VALUES
(1, 'Alice', 'USA'),
(2, 'Bob', 'Canada'),
(3, 'Charlie', 'USA'),
(4, 'Diana', 'UK'),
(5, 'Evan', 'USA'),
(6, 'Fiona', 'Germany'),
(7, 'George', 'France'),
(8, 'Hannah', 'USA'),
(9, 'Ian', 'India'),
(10, 'Julia', 'Australia');

-- Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2)
);

INSERT INTO Products (ProductID, ProductName, Price) VALUES
(1, 'Laptop', 1200.00),
(2, 'Phone', 800.00),
(3, 'Tablet', 500.00),
(4, 'Monitor', 300.00),
(5, 'Keyboard', 50.00),
(6, 'Mouse', 30.00),
(7, 'Printer', 150.00),
(8, 'Desk', 200.00);

-- Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate) VALUES
(1, 1, '2024-01-05'),
(2, 2, '2024-01-12'),
(3, 1, '2024-03-05'),
(4, 3, '2024-04-10'),
(5, 4, '2024-02-20'),
(6, 5, '2024-03-15'),
(7, 5, '2024-04-01'),
(8, 6, '2024-04-05'),
(9, 7, '2024-01-22'),
(10, 8, '2024-04-11'),
(11, 1, '2024-04-15'),
(12, 8, '2024-03-25'),
(13, 3, '2024-04-20'),
(14, 9, '2024-02-10'),
(15, 5, '2024-04-22');

-- OrderItems
CREATE TABLE OrderItems (
    OrderItemID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

INSERT INTO OrderItems (OrderItemID, OrderID, ProductID, Quantity) VALUES
(1, 1, 1, 1),
(2, 1, 5, 2),
(3, 2, 2, 1),
(4, 3, 3, 1),
(5, 4, 1, 1),
(6, 5, 4, 1),
(7, 6, 2, 2),
(8, 7, 6, 3),
(9, 8, 5, 1),
(10, 9, 8, 1),
(11, 10, 7, 1),
(12, 11, 1, 2),
(13, 12, 2, 1),
(14, 13, 3, 2),
(15, 14, 4, 1),
(16, 15, 5, 4),
(17, 3, 6, 2),
(18, 7, 7, 1),
(19, 12, 5, 2),
(20, 13, 6, 1);


select * from customers;
select * from Products;
select * from Orders;
select * from OrderItems;

--Write a CTE to find customers from the "USA" and their order count.
with customer_order as (
select c.CustomerID,CustomerName, count(Orders.OrderID) as Order_count, c.Country
from customers as c left join Orders
on c.CustomerID = Orders.CustomerID
where c.CustomerID in (select c.CustomerID
from customers
where c.Country = 'USA')
group  by c.CustomerID, c.CustomerName, c.Country
)

select CustomerID, CustomerName, Country, Order_count from customer_order;


--Find all customers who have placed an order of more than 1000 using a subquery in the WHERE clause.
select c.customerid, c.customername, sum(p.Price * oi.Quantity) as total_spent
from customers c inner join Orders o 
on c.CustomerID = o.CustomerID
inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p 
on oi.ProductID = p.ProductID

WHERE c.CustomerID IN (
    SELECT c2.CustomerID
    FROM customers c2
    INNER JOIN Orders o2 ON c2.CustomerID = o2.CustomerID
    INNER JOIN OrderItems oi2 ON o2.OrderID = oi2.OrderID
    INNER JOIN Products p2 ON oi2.ProductID = p2.ProductID
    GROUP BY c2.CustomerID
    HAVING SUM(p2.Price * oi2.Quantity) > 1000)
group by c.CustomerID, c.CustomerName;

--Use a subquery in the FROM clause to calculate the total amount spent by each customer.
select *
from (
select c.customerid, c.customername, sum(p.price * oi.quantity) as total_spent
from customers c inner join Orders o 
on c.CustomerID = o.CustomerID
inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p 
on oi.ProductID = p.ProductID 
group by c.customerid, c.customername) as total_spent_per_customer



--Use a subquery in the SELECT clause to fetch the number of orders placed by each customer.
select customers.CustomerName, (
select count(*)                             -- co-related sub query 
from Orders
where customers.CustomerID = Orders.CustomerID
) as Order_placed
from customers;

--Write a CTE to get all orders placed after '2024-03-01' and then find their total sum.

with orders_placed as (
select o.OrderID , sum(p.price * oi.quantity) as total_sum, o.orderdate
from Orders o inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p
on oi.ProductID = p.ProductID
where o.OrderDate in                 --'2024-03-01' 
(
select o.OrderDate from Orders where o.OrderDate > '2024-03-01'
)
group by o.OrderDate, o.OrderID
)
select orderid, total_sum, orderdate from orders_placed;

--Write a CTE that finds each customer's first order date.

with cte as (
select c.customerid, c.customername, o.orderdate,
rank() over(partition by c.customerid order by o.orderdate asc) as ranked
from customers c inner join Orders o
on c.CustomerID = o.CustomerID
group by c.customerid, c.customername, o.orderdate
)

select customerid, customername, orderdate from cte 
where ranked = 1;

--Write a CTE and inside it, join customers with their orders, and then select those who have total spending > 1500.
with cte as (
select c.customerid, c.customername, count(o.orderid) as order_count, sum(p.price * oi.quantity) as total_spent
from customers c inner join Orders o
on c.CustomerID = o.CustomerID
inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p  
on oi.ProductID = p.ProductID
where c.CustomerID in (

select c.CustomerID 
from  customers c inner join Orders o 
on c.CustomerID = o.CustomerID
inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p  
on oi.ProductID = p.ProductID
group by c.CustomerID, o.OrderID, c.CustomerName 
having sum(p.price * oi.quantity) > 1500
)
group by c.customerid, c.customername
)

select customerid, customername, order_count, total_spent from cte;


--other method (correct outputs)

with cte as (
select c.customerid, c.customername, count(o.orderid) as order_count, sum(p.price * oi.quantity) as total_spent
from customers c inner join Orders o
on c.CustomerID = o.CustomerID
inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p  
on oi.ProductID = p.ProductID
group by c.customerid, c.customername
)

select customerid, customername, order_count, total_spent from cte
where total_spent > 1500

--Find customers who have never placed an order (using subquery with NOT EXISTS).
SELECT c.CustomerID, c.CustomerName
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.CustomerID = c.CustomerID
);

--Use a scalar subquery in the SELECT to add the Average Order Amount for each customer.

select c.CustomerName,(
select avg(p.price*oi.quantity)
from OrderItems oi join Products p on oi.ProductID=p.ProductID
join Orders o on oi.OrderID=o.OrderID
where o.CustomerID=c.CustomerID) as avg_c  --co-related sub-query
from Customers c;

--Create a CTE to list orders along with the number of items per order.
with cte as (
select oi.orderid, count(*) over(partition by p.productname) as product_count, p.ProductName
from  OrderItems oi
inner join Products p 
on p.ProductID = oi.ProductID
group by oi.orderid, p.ProductName
)
select pp.orderid, product_count, pp.productname from cte as pp
order by pp.OrderID;

--Write a recursive CTE to generate a sequence of dates between '2024-01-01' and '2024-01-10'.

--Write a CTE to calculate cumulative total sales per customer based on order date (running total).
WITH CustomerSales AS (
  SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate,
    SUM(p.Price * oi.Quantity) AS OrderAmount
  FROM Customers c
  JOIN Orders o ON c.CustomerID = o.CustomerID
  JOIN OrderItems oi ON o.OrderID = oi.OrderID
  JOIN Products p ON oi.ProductID = p.ProductID
  GROUP BY c.CustomerID, c.CustomerName, o.OrderID, o.OrderDate
),
RunningTotal AS (
  SELECT 
    CustomerID,
    CustomerName,
    OrderID,
    OrderDate,
    OrderAmount,
    SUM(OrderAmount) OVER (
      PARTITION BY CustomerID
      ORDER BY OrderDate
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS CumulativeSales
  FROM CustomerSales
)
SELECT * FROM RunningTotal;

--Use a subquery to find products that were never ordered.
select p.ProductID, o.orderid
from Products p inner join OrderItems oi 
on p.ProductID=oi.ProductID
inner join Orders o 
on o.OrderID = oi.OrderID
where p.ProductID in (
select p.productid 
from Products p inner join OrderItems oi 
on p.ProductID=oi.ProductID
inner join Orders o 
on o.OrderID = oi.OrderID
where o.OrderID is null
);

--Use a subquery to find customers who have more than 2 orders.
select c.customerid, c.customername 
from customers c
where c.CustomerID in (
select c.customerid
from customers c inner join Orders o
on c.CustomerID = o.CustomerID
group by c.CustomerID
having count(o.OrderID) > 2
)

--Create a CTE that ranks products by how many times they were ordered.
with cte as (
select p.productid,p.ProductName, count(o.orderid) as product_count
from customers c inner join Orders o
on c.CustomerID = o.CustomerID
inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p  
on oi.ProductID = p.ProductID
group by  p.productid,p.ProductName
--order by count(o.orderid) desc
)

select productid , ProductName, product_count from cte 
order by product_count desc

--Write a query using a CTE to find top 2 customers who spent the most.
with cte as (
select c.customerid, c.customername, sum(p.price * oi.quantity) as total_expense
from customers c inner join Orders o
on c.CustomerID = o.CustomerID
inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p  
on oi.ProductID = p.ProductID 
group by c.customerid, c.customername
)

select top 2 customerid, customername , total_expense from cte 
order by total_expense desc;

--Use a CTE + subquery to find, for each product, the maximum quantity ordered in a single order.
with cte as (
select p.productid, p.productname, max(oi.Quantity) as max_quantity_ordered
from Orders o
inner join OrderItems oi
on o.OrderID = oi.OrderID                        
inner join Products p  
on oi.ProductID = p.ProductID
group by p.productid, p.productname
)
select productid, productname, max_quantity_ordered from cte;




--Find all orders where the ordered product price was greater than the average product price.
with cte as (
select p.productid, p.productname, p.price
from Products p
where p.Price > (
select avg(p.price * oi.quantity)
from Products p inner join OrderItems oi
on p.ProductID = oi.ProductID)
)
select productid, productname, price from cte;


/*Write a query where:

First CTE fetches customers and total orders.

Second CTE fetches customers and total amount spent.

Main query joins both CTEs.*/

with cte1 as (
select c.customerid, c.customername, count(o.orderid) as total_orders
from customers c inner join Orders o 
on c.CustomerID = o.CustomerID
group by c.CustomerID, c.CustomerName
),

cte2 as (
select c.customerid, c.customername, sum(p.price * oi.quantity) as total_spent
from customers c inner join Orders o
on c.CustomerID = o.CustomerID
inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p  
on oi.ProductID = p.ProductID 
group by  c.customerid, c.customername
)
--select customerid, customername, total_spent from cte2;

select * from 
cte1 join cte2 
on cte1.customerid = cte2.CustomerID;

--Find customers who ordered a Laptop using a subquery inside WHERE.
select c.customerid, c.customername
from customers c inner join Orders o
on c.CustomerID = o.CustomerID
inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p  
on oi.ProductID = p.ProductID 
where c.CustomerID in  (
select distinct c.CustomerID  
from customers c inner join Orders o
on c.CustomerID = o.CustomerID
inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p  
on oi.ProductID = p.ProductID 
where p.ProductName = 'Laptop'
)
group by c.customerid, c.customername;

--Recursive CTE to find order dependency (Suppose orders that reference previous orders - can simulate).


--Write a CTE to calculate moving average of order amounts per customer based on order date.
with cte as (
select c.customerid, c.customername, o.orderdate, 
sum(p.price * oi.quantity) as total_spent
from customers c inner join Orders o
on c.CustomerID = o.CustomerID
inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p  
on oi.ProductID = p.ProductID 
group by c.customerid, c.customername, o.Orderdate
)
select customerid, customername, orderdate,
avg(total_spent) over(partition by customerid order by orderdate rows between 1 preceding and current row) as moving_avg_price
from cte;

--Find customers whose every order had an amount greater than 300 (using ALL in a subquery).
with cte as (
select c.customerid, c.customername
from customers c
where 300 < all (
select sum(p.price * oi.quantity)
from  Orders o
inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p  
on oi.ProductID = p.ProductID 
where c.CustomerID = o.CustomerID
group by o.OrderID)
)
select customerid, customername from cte;
--Use EXISTS to find products that are included in at least one order.


--Find the customer(s) who placed the maximum total amount of orders (use subquery with aggregation).
with cte as (
select c.customerid, c.customername, sum(p.price * oi.quantity) as total_order_amount
from customers c inner join Orders o
on c.CustomerID = o.CustomerID
inner join OrderItems oi
on o.OrderID = oi.OrderID
inner join Products p  
on oi.ProductID = p.ProductID 
group by  c.customerid, c.customername
)

select customerid, customername, total_order_amount from cte
where total_order_amount =  (select max(total_order_amount) from cte);
