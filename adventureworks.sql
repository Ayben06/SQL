--1 (Adventureworks exercise )

select 
* 
from  HumanResources.Employee 
order by JobTitle asc;

--2

select 
*
from Person.Person
order by LastName asc;

--3

select 
	FirstName,
	LastName,
	BusinessEntityID as Employee_id
from Person.Person
order by LastName asc;

--4

select 
productid, 
productnumber,  
name
from Production.Product 
where ProductLine='T' and SellStartDate is not null 
order by name asc;

--5

select 
salesorderid, 
customerid, 
orderdate, 
subtotal, 
100*TaxAmt/SubTotal as tax_percentage
from Sales.SalesOrderHeader order by SubTotal desc;

--6

select
distinct(JobTitle)
from HumanResources.Employee order by JobTitle asc;

--7
select 
CustomerID,
sum(Freight)
from Sales.SalesOrderHeader group by CustomerID order by CustomerID;

--8

select 
CustomerID,
SalesPersonID,
AVG( SubTotal),
SUM ( SubTotal)
from Sales.SalesOrderHeader group by CustomerID, SalesPersonID order by CustomerID desc;

--9

select
ProductID,
SUM(Quantity)
from Production.ProductInventory where Shelf in ('A','C','H') group by ProductID order by ProductID asc;

--10

select
sum (Quantity)*10
from Production.ProductInventory  group by LocationID ;

--11

select 
t.BusinessEntityID, 
p.FirstName, 
p.LastName, 
t.PhoneNumber
from Person.PersonPhone t
inner join Person.Person p on t.BusinessEntityID=p.BusinessEntityID
where p.LastName like 'L%' order by LastName, FirstName asc;

--12

select
SalesPersonID,
CustomerID,
sum (SubTotal) as 'total of Subtotal'
from Sales.SalesOrderHeader group by SalesPersonID, CustomerID  order by SalesPersonID asc;

--13

select 
LocationID,
Shelf,
sum (Quantity)
from Production.ProductInventory group by cube(LocationID, Shelf) 

--16

select 
City,
count(BusinessEntityID)
from Person.BusinessEntityAddress a 
inner join Person.Address p on a.AddressID=p.AddressID group by City order by City;

--17

select 
YEAR(orderDate) as years,
sum(TotalDue) as 'amount of sales'
from Sales.SalesOrderHeader  group by YEAR(orderDate) order by years;

--18

select 
YEAR(orderDate) as years,
sum(TotalDue) as 'amount of sales'
from Sales.SalesOrderHeader  group by YEAR(orderDate) having YEAR(orderDate) <=2016 order by years;

--19

select 
ContactTypeID,
Name
from Person.ContactType where name like '%Manager%' order by 1 desc;

--20

select 
p.BusinessEntityID,
p.LastName,
p.FirstName
from person.Person p
inner join person.BusinessEntityContact b on b.PersonID=p.BusinessEntityID 
inner join Person.ContactType c on  b.ContactTypeID=c.ContactTypeID
where c.Name ='Purchasing Manager' order by 2, 3 asc;

--21 

select 
* from Sales.SalesPerson;
select lastname from Person.Person;
select
PostalCode from Person.Address;

select
sp.salesytd,
pa.postalcode,
pp.lastname,
ROW_NUMBER() over  (partition by pa.PostalCode order by sp.salesytd desc) as rownumber
from Sales.SalesPerson sp inner join Person.Person pp
on sp.BusinessEntityID=pp.BusinessEntityID
inner join Person.Address pa 
on pa.AddressID=pp.BusinessEntityID
where sp.TerritoryID is not null and sp.salesytd !=0 ;

--22

select * from Person.BusinessEntityContact;

select * from Person.ContactType;

select 
count(pb.ContactTypeID),
Name,
pb.ContactTypeID
from Person.BusinessEntityContact pb inner join Person.ContactType pc 
on pb.ContactTypeID=pc.ContactTypeID group by Name,pb.ContactTypeID
having  count(pb.ContactTypeID)>100;

--23

select * from HumanResources.EmployeePayHistory;

select * from Person.Person;

select
CONVERT(DATE,eh.RateChangeDate),
CONCAT( pp.LastName,' ',pp.MiddleName,' ',pp.FirstName ) as Names,
rate*40
from Person.Person pp inner join HumanResources.EmployeePayHistory eh on
pp.businessentityid = eh.businessentityid order by Names asc;

