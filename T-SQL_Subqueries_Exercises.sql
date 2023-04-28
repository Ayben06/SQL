--1

select O.orderid, O.orderdate, O.custid, O.empid from Sales.Orders O
where orderdate = (select max (orderdate) from Sales.Orders)
order by orderid desc


--2

select O.custid, O.orderid, O.orderdate, O.empid from Sales.Orders O
where custid in (select top (1) with ties custid from Sales.Orders
group by custid order by count (*) desc)


--3

select E.empid, E.firstname, E.lastname from HR.Employees E
where empid not in (select O.empid from Sales.Orders O
where O.orderdate >= '20160501')


--4

select distinct country from Sales.Customers C
where C.country not in (select E.country from HR.Employees E)


--5

select O1.custid, O1.orderid, O1.orderdate, O1.empid from Sales.Orders O1
where orderdate = (select max (O2.orderdate) from Sales.Orders O2
where O1.custid = O2.custid)
order by custid asc


--6

select * from Sales.Customers
select * from Sales.Orders

select C.custid, C.companyname from Sales.Customers C
where exists (
select * from Sales.Orders O
where C.custid = O.custid
and O.orderdate >= '20150101' and O.orderdate < '20160101')
and not exists (
select * from Sales.Orders O
where C.custid = O.custid
and O.orderdate >= '20160101' and O.orderdate < '20170101')

select distinct C.custid, C.companyname, year(so1.orderdate), year(so2.orderdate)
from Sales.Customers C
Inner Join Sales.Orders so1 on C.custid = so1.custid And year(so1.orderdate) = '2015'
Left Outer Join Sales.Orders so2 on C.custid = so2.custid And year(so2.orderdate) = '2016'
Where so2.custid is null

select C.custid, C.companyname
from Sales.Customers C
Inner Join Sales.Orders so1 on C.custid = so1.custid And year(so1.orderdate) = '2015'
except
select C.custid, C.companyname
from Sales.Customers C
Inner Join Sales.Orders so1 on C.custid = so1.custid And year(so1.orderdate) = '2016'


--7

select C.custid, C.companyname from Sales.Customers C
where custid in(
select custid from Sales.Orders O
where C.custid = O.custid
and orderid in(
select orderid from Sales.OrderDetails OD
where OD.productid = 12))


--8

select *, (select sum(O2.qty) from Sales.CustOrders O2
where O2.custid = O1.custid
and O2.ordermonth <= O1.ordermonth) as runqty
from Sales.CustOrders O1
order by custid, ordermonth


--10

select O1.custid, O1.orderdate, O1.orderid, datediff(day, (select top (1) O2.orderdate from Sales.Orders O2
where O2.custid = O1.custid
and (O2.orderdate = O1.orderdate and o2.orderid < o1.orderid or o2.orderdate < O1.orderdate)
order by O2.orderdate desc, O2.orderid desc), orderdate) as DateDifference from Sales.Orders O1
order by custid, orderdate, orderid