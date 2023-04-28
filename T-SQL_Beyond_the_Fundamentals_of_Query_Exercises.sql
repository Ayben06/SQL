drop table if exists dbo.Orders

create table dbo.Orders
(
orderid int not null,
orderdate date not null,
empid int not null,
custid varchar(5) not null,
qty int not null,
constraint PK_Orders primary key(orderid)
)


insert into dbo.Orders(orderid, orderdate, empid, custid, qty)
values
(30001, '20140802', 3, 'A', 10),
(10001, '20141224', 2, 'A', 12),
(10005, '20141224', 1, 'B', 20),
(40001, '20150109', 2, 'A', 40),
(10006, '20150118', 1, 'C', 14),
(20001, '20150212', 2, 'B', 12),
(40005, '20160212', 3, 'A', 10),
(20002, '20140802', 1, 'C', 20),
(30003, '20160216', 2, 'B', 15),
(30004, '20140418', 3, 'C', 22),
(30007, '20160907', 3, 'D', 30)

select * from dbo.Orders


--1

select custid, orderid, qty,
rank() over(partition by custid order by qty) as rnk,		
dense_rank() over(partition by custid order by qty) as drnk
from dbo.Orders


--2

select val, row_number() over(order by val) as rownum from Sales.OrderValues
group by val

with C as
(
select distinct val from Sales.OrderValues
)
select val, row_number() over(order by val) as rownum
from C


--3

select custid, orderid, qty,
qty - lag(qty) over(partition by custid order by orderdate, orderid) as prev_qty,
qty - lead(qty) over(partition by custid order by orderdate, orderid) as next_qty
from dbo.Orders


--4

select empid, count(case when orderyear = 2014 then orderyear end) as cnt2014,
count(case when orderyear = 2015 then orderyear end) as cnt2015,
count(case when orderyear = 2016 then orderyear end) as cnt2016
from (select empid, year(orderdate) as orderyear from dbo.Orders) O
group by empid



drop table if exists dbo.Orders