--24

select * from HumanResources.EmployeePayHistory
select * from Person.Person
select
CONVERT(DATE,eh.RateChangeDate),
CONCAT( pp.LastName,' ',pp.MiddleName,' ',pp.FirstName ) as Names,
rate*40
from Person.Person pp inner join HumanResources.EmployeePayHistory eh on
pp.businessentityid = eh.businessentityid 
where eh.RateChangeDate=( select MAX(eph.RateChangeDate) 
									from HumanResources.EmployeePayHistory eph 
									where eph.BusinessEntityID=eh.BusinessEntityID)
order by Names asc;

--25

select
s.salesorderid,
s.ProductID,
sum (s.OrderQty) over (partition by s.SalesOrderID order by s.ProductID desc) as sum,
max (s.OrderQty) over (partition by s.SalesOrderID order by s.ProductID desc) as max,
min (s.OrderQty) over (partition by s.SalesOrderID order by s.ProductID desc) as min,
avg (s.OrderQty) over (partition by s.SalesOrderID order by s.ProductID desc) as avg,
count (s.OrderQty) over (partition by s.SalesOrderID order by s.ProductID desc) as count
 from Sales.SalesOrderDetail as s
 where SalesOrderID in( 43659 ,43664) ;

 --26

 select
s.salesorderid,
s.ProductID,
s.OrderQty,
sum (s.OrderQty) over (ORDER by s.SalesOrderID, s.ProductID) as sum,
avg (s.OrderQty/1.0) over (partition by s.SalesOrderID ORDER BY SalesOrderID, ProductID) as avg,
count (s.OrderQty) over (partition by s.SalesOrderID ) as count
 from Sales.SalesOrderDetail as s
 where SalesOrderID in( 43659 ,43664) and cast(s.ProductID as varchar) like '71%'
 order by 1,2  ;

 --answer
 SELECT SalesOrderID AS OrderNumber, ProductID,
    OrderQty AS Quantity,
    SUM(OrderQty) OVER (ORDER BY SalesOrderID, ProductID) AS Total,
    AVG(OrderQty) OVER(PARTITION BY SalesOrderID ORDER BY SalesOrderID, ProductID) AS Avg,
    COUNT(OrderQty) OVER(ORDER BY SalesOrderID, ProductID ROWS BETWEEN UNBOUNDED PRECEDING AND 1 FOLLOWING) AS Count
FROM Sales.SalesOrderDetail
WHERE SalesOrderID IN(43659,43664) and CAST(ProductID AS TEXT) LIKE '71%';

 --27

select salesorderid, sum(OrderQty*UnitPrice) from Sales.SalesOrderDetail
group by SalesOrderID  having sum(OrderQty*UnitPrice)>100000 order by SalesOrderID;

--28

select ProductID, Name from Production.Product  where name like 'Lock Washer%' order by ProductID;
--29

select ProductID, Name , Color from Production.Product  order by ProductID ;

--30

select BusinessEntityID, JobTitle,HireDate from HumanResources.Employee order by  year (HireDate);

--31

select lastname, firstname from person.person where LastName like 'R%' order by FirstName asc, LastName desc;

--32

select businessentityid, salariedflag from HumanResources.Employee 
order by case when  salariedflag='true' then businessentityid 
				end	asc,
		case when salariedflag='false' then businessentityid 
				end  ;

SELECT BusinessEntityID, SalariedFlag  
FROM HumanResources.Employee  
ORDER BY 2 asc,CASE WHEN SalariedFlag ='false' THEN BusinessEntityID END  
        ,CASE WHEN SalariedFlag ='true' THEN BusinessEntityID END desc;

--33

select  businessentityid,lastname,territoryname,countryregionname from Sales.vSalesPerson
 where territoryname is not null
order by case when countryregionname='United States' then territoryname
			 else countryregionname  
			 end;

--34

select
firstname,
LastName,
ROW_NUMBER() over (order by pa.postalcode) as rownumber,
rank () over (order by pa.postalcode ) as rank,
dense_rank () over (order by pa.postalcode ) as dense_rank,
NTILE(4) OVER(ORDER BY pa.postalcode ) AS Quartile , 
sp.salesytd,
postalcode
from Sales.SalesPerson sp inner join Person.Person pp
on sp.BusinessEntityID=pp.BusinessEntityID
inner join Person.Address pa 
on pa.AddressID=pp.BusinessEntityID
where sp.TerritoryID is not null and sp.salesytd !=0 

