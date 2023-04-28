--1
with C as
( select O.orderid, O.orderdate, O.custid, O.empid,
datefromparts(year(O.orderdate), 12, 31) as endofyear
from Sales.Orders O
)
select orderid, orderdate, custid, empid, endofyear
from C
where orderdate <> endofyear

--2.1
select O.empid, max(O.orderdate) as maxorderdate from Sales.Orders O
group by O.empid


--2.2
with B as
( select O.empid, max(O.orderdate) as maxorderdate
from Sales.Orders O group by empid
)
select O.empid, O.orderdate, O.orderid, O.custid from Sales.Orders O
join B
on O.empid = B.empid and O.orderdate = B.maxorderdate


--3.1
select orderid,orderdate, custid, empid,
row_number() over (order by orderdate asc, orderid asc) as rownum from Sales.Orders


--3.2
with rn as
(select orderid,orderdate, custid, empid,
row_number() over (order by orderdate asc, orderid asc) as rownum from Sales.Orders
)
select rn.* from rn
where rownum between 11 and 20


--4
with EmpCte as
(select empid, mgrid, firstname, lastname
from HR.Employees where empid = 9
union all
select E.empid, E.mgrid, E.firstname, E.lastname from EmpCte C
join HR.Employees E on C.mgrid = E.empid
)
select empid, mgrid, firstname, lastname
from EmpCte


--5.1
drop view if exists Sales.VEmpOrders
go
create view Sales.VEmpOrders
as
select empid, year (orderdate) as orderyear,
sum (qty) as qty from Sales.Orders O
inner join Sales.OrderDetails OD on O.orderid = OD.orderid
group by empid, year(orderdate)
go



--5.2
select *, (select sum (qty) from Sales.VEmpOrders V1
where V1.empid = V2.empid and V1.orderyear <= V2.orderyear) as runqty
from Sales.VEmpOrders as V2
order by empid, orderyear


--6.1
drop function if exists Production.TopProducts
go
create function Production.TopProducts (@supid as int, @n as int)
returns table
as
return
select top(@n) productid, productname, unitprice from Production.Products
where supplierid = @supid order by unitprice desc
go
select * from Production.TopProducts(5, 2)


drop function if exists Production.TopProducts
go
create function Production.TopProducts (@supid as int, @n as int)
returns table
as
return
select productid, productname, unitprice from Production.Products
where supplierid = @supid order by unitprice desc
offset 0 rows fetch next @n rows only
go


--6.2
drop function if exists Production.TopProducts
go
create function Production.TopProducts (@supid as int, @n as int)
returns table
as
return
select top(@n) productid, productname, unitprice from Production.Products
where supplierid = @supid order by unitprice desc
go
select S.supplierid, S.companyname, P.productid, P.productname, P.unitprice
from Production.Suppliers S
	cross apply Production.TopProducts(S.supplierid, 2) P

 