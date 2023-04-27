--101

select 
Department,
LastName,
Rate,
CUME_DIST() over (partition by department order by rate  ),
PERCENT_RANK () over (partition by department order by rate)
from HumanResources.EmployeePayHistory ep inner join  HumanResources.vEmployeeDepartmentHistory ed
on ed.BusinessEntityID=ep.BusinessEntityID
order by 1,3 desc;

--102

select distinct
name,
listprice,
first_value(name ) over (order by listprice ) as 'Leastexpensive'
from  Production.Product
where ProductSubcategoryID=37;

--103

select 
JobTitle,
pp.lastname,
vacationhours,
FIRST_VALUE(pp.LastName) over (partition by jobtitle order by vacationhours ) 
 from HumanResources.Employee e inner join Person.Person pp
 on pp.BusinessEntityID=e.BusinessEntityID;

--104

 select 
 BusinessEntityID ,
 year(modifieddate),
 SalesQuota,
 lag(SalesQuota) over (partition by BusinessEntityID order by year(modifieddate))
 from  sales.SalesPersonQuotaHistory
 WHERE BusinessEntityID = 275 AND year(ModifiedDate) in (2012,2013);

 --105

 select 
 TerritoryName,
 BusinessEntityID,
 SalesYTD,
 lag(SalesYTD) OVER ( partition by TerritoryName order by salesYTD )
 from sales.vSalesPerson
 WHERE TerritoryName IN ('Northwest', 'Canada')   
ORDER BY TerritoryName;

--106

select 
Department,
LastName,
rate,
HireDate,
last_value(hiredate) over (partition by department order by rate)
from  HumanResources.vEmployeeDepartmentHistory v inner join HumanResources.Employee e
on v.BusinessEntityID=e.BusinessEntityID 
inner join HumanResources.EmployeePayHistory eh 
on e.BusinessEntityID=eh.BusinessEntityID
WHERE Department IN ('Information Services', 'Document Control');

--107

select 
BusinessEntityID,
DATEPART(QUARTER,QuotaDate),
DATEPART(YEAR,QuotaDate),
SalesQuota,
FIRST_VALUE(SalesQuota) 
over 
(partition by BusinessEntityID, DATEPART(YEAR,QuotaDate) 
order by DATEPART(quarter, QuotaDate) 
range between unbounded preceding and current row),
LAST_VALUE(SalesQuota) 
over 
(partition by BusinessEntityID, DATEPART(YEAR,QuotaDate)  
order by DATEPART(quarter, QuotaDate) 
rows between unbounded preceding and unbounded following)
 from Sales.SalesPersonQuotaHistory;

 select 
BusinessEntityID,
DATEPART(QUARTER,QuotaDate),
DATEPART(YEAR,QuotaDate),
SalesQuota,
SalesQuota-FIRST_VALUE(SalesQuota) 
over (partition by BusinessEntityID, DATEPART(YEAR,QuotaDate) order by DATEPART(quarter, QuotaDate)),
FIRST_VALUE(SalesQuota) 
over (partition by BusinessEntityID, DATEPART(YEAR,QuotaDate) order by DATEPART(year, QuotaDate)),
LAST_VALUE(SalesQuota) 
over (partition by BusinessEntityID, DATEPART(YEAR,QuotaDate) order by DATEPART(year, QuotaDate))
 from Sales.SalesPersonQuotaHistory
 where  BusinessEntityID=274 or BusinessEntityID=275;

 --Answer 
  select 
BusinessEntityID,
DATEPART(YEAR,QuotaDate) as years,
DATEPART(QUARTER,QuotaDate) as quarters,
SalesQuota,
SalesQuota-FIRST_VALUE(SalesQuota) 
over (partition by BusinessEntityID, DATEPART(YEAR,QuotaDate) order by DATEPART(year, QuotaDate)) as DIF_first,
SalesQuota-LAST_VALUE(SalesQuota) 
over (partition by BusinessEntityID, DATEPART(YEAR,QuotaDate) order by DATEPART(year, QuotaDate)) as DIF_last
 from Sales.SalesPersonQuotaHistory
 where  BusinessEntityID=274 or BusinessEntityID=275;