--35

select
departmentid,
NAME,
GroupName
 from HumanResources.Department 
 order by DepartmentID OFFSET 10 ROWS
 

 --36

 Select
 departmentid,
 NAME,
 GroupName
 from HumanResources.Department
 order by DepartmentID offset 5 rows fetch next 5 rows only;

 --37

 select 
	name,color,ListPrice
	from Production.Product where color in ('blue','red') order by ListPrice, color;

--38

select
name,SalesOrderID
from Sales.SalesOrderDetail s full join Production.Product p 
on s.ProductID=p.ProductID order by name, SalesOrderID desc

--39

select
name,SalesOrderID
from Sales.SalesOrderDetail s right join Production.Product p 
on s.ProductID=p.ProductID order by name

--40

select
name,SalesOrderID
from Sales.SalesOrderDetail s inner join Production.Product p 
on s.ProductID=p.ProductID order by name

--41

select 
*
from Sales.SalesTerritory;
select 
*
from Sales.SalesPerson;

select 
st.Name,
sp.BusinessEntityID
from Sales.SalesTerritory st right join Sales.SalesPerson sp
on st.TerritoryID=sp.TerritoryID;

--42

select 
concat(FirstName,' ',
LastName),
City,
pp.BusinessEntityID
from Person.Person pp inner join Person.BusinessEntityAddress  pb
on pp.BusinessEntityID=pb.BusinessEntityID
inner join Person.Address  pa
on pb.AddressID=pa.AddressID

select 
e.BusinessEntityID,
p.City
from HumanResources.Employee  e inner join (select 
concat(FirstName,' ',LastName),
City,
pp.BusinessEntityID
from Person.Person pp inner join Person.BusinessEntityAddress  pb
on pp.BusinessEntityID=pb.BusinessEntityID
inner join Person.Address  pa
on pb.AddressID=pa.AddressID) as p  on p.BusinessEntityID=e.BusinessEntityID;

select 
concat (pp.FirstName,' ',pp.LastName) ,
p.City
from Person.Person pp inner join  HumanResources.Employee  e 
on pp.BusinessEntityID=e.BusinessEntityID
inner join (select 
					City,
					pb.BusinessEntityID
					from Person.BusinessEntityAddress  pb
					inner join Person.Address  pa
					on pb.AddressID=pa.AddressID) as p  
on p.BusinessEntityID=e.BusinessEntityID
order by pp.lastname, pp.firstname;

--43

select
BusinessEntityID,
FirstName,
LastName
from Person.Person where PersonType='IN' and LastName='Adams' order by FirstName asc;

select
p.BusinessEntityID,
p.FirstName,
p.LastName
from (select
		*
		from Person.Person 
		where  PersonType='IN' and LastName='Adams') as p 
order by FirstName asc;

--44

select
BusinessEntityID,
LastName,
FirstName
from Person.Person 
where BusinessEntityID<1500 and LastName like 'Al%' and FirstName like 'M%';

--45

select 
ProductID,
Name,
Color
from  Production.Product where Name in('Blade','Crown Race' , 'AWC Logo Cap' );

--46

select distinct
salespersonid,
count(SalesOrderID) over ( partition by salespersonid,year(orderdate)),
YEAR(orderdate) as years
from  Sales.SalesOrderHeader
where SalesPersonID is not null
order by salespersonid,year(orderdate) asc;

select 
SalesPersonID,
count(SalesOrderID),
YEAR(OrderDate) as years
from  Sales.SalesOrderHeader
where SalesPersonID is not null
group by year(OrderDate),SalesPersonID
order by SalesPersonID, years;

--47

with a  as (
select 
count(Salesorderid) as cnt
from Sales.SalesOrderHeader
where SalesPersonID is not null
group by SalesPersonID)

select avg(cast(cnt as float)) from a

--48

select
ProductPhotoID
from 
Production.ProductPhoto where LargePhotoFileName like '%green/_%' escape '/'

--49

select
Addressline1, Addressline2, city, postalcode, countryregioncode
from Person.Address pa inner join Person.StateProvince pt
on pa.StateProvinceID=pt.StateProvinceID
where countryregioncode!='US' and City like 'Pa%'

--50

select 
JobTitle,
HireDate
from HumanResources.Employee
order by hiredate desc offset 0 rows fetch next 20 rows only;

