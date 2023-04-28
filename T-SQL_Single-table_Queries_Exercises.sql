--1
select orderid,orderdate, custid, empid from Sales.Orders
where orderdate between '20150601' and '20150630'

select orderid,orderdate, custid, empid from Sales.Orders
where YEAR(orderdate) = 2015 and MONTH(orderdate) = 06


--2
select orderid,orderdate, custid, empid from Sales.Orders
where orderdate = EOMONTH(orderdate)


--3
select empid, firstname, lastname from HR.Employees
where lastname like '%e%e%'


--4
select orderid, sum(qty*unitprice) as totalvalue
from Sales.OrderDetails
group by orderid
having sum(qty*unitprice) > 10000
order by totalvalue desc


--5
select empid, lastname from hr.Employees
where lastname collate Latin1_General_CS_AS = '[A-Z]'

select empid, lastname from hr.Employees
where lastname collate Latin1_General_CS_AS = '[abcdefghijklmnopqrstuvwxyz]%'


--7
select top (3) shipcountry, avg(freight) as 'highest average' from Sales.Orders
where year(shippeddate) = '2015'
group by shipcountry
order by [highest average] desc


--8
select custid, orderdate, orderid, row_number() over (partition by custid order by orderdate, custid asc) as 'rownum' from Sales.Orders


--9
select empid, firstname, lastname, titleofcourtesy, case titleofcourtesy
		when 'Ms'  then 'Female'
		when 'Mrs' then 'Female'
		when 'Mr' then 'Male'
		else 'Unknown'
		end 'gender'
from HR.Employees


--10
select custid, region
from Sales.Customers
order by case when region IS NULL then 0 else 1 end desc