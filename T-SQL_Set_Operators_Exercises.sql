--2

select 1 as n
union all select 2
union all select 3
union all select 4
union all select 5
union all select 6
union all select 7
union all select 8
union all select 9
union all select 10


--3

select custid, empid from Sales.Orders
where orderdate >= '20160101' and orderdate <= '20160201'
except select custid, empid from Sales.Orders
where orderdate >= '20160201' and orderdate <= '20160301'


--4

select custid, empid from Sales.Orders
where orderdate >= '20160101' and orderdate <= '20160201'
intersect select custid, empid from Sales.Orders
where orderdate >= '20160201' and orderdate <= '20160301'


--5

select custid, empid from Sales.Orders
where orderdate >= '20160101' and orderdate <= '20160201'
intersect select custid, empid from Sales.Orders
where orderdate >= '20160201' and orderdate <= '20160301'
except select custid, empid from Sales.Orders
where year(orderdate) != 2016


--6

With t as
(
select 1 num, country, region, city  from HR.Employees
union all
select 2, country, region, city from Production.Suppliers
)
select t.country, t.region, t.city from t order by t.num, t.country, t.region, t.city