--51

select
*
from Sales.SalesOrderDetail sd inner join Sales.SalesOrderHeader sh 
on sh.SalesOrderID=sd.SalesOrderID
where (OrderQty>5 or UnitPriceDiscount<1000) and TotalDue>100

--52

select
name,
color
from Production.Product where lower(name) like '%red%';

--53

select
name,
ListPrice
from Production.Product where ListPrice=80.99 and name like '%Mountain Pedal%';

--54

select
name,
Color
from Production.Product where name like'%Road%' or name like '%Mountain%' ;

--55

select
name,
Color
from Production.Product where name like'%Black%' and name like '%Mountain%' ;


--56

select
trim(name) name,
Color
from Production.Product where left(name,len('chain') + 1) = 'Chain '
order by 2;

--57

select
trim(name) name,
Color
from Production.Product 
where left(name,len('chain') + 1) = 'Chain ' or name like 'Full%'
order by 2 ;

--58

select
CONCAT(FirstName,' ', lastname, ' ', EmailAddress)
from Person.Person pp inner join person.EmailAddress pa
on pp.BusinessEntityID=pa.BusinessEntityID
where pp.BusinessEntityID=1
order by pp.BusinessEntityID;

--59

select
name,
CHARINDEX('Yellow',Name) as indexs
from Production.Product
where name like '%Yellow%'
order by indexs;

--60

select
concat(name,' ', 'Color: ',color,' ','ProductNumber: ', ProductNumber),
Color
from Production.Product

--61

SELECT CONCAT_WS( ',', name, productnumber, color,char(10)) AS DatabaseInfo
FROM production.product;

--62

SELECT LEFT(Name, 5)   
FROM Production.Product  
ORDER BY ProductID;

--63

SELECT LEN(FirstName) AS Length, FirstName, LastName   
FROM Sales.vIndividualCustomer  
WHERE CountryRegionName = 'Australia';

--64

SELECT LEN(FirstName) AS Lengths, FirstName, LastName   
FROM Sales.vstorewithcontacts  c inner join   Sales.vstorewithaddresses a
on c.BusinessEntityID=a.BusinessEntityID
WHERE CountryRegionName = 'Australia'
order by Lengths, FirstName;

--65

select
lower(name),
upper(name)
from Production.Product
where StandardCost between 1000.00 and 1200.00
order by 1;

--66

select trim('   five space then the text') ;

--67

select 
ProductNumber,
substring(ProductNumber,3,5)
from Production.Product
where ProductNumber like 'HN%'

--68

select 
name,
CONCAT(REPLICATE('0',4),ProductLine)
from Production.Product
where productline in('T')

--69

select 
FirstName,
REVERSE(firstname)
from Person.Person
where BusinessEntityID<6;

--70

select 
name,
ProductNumber,
right(name,8)
from Production.Product;

--71

select replace ('text then five spaces     after space','  ','');

--72

select 
Name,
ProductNumber
from Production.Product
where right(name,2) in(' R',' S',' M');

--73

SELECT STRING_AGG(coalesce(cast(firstname as nvarchar(MAX)), ' N/A'),', ') AS test 
FROM Person.Person;

select * from Person.Person;

--74

SELECT STRING_AGG(cast(CONCAT(firstname,' ','(',ModifiedDate,')') as nvarchar(MAX))  , ', ') AS test 
FROM Person.Person;


--75

select top (10)
city,
STRING_AGG( cast(EmailAddress as nvarchar(MAX)),', ')
from Person.BusinessEntityAddress as pb
inner join Person.EmailAddress pe
on pb.BusinessEntityID=pe.BusinessEntityID
inner join  Person.Address pa
on pa.AddressID=pb.AddressID
group by city;

--76