--108

 select 
QuotaDate as years,
DATEPART(QUARTER,QuotaDate) as quarters,
SalesQuota,
varp(SalesQuota) over (order by QuotaDate )
 from Sales.SalesPersonQuotaHistory
 where year(QuotaDate)=2012 and BusinessEntityID=277;

 
 --109

 select 
 BusinessEntityID,
 YEAR(QuotaDate),
 SalesQuota,
 LEAD(SalesQuota) over (partition by BusinessEntityID order by  YEAR(QuotaDate))
from Sales.SalesPersonQuotaHistory
where BusinessEntityID=277;

--110

 select 
 TerritoryName,
 BusinessEntityID,
 SalesYTD,
 lead(SalesYTD) OVER ( partition by TerritoryName order by salesYTD )
 from sales.vSalesPerson
 WHERE TerritoryName IN ('Northwest', 'Canada')   
ORDER BY TerritoryName;

--111

select 
year(QuotaDate),
DATEPART(QUARTER, QuotaDate),
SalesQuota,
LEAD(SalesQuota) over (order by DATEPART(year, QuotaDate)),
SalesQuota-LEAD(SalesQuota) over (order by DATEPART(year, QuotaDate))
from sales.SalesPersonQuotaHistory
WHERE businessentityid = 277 AND year(QuotaDate) IN (2012,2013)  

--112

select 
Department,
LastName,
Rate,
CUME_DIST() over (partition by department order by rate  ),
PERCENT_RANK () over (partition by department order by rate)
from HumanResources.EmployeePayHistory ep inner join  HumanResources.vEmployeeDepartmentHistory ed
on ed.BusinessEntityID=ep.BusinessEntityID
order by 1,3 desc;

--113

select 
SalesOrderID,
OrderDate,
DATEADD(day,2,OrderDate)
from Sales.SalesOrderHeader

--114

select 
FirstName,
LastName,
DATEADD(day,2,GETDATE() )
from Sales.SalesPerson sp inner join Person.Person p
on sp.BusinessEntityID=p.BusinessEntityID
inner join Person.Address a
on a.AddressID=sp.BusinessEntityID
where SalesYTD!=0 and TerritoryID is not null;

--115

select 
datediff(day,max(OrderDate),MIN(OrderDate))
from Sales.SalesOrderHeader;

--116

select
distinct
pi.ProductID,
Name,
LocationID,
Quantity,
dense_rank() over (partition by LocationID order by Quantity desc)
from Production.ProductInventory pi inner join Production.Product p
on pi.ProductID=p.ProductID
where LocationID in (3,4);

--117

select top(10)
BusinessEntityID,
Rate,
dense_rank() over (order by rate desc)
from HumanResources.EmployeePayHistory

--118

select 
FirstName,
LastName,
NTILE(4) over (order by salesytd desc),
SalesYTD,
PostalCode
from Sales.SalesPerson  sp inner join Person.Person p
on sp.BusinessEntityID=p.BusinessEntityID
inner join Person.Address a
on a.AddressID=sp.BusinessEntityID
WHERE TerritoryID IS NOT NULL   
    AND SalesYTD <> 0; 


--119

select
distinct
pi.ProductID,
Name,
LocationID,
Quantity,
rank() over (partition by LocationID order by Quantity desc)
from Production.ProductInventory pi inner join Production.Product p
on pi.ProductID=p.ProductID
where LocationID in (3,4);

--120

with x as (select distinct
BusinessEntityID,
first_value(rate) over (partition by BusinessEntityID order by rate desc) as rate
from HumanResources.EmployeePayHistory)

select top(10)
BusinessEntityID,
Rate,
rank() over (order by rate desc)
from x
order by BusinessEntityID asc;


select top(10)
BusinessEntityID,
Rate,
rank() over (order by rate desc)
from HumanResources.EmployeePayHistory eh
where RateChangeDate= (select max(RateChangeDate) from HumanResources.EmployeePayHistory e 
							where eh.BusinessEntityID=e.BusinessEntityID)
order by eh.BusinessEntityID ;

--121

select 
ROW_NUMBER() over (order by SalesYTD desc),
FirstName,
LastName,
SalesYTD
from Sales.vSalesPerson

--122

with rown as (select 
SalesOrderID,
OrderDate,
ROW_NUMBER() over (order by orderdate ) as rownumber
from Sales.SalesOrderHeader)
select * from rown  where rown.rownumber between 50 and 60

--123

select 
FirstName,
LastName,
TerritoryName,
SalesYTD,
ROW_NUMBER ()  over (partition by TerritoryName order by salesytd)
 from Sales.vSalesPerson
 where TerritoryName is not null;

 --124

 select 
 BusinessEntityID,
 LastName,
 TerritoryName,
 CountryRegionName
 from sales.vSalesPerson
 WHERE TerritoryName IS NOT NULL  
 ORDER BY CASE CountryRegionName WHEN 'United States' THEN TerritoryName  
         ELSE CountryRegionName END;

--125

select distinct
jobtitle,
max(rate) over (partition by jobtitle order by rate desc) as maxs
from HumanResources.Employee e inner join HumanResources.EmployeePayHistory ep
on  e.BusinessEntityID=ep.BusinessEntityID
where (gender='M' and Rate>40 ) or (gender='F' and Rate>42)
order by maxs desc;

--126

SELECT BusinessEntityID, SalariedFlag  
FROM HumanResources.Employee  
ORDER BY 
         CASE when SalariedFlag  = 'true' 
           THEN BusinessEntityID END 
 DESC  
        ,CASE WHEN SalariedFlag = 'false'
           THEN BusinessEntityID END;

--127

select 
ProductNumber, 
Name, 
listprice,
CASE 
         WHEN ListPrice =  0 THEN 'Mfg item - not for resale'  
         WHEN ListPrice < 50 THEN 'Under $50'  
         WHEN ListPrice >= 50 and ListPrice < 250 THEN 'Under $250'  
         WHEN ListPrice >= 250 and ListPrice < 1000 THEN 'Under $1000'  
         ELSE 'Over $1000'  
      END "Price Range" 
FROM Production.Product  
ORDER BY ProductNumber ;


--128

select 
ProductNumber,
Name,
case productline
		WHEN 'R' THEN 'Road'  
         WHEN 'M' THEN 'Mountain'  
         WHEN 'T' THEN 'Touring'  
         WHEN 'S' THEN 'Other sale items'  
         ELSE 'Not for sale' 
	end category
from Production.Product
order by ProductNumber;

--129

select 
ProductID,
MakeFlag,
FinishedGoodsFlag,
case 
	when MakeFlag!=FinishedGoodsFlag then 'true'
	else ' '
	end boolean
from Production.Product

--130

select 
name,
Class,
Color,
ProductNumber,
case 
	when  class is not null then class
	when  class is null and color is not null then color
	else ProductNumber
	end boolean
from Production.Product

SELECT Name, Class, Color, ProductNumber,  
COALESCE(Class, Color, ProductNumber) AS FirstNotNull  
FROM Production.Product;

--131

select 
ProductID,
MakeFlag,
FinishedGoodsFlag,
case 
	when MakeFlag=FinishedGoodsFlag then 'true'
	else ' '
	end boolean
from Production.Product

--132

select 
ProductID
from Production.Product 
intersect 
select 
ProductID
from Production.WorkOrder

--133

select 
ProductID
from Production.Product
except
select 
ProductID
from Production.WorkOrder

--134

select 
ProductID
from Production.WorkOrder
except

select 
ProductID
from Production.Product

--135

SELECT businessentityid   
FROM person.businessentity    
INTERSECT   
SELECT businessentityid   
FROM person.person
WHERE person.persontype = 'IN'  
ORDER BY businessentityid;

--136

SELECT businessentityid   
FROM person.businessentity    
except  
SELECT businessentityid   
FROM person.person
WHERE person.persontype = 'IN'  
ORDER BY businessentityid;

--137

SELECT ProductID, Name  
FROM Production.Product  
WHERE ProductID NOT IN (3, 4)  
UNION  
SELECT ProductModelID, Name  
FROM Production.ProductModel   
ORDER BY Name;

--138

select 
FirstName,
LastName,
VacationHours,
SickLeaveHours,
VacationHours+SickLeaveHours
from person.Person pp inner join HumanResources.Employee e 
on pp.BusinessEntityID=e.BusinessEntityID
order by VacationHours , SickLeaveHours;

--139

select 
cast(max(TaxRate)-min(TaxRate) as float)
from sales.SalesTaxRate;

--140

select 
sp.BusinessEntityID, FirstName,LastName, SalesQuota, SalesQuota/12 as per_sales
from Person.Person pp inner join HumanResources.Employee e
on  pp.BusinessEntityID=e.BusinessEntityID
inner join Sales.SalesPerson sp
on  sp.BusinessEntityID=e.BusinessEntityID;

--141

select 
ProductID,
UnitPrice,
OrderQty,
cast(UnitPrice as int)% OrderQty as modula
from Sales.SalesOrderDetail;

--142

select 
BusinessEntityID,
LoginID,
JobTitle,
VacationHours
from HumanResources.Employee
where VacationHours>=42 and JobTitle = 'Marketing Assistant'

--143

select 
FirstName,
LastName,
rate
from HumanResources.vEmployee ve inner join HumanResources.EmployeePayHistory ph
on ve.BusinessEntityID=ph.BusinessEntityID 
where rate not between 27 and 30
order by rate;

--144

select 
* 
from HumanResources.EmployeePayHistory
where RateChangeDate between '2011-12-15' and '2012-01-01';

--145

select 
* 
from HumanResources.Department
order by name ;

--146

select 
FirstName,
LastName
from Person.Person p inner join HumanResources.Employee e
on p.BusinessEntityID=e.BusinessEntityID
where LastName='Johnson';

--147

SELECT DISTINCT s.Name  
FROM Sales.Store AS s   
WHERE s.Name = ANY  
(SELECT v.Name  
    FROM Purchasing.Vendor AS v ) ;

	SELECT DISTINCT s.Name  
FROM Sales.Store AS s   
WHERE EXISTS  
(SELECT *  
    FROM Purchasing.Vendor AS v  
    WHERE s.Name = v.Name) ;

--148

select 
FirstName,
LastName,
JobTitle
from Person.Person p inner join HumanResources.Employee e
on p.BusinessEntityID=e.BusinessEntityID
where  exists( 
select 
edh.BusinessEntityID,
Name
from  HumanResources.Department d 
inner join HumanResources.EmployeeDepartmentHistory edh
on d.DepartmentID=edh.DepartmentID 
where edh.BusinessEntityID=e.BusinessEntityID and d.Name like 'P%')

select 
FirstName,
LastName,
JobTitle
from Person.Person p inner join HumanResources.Employee e
on p.BusinessEntityID=e.BusinessEntityID
where  e.BusinessEntityID in ( 
select 
edh.BusinessEntityID
from  HumanResources.Department d 
inner join HumanResources.EmployeeDepartmentHistory edh
on d.DepartmentID=edh.DepartmentID 
where d.Name like 'P%')

--149

select 
FirstName,
LastName,
JobTitle
from Person.Person p inner join HumanResources.Employee e
on p.BusinessEntityID=e.BusinessEntityID
where  e.BusinessEntityID in ( 
select 
edh.BusinessEntityID
from  HumanResources.Department d 
inner join HumanResources.EmployeeDepartmentHistory edh
on d.DepartmentID=edh.DepartmentID 
where d.Name  not like 'P%')
order by LastName;

--150

select 
FirstName,
LastName,
JobTitle
from Person.Person p inner join HumanResources.Employee e
on p.BusinessEntityID=e.BusinessEntityID
where  JobTitle in('Marketing Assistant','Tool Designer','Design Engineer')


--151

select 
FirstName,LastName
from Sales.SalesPerson sp inner join Person.Person pp
on sp.BusinessEntityID=pp.BusinessEntityID
where SalesQuota>250000

--152

select 
FirstName,LastName
from Sales.SalesPerson sp inner join Person.Person pp
on sp.BusinessEntityID=pp.BusinessEntityID
where pp.BusinessEntityID not in (select BusinessEntityID
									from sales.SalesPerson 
									where SalesQuota>250000)


--153

select 
SalesOrderID,
s.SalesReasonID,
s.ModifiedDate
from Sales.SalesOrderHeaderSalesReason sr inner join Sales.SalesReason s 
on sr.SalesReasonID= s.SalesReasonID;

--154

select 
FirstName,
LastName,
PhoneNumber
from Person.PersonPhone pp inner join Person.Person p 
on pp.BusinessEntityID=p.BusinessEntityID
where PhoneNumber like '415%';

--155

select 
FirstName,
LastName,
PhoneNumber
from Person.PersonPhone pp inner join Person.Person p 
on pp.BusinessEntityID=p.BusinessEntityID
where FirstName='Gail' and PhoneNumber not like '415%';

--156

select 
ProductID,
name,
color,
ListPrice
from Production.Product
where Color='silver' and StandardCost<400 and ProductNumber like 'BK-%';

--157

select 
FirstName,
LastName,
Shift
from HumanResources.vEmployeeDepartmentHistory
where Department='Quality Assurance' and Shift in ('Night','Evening');

--158

select 
FirstName,LastName
from Person.Person
where len(FirstName)=3 and FirstName like '%an'
order by 1;

select 
FirstName,LastName
from Person.Person
where len(FirstName)=3 and FirstName like '_an'
order by 1;


--159

select
orderdate,
orderdate  at time zone  'India Standard Time' 
from Sales.SalesOrderHeader;


--160

SELECT SalesOrderID, 
orderdate,
cast (OrderDate as datetimeoffset) at time zone 'Pacific Standard Time' AS OrderDate_TimeZonePST0,
cast (OrderDate as datetimeoffset) AT TIME ZONE 'Pacific Standard Time' 
AT TIME ZONE 'Central Standard Time' AS OrderDate_TimeZoneCET0
FROM Sales.SalesOrderHeader;

--161

select 
ProductPhotoID,
ThumbNailPhoto
from Production.ProductPhoto
where LargePhotoFileName  like '%green/_%' escape '/';

--162

select 
AddressLine1,
AddressLine2,
City,
PostalCode,
CountryRegionCode
from Person.Address a inner join Person.StateProvince s
on s.StateProvinceID=a.StateProvinceID
where City like 'Pa%' and CountryRegionCode != 'USA';

--163

SELECT ProductID, a.Name, Color  
FROM Production.Product AS a  
INNER JOIN (VALUES ('Blade'), ('Crown Race'), ('AWC Logo Cap')) AS b(Name)   
ON a.Name = b.Name;

--164

with salesorder as(
    SELECT 
	distinct SalesPersonID, 
	SUM(TotalDue) over (partition by SalesPersonID, DATEPART(year,OrderDate))AS TotalSales,
	DATEPART(year,OrderDate) AS SalesYear
    FROM Sales.SalesOrderHeader
    WHERE SalesPersonID IS NOT NULL ),

	salesperson as (
	select distinct
	BusinessEntityID,
	SUM(SalesQuota) over (partition by BusinessEntityID , DATEPART(year,QuotaDate))AS TotalSales,
	DATEPART(year,QuotaDate) AS SalesYear
	from sales.SalesPersonQuotaHistory )

	select 
	salespersonid,
	o.TotalSales,
	o.SalesYear,
	p.TotalSales,
	p.SalesYear,
	o.TotalSales-p.TotalSales
	from salesorder o inner join salesperson  p
	on o.SalesPersonID=p.BusinessEntityID;

--165

select
BusinessEntityID,
name
from HumanResources.Employee e cross join HumanResources.Department d
order by 1,2

--166

select 
SalesOrderID,
p.ProductID,
Name
from Sales.SalesOrderDetail s inner join Production.Product p
on s.ProductID=p.ProductID
order by 1,2

--167

select 
s.SalesOrderID,
p.ProductID,
Name
from Sales.SalesOrderDetail s  join Production.Product p
on s.ProductID=p.ProductID
where s.SalesOrderID > 60000
order by 1


--168

select 
t.TerritoryID,
CountryRegionCode,
h.SalesOrderID
from sales.SalesTerritory t left join Sales.SalesOrderHeader h
on t.TerritoryID=h.TerritoryID


--169

select 
t.TerritoryID,
CountryRegionCode,
h.SalesOrderID
from sales.SalesTerritory t full join Sales.SalesOrderHeader h
on t.TerritoryID=h.TerritoryID;


--170

select 
t.TerritoryID,
h.SalesOrderID
from sales.SalesTerritory t cross join Sales.SalesOrderHeader h
order by SalesOrderID


--171

SELECT businessentityid, jobtitle, birthdate 
FROM  
   (SELECT * FROM humanresources.employee  
    WHERE BirthDate > '1988-09-01') AS EmployeeDerivedTable  
WHERE jobtitle = 'Production Technician - WC40'  
ORDER BY birthdate;

--172

select 
businessentityid, persontype, firstname, middlename,lastname
from Person.Person
where not FirstName='Adam'
order by firstname,2;


--173

select 
businessentityid, persontype, firstname, middlename,lastname
from Person.Person
where  FirstName='Adam'
order by 1;

--174

select 
businessentityid, persontype, firstname, middlename, lastname
from Person.Person
where MiddleName is not null 
order by firstname;


--175

select 
businessentityid, persontype, firstname, coalesce( middlename, ''), lastname
from Person.Person
where MiddleName is  null 
order by firstname;


--176

select 
name,
coalesce(cast(weight as int ),' ')as Weight,
coalesce( Color, '') as Color
from Production.Product
where color is null or Weight<10;

--177

select 
businessentityid,
salesytd, 
cast( SalesYTD as varchar(15)) moneydisplaystyle1,
getdate()  ,
cast (getdate()  as varchar (20))
from Sales.SalesPerson
where cast( SalesYTD as varchar(15)) like '1%';


--178

select 
name,
count(e.BusinessEntityID),
CASE   
    WHEN name='Document Control' and jobtitle is null THEN 'Total :Document Control '  
	WHEN name='Facilities and Maintenance' and jobtitle is null THEN 'Total :Facilities and Maintenance '
	WHen JobTitle is not null then jobtitle
        ELSE 'Total Company'  
    END AS "Job Title"  
from HumanResources.Employee e inner join HumanResources.EmployeeDepartmentHistory ed
on e.BusinessEntityID=ed.BusinessEntityID 
inner join HumanResources.Department d 
on d.DepartmentID=ed.DepartmentID
where d.DepartmentID in (12,14)
group by rollup (name, JobTitle);

--179

select 
name,
'' as  jobtitle,
count(e.BusinessEntityID),
replace(grouping(name),0,1)
from HumanResources.Employee e inner join HumanResources.EmployeeDepartmentHistory ed
on e.BusinessEntityID=ed.BusinessEntityID 
inner join HumanResources.Department d 
on d.DepartmentID=ed.DepartmentID
where d.DepartmentID in (12,14)
group by name;


--180

select 
name,
count(e.BusinessEntityID) as cnt ,
JobTitle
from HumanResources.Employee e inner join HumanResources.EmployeeDepartmentHistory ed
on e.BusinessEntityID=ed.BusinessEntityID 
inner join HumanResources.Department d 
on d.DepartmentID=ed.DepartmentID
where d.DepartmentID in (12,14)
group by name, JobTitle;

--181

select 
distinct
QuotaDate,
DATEPART(QUARTER,QuotaDate),
SalesQuota,
lag(SalesQuota) over (partition by year(QuotaDate) order by year(QuotaDate)),
SalesQuota-lag(SalesQuota) over (partition by year(QuotaDate) order by year(QuotaDate))
from sales.SalesPersonQuotaHistory
where year(QuotaDate) in (2012,2013) and BusinessEntityID=277
order by 1;

--182

select
orderdate,
DATEADD(month,4,orderdate)
from sales.SalesOrderHeader

--183

select 
salesorderid, 
FORMAT(orderdate, 'yyyy-MM-01 00:00:00.000') as MonthOrderOccurred, 
salespersonid, 
customerid, 
subtotal, 
SUM(subtotal) OVER (
        PARTITION BY customerid ORDER BY orderdate,
            salesorderid ROWS UNBOUNDED PRECEDING
        ), 
orderdate as actualorderdate
from sales.SalesOrderHeader
where FORMAT(orderdate, 'yyyy-MM-01 00:00:00.000')>'2011-12-01' and salespersonid IS NOT NULL

--184

select 
name,
ProductNumber,
concat('0000',ProductNumber)
from Production.Product;

--185

select 
Description,
DiscountPct,
MinQty,
coalesce(MaxQty,0)
from sales.SpecialOffer;

--186

select 
name,
Weight
from Production.Product
where Weight is null;

--187

select 
Name,
color,
ProductNumber,
coalesce(color,productnumber)
from Production.Product;

--188

SELECT a.productid, a.startdate 
FROM production.workorder AS a  
WHERE EXISTS  
(SELECT *   
    FROM production.workorderrouting  AS b  
    WHERE (a.productid = b.productid and a.startdate=b.actualstartdate)) ;

--189

SELECT distinct a.productid, a.startdate 
FROM production.workorder AS a  
WHERE not EXISTS  
(SELECT *   
    FROM production.workorderrouting  AS b  
    WHERE (a.productid = b.productid and a.startdate=b.actualstartdate)) 
	order by 2;

--190

select 
salesorderid,
orderdate,
creditcardapprovalcode
from sales.SalesOrderHeader
where cast(creditcardapprovalcode as varchar(30)) like '1_6%';

--191

select 
concat('The order is due on ' , cast(DueDate as VARCHAR(12)))   
from  Sales.SalesOrderHeader
where SalesOrderID=50001;

select 
concat('The order is due on ' , format(DueDate,'yyyy-MM-dd'))   
from  Sales.SalesOrderHeader
where SalesOrderID=50001;

--192

SELECT concat(LastName ,',' ,' ' , SUBSTRING(FirstName, 1, 1), '.')  AS Name, e.JobTitle  
FROM Person.Person AS p  
    JOIN HumanResources.Employee AS e  
    ON p.BusinessEntityID = e.BusinessEntityID  
WHERE e.JobTitle LIKE 'Vice%'  
ORDER BY LastName ASC;

--193

select 
Name,
ProductNumber,
ListPrice
from Production.Product
where ProductLine='R' and DaysToManufacture<4
order by 1;

--194

select 
Name,
(OrderQty * UnitPrice) as NonDiscountSales,
((OrderQty * UnitPrice) * UnitPriceDiscount) as Discounts
from Production.Product p inner join sales.SalesOrderDetail s
on  p.ProductID=s.ProductID
order by 1 desc;

--195

select 
'Total income is',
((OrderQty * UnitPrice)),
'for',
Name
from Production.Product p inner join sales.SalesOrderDetail s
on  p.ProductID=s.ProductID
order by 4 asc;

--196

select 
p.Name 
from Production.Product p inner join Production.ProductModel pm
on p.ProductModelID=pm.ProductModelID
where p.Name like 'Long-Sleeve Logo Jersey%'

--197

SELECT DISTINCT p.LastName, p.FirstName 
FROM Person.Person AS p 
JOIN HumanResources.Employee AS e
    ON e.BusinessEntityID = p.BusinessEntityID WHERE 5000.00 IN
    (SELECT Bonus
     FROM Sales.SalesPerson AS sp
     WHERE e.BusinessEntityID = sp.BusinessEntityID);

--198

select 
productmodelid
from Production.Product pp 
group by pp.ProductModelID
having max(ListPrice)<=2* (select  AVG(ListPrice) 
							from Production.Product p
							where p.ProductModelID=pp.ProductModelID);

--199

SELECT DISTINCT pp.LastName, pp.FirstName 
FROM Person.Person pp JOIN HumanResources.Employee e
ON e.BusinessEntityID = pp.BusinessEntityID 
WHERE pp.BusinessEntityID IN 
(SELECT SalesPersonID 
FROM Sales.SalesOrderHeader
WHERE SalesOrderID IN 
(SELECT SalesOrderID 
FROM Sales.SalesOrderDetail
WHERE ProductID IN 
(SELECT ProductID 
FROM Production.Product p 
WHERE ProductNumber = 'BK-M68B-42')));

--200
