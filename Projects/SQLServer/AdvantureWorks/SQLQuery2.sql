SELECT
	pm.Name AS ModelName,
	SUM(LineTotal) AS TotalSales

FROM Production.Product p

JOIN Production.ProductModel pm
	ON pm.ProductModelID = p.ProductModelID

JOIN Sales.SalesOrderDetail sod
	ON p.ProductID = sod.ProductID

GROUP BY pm.Name

ORDER BY TotalSales DESC;