select 
jobtitle,REPLACE(JobTitle,'Production Supervisor','Production Assistant')
 from  HumanResources.Employee where JobTitle like 'Production Supervisor%';

 --77

 select 
 firstname, middlename, lastname ,jobtitle 
 from Person.person pp inner join HumanResources.Employee e
 on  pp.BusinessEntityID=e.BusinessEntityID
 where jobtitle like 'Sales%';

 --78

 select 
 CONCAT( UPPER(LastName),' ', FirstName)
 from Person.Person;

 --79

 select 
 FirstName, LastName, Title, left(cast(SickLeaveHours as varchar),1)
 from HumanResources.Employee e inner join Person.Person pp
  on  pp.BusinessEntityID=e.BusinessEntityID;

 --80

 select 
 Name,
 ListPrice
 from Production.Product
 where cast(ListPrice as varchar(10)) like '33%';

 --81

 select 
 SalesYTD,CommissionPct, round(SalesYTD/CommissionPct,0)
 from Sales.SalesPerson
 where CommissionPct!=0

 --82

 select 
 FirstName,
 LastName,
 SalesYTD,
 pp.BusinessEntityID
  from Person.Person pp inner join Sales.SalesPerson sp 
  on pp.BusinessEntityID=sp.BusinessEntityID
  where left(SalesYTD,1)=2;

--83

select 
  cast(name as varchar(16)),ListPrice 
  from Production.Product
  where left(name,16) like 'Long-Sleeve Logo%';

--84

select 
  productid, UnitPrice, UnitPriceDiscount ,(UnitPrice*UnitPriceDiscount ) as DiscountPrice 
  from Sales.SalesOrderDetail
  where SalesOrderID=46672 and UnitPriceDiscount>0.02

--85

select 
AVG(cast(VacationHours as float)),
sum(SickLeaveHours)
from HumanResources.Employee
where JobTitle like 'Vice President%'

--86

select 
TerritoryID,
avg(Bonus) as  average_bonus,
SUM(SalesYTD) as sum_of_salesytd
from Sales.SalesPerson
group by TerritoryID 

--87

select 
avg(distinct cast(ListPrice as float))
from Production.Product

--88
select 
BusinessEntityID, TerritoryID, year(ModifiedDate),salesytd,
avg(SalesYTD )  over (partition by TerritoryID order by year(ModifiedDate)  ),
sum(SalesYTD )  over (partition by TerritoryID order by year(ModifiedDate)  )
 from sales.SalesPerson
 where TerritoryID is not null;

 --89

 select 
BusinessEntityID, TerritoryID, year(ModifiedDate) as year,salesytd,
avg(SalesYTD )  over (order by year(ModifiedDate)  ),
sum(SalesYTD )  over (order by year(ModifiedDate)  )
 from sales.SalesPerson
 where TerritoryID is not null
 order by year

 --90

 select COUNT (distinct JobTitle) from HumanResources.Employee;

 --91

 select count(distinct BusinessEntityID) from HumanResources.Employee

 --92

 select 
 count(businessentityid),
 avg(Bonus)
 from Sales.SalesPerson
 where  SalesQuota>2500;

 --93

 select 
 distinct d.name,
 avg(Rate) over (partition by d.DepartmentID ),
  MAX(Rate) over (partition by d.DepartmentID), 
  MIN(Rate) over (partition by d.DepartmentID),
  count(eh.BusinessEntityID) over (partition by d.DepartmentID)
 from HumanResources.employeepayhistory eh inner join HumanResources.employeedepartmenthistory ed
 on eh.BusinessEntityID=ed.BusinessEntityID 
 inner join HumanResources.Department d 
 on ed.DepartmentID=d.DepartmentID;

 --94
 
 select 
 jobtitle,
 count (*)
 from HumanResources.Employee
 group by JobTitle
 having COUNT(*)>15;

 --95

 select 
 salesorderid,
 count(SalesOrderID)
 from Sales.SalesOrderDetail
 group by SalesOrderID
 having SalesOrderID in (43855,43661);

 --96

 SELECT quotadate AS Year, datepart(quarter,quotadate) AS Quarter, SalesQuota AS SalesQuota,  
       var(SalesQuota) OVER (ORDER BY datepart(year,quotadate), datepart(quarter,quotadate)) AS Variance  
FROM sales.salespersonquotahistory  
WHERE businessentityid = 277 AND datepart(year,quotadate) = 2012  
ORDER BY datepart(quarter,quotadate);

--97

select 
varp(SalesQuota),
varp(distinct SalesQuota)
from Sales.SalesPersonQuotaHistory;

--98

select 
color,
sum(ListPrice),
sum(StandardCost)
from Production.Product
where Name like 'Mountain%' and ListPrice>0 and color is not null
group by Color;

--99

select 
SalesQuota,
sum(SalesYTD)
from Sales.SalesPerson
group by cube(SalesQuota );

--100

select 
color,
sum(ListPrice),
sum(StandardCost)
from Production.Product
group by color;