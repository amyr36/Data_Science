SELECT
	c.CustomerID,
	p.FirstName + ' ' + p.LastName AS CustomerName,
	SUM(soh.TotalDue) AS TotalSpent,
	MAX(soh.OrderDate) AS LastOrderDate

FROM Sales.Customer c

JOIN Sales.SalesOrderHeader soh
	ON c.CustomerID = soh.CustomerID
JOIN Person.Person p
	ON c.PersonID = p.BusinessEntityID

GROUP BY 
	c.CustomerID,
	p.FirstName,
	p.LastName

HAVING
	SUM(soh.TotalDue) > 5000
	AND MAX(soh.OrderDate) < DATEADD(month, -6, GETDATE());