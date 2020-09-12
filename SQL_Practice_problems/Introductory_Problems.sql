/* 1. Which shippers do we have?*/
select * from Northwind.dbo.Shippers


/* 2. Certain fields from Categories */
select  CategoryName, Description from Northwind.dbo.Categories


/* 3. Sales Representatives */
select FirstName, LastName, HireDate from Northwind.dbo.Employees where Title='Sales Representative'


/* 4. Sales Representatives in the United States */
select FirstName, LastName, HireDate from Northwind.dbo.Employees where Title='Sales Representative' and Country='USA'


/* 5. Orders placed by specific EmployeeID */
select OrderID, OrderDate from Northwind.dbo.Orders where employeeid=5


/* 6. Suppliers and ContactTitles */
select SupplierID, ContactName, ContactTitle from Northwind.dbo.Suppliers where ContactTitle!= 'Marketing Manager'


/* 7. Products with “queso” in ProductName*/
select ProductID, ProductName from Northwind.dbo.Products where ProductName like '%queso%'

/* 8. Orders shipping to France or Belgium*/
select OrderID, CustomerID, ShipCountry from Northwind.dbo.Orders where ShipCountry in ('France','Belgium')

/* 9. Orders shipping to any country in Latin America*/
select OrderID, CustomerID, ShipCountry from Northwind.dbo.Orders where ShipCountry in ('Brazil','Mexico','Argentina','Venezuela')


/* 10. Employees, in order of age*/
select FirstName, LastName, Title, BirthDate from Northwind.dbo.Employees order by BirthDate


/* 11. Showing only the Date with a DateTime field*/
select FirstName, LastName, Title, CONVERT(date, BirthDate) from Northwind.dbo.Employees order by BirthDate


/* 12. Employees full name*/
select FirstName, LastName, concat(FirstName,' ', LastName) as FullName from Northwind.dbo.Employees


/*13. OrderDetails amount per line item*/
select OrderID, ProductID, UnitPrice, Quantity, (UnitPrice*Quantity) as TotalPrice from Northwind.dbo.OrderDetails 


/* 14. How many customers?*/
select count(1) as TotalCustomers from Northwind.dbo.Customers


/* 15. When was the first order?*/
select min(OrderDate) as FirstOrder from Northwind.dbo.Orders


/* 16. Countries where there are customers*/
select distinct Country from Northwind.dbo.Customers


/* 17. Contact titles for customers*/
select ContactTitle, count(1) as TotalContactTitle
from Northwind.dbo.Customers
group by ContactTitle
order by TotalContactTitle desc


/* 18. Products with associated supplier names*/
select ProductID, ProductName, CompanyName as Supplier
from  Northwind.dbo.products p join  Northwind.dbo.suppliers s
on p.SupplierID=s.SupplierID


/* 19. Orders and the Shipper that was used*/
select OrderID, OrderDate, CompanyName
FROM Northwind.dbo.Orders O join Northwind.dbo.Shippers S 
on O.ShipVia=s.ShipperID
where OrderID < 10300
 

