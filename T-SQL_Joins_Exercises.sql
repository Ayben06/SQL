--1.1
select H.empid, H.lastname, H.firstname, N.n from HR.Employees H
cross join dbo.Nums N
where N.n <= 5


--1.2
select H.empid, cast('2016-06-' + cast(N.n as char(2)) as date)
from HR.Employees H
cross join dbo.Nums N
where N.n between 12 and 16
order by H.empid


--2
select C.custid, C.companyname, O.orderid, O.orderdate
from Sales.Customers C
inner join Sales.Orders O on C.custid = O.custid


--3
select C.custid, count(distinct O.orderid) as total_orders, sum(OD.qty) as total_quantity from Sales.Customers C
inner join Sales.Orders O on C.custid = O.custid
inner join Sales.OrderDetails OD on OD.orderid = O.orderid
where C.country = 'USA'
group by C.custid


--4
select C.custid, C.companyname, O.orderid, O. orderdate from Sales.Customers C
left join Sales.Orders O on C.custid = O.custid


--5
select C.custid, C.companyname from Sales.Customers C
left join Sales.Orders O on C.custid = O.custid
where O.orderid is null


--6
select C.custid, C.companyname, O.orderid, O. orderdate from Sales.Customers C
inner join Sales.Orders O on C.custid = O.custid
where O.orderdate = '20160212'


--7
select C.custid, C.companyname, O.orderid, O. orderdate from Sales.Customers C
left join Sales.Orders O on C.custid = O.custid
and O.orderdate = '20160212'


--8
select distinct C.custid, C.companyname,
case when O.orderid is not null then 'Yes' else 'No' end as OrderOn12Feb2016
from Sales.Customers C
left join Sales.Orders O on C.custid = O.custid
and O.orderdate = '20160212'