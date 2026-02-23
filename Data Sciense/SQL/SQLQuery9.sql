SELECT TOP 10
	sp.BusinessEntityID AS SalesPersonID,
	pp.FirstName + ' ' + pp.LastName AS SalesPersonName,
	SUM(LineTotal) AS TotalSales

FROM Sales.SalesOrderHeader soh

JOIN Sales.SalesOrderDetail sod
	ON soh.SalesOrderID = sod.SalesOrderID

JOIN Sales.SalesPerson sp
	ON soh.SalesPersonID = sp.BusinessEntityID

JOIN Person.Person pp
	ON sp.BusinessEntityID = pp.BusinessEntityID

GROUP BY sp.BusinessEntityID, pp.FirstName, pp.LastName

ORDER BY TotalSales DESC; 