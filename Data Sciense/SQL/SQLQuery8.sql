SELECT TOP 10
	c.CustomerID,
	pp.FirstName + ' ' + pp.LastName AS FullName,
	SUM(LineTotal) AS TotalSpent

FROM Sales.SalesOrderHeader soh

JOIN Sales.SalesOrderDetail sod
	ON soh.SalesOrderID = sod.SalesOrderID

JOIN Sales.Customer c
	ON soh.CustomerID = c.CustomerID

JOIN Person.Person pp
	ON c.PersonID = pp.BusinessEntityID

GROUP BY c.CustomerID, pp.FirstName, pp.LastName

ORDER BY TotalSpent DESC;