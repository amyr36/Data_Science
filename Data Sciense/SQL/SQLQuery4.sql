SELECT
	p.Name AS ProductName,
	p.ListPrice,
	SUM(sod.OrderQty) AS TotalQuantity,
	SUM(sod.LineTotal) AS TotalRevenue

FROM Production.Product AS P

JOIN Sales.SalesOrderDetail sod
	ON p.ProductID = sod.ProductID

GROUP BY 
	p.Name,
	p.ListPrice

HAVING SUM(sod.LineTotal) > 5000

ORDER BY TotalRevenue DESC;