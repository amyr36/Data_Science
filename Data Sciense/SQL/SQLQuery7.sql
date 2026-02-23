SELECT 
	p.ProductID,
	p.Name AS ProductName,
	ISNULL(SUM(sod.OrderQty), 0) AS TotalQuantitySold

FROM Production.Product p

LEFT JOIN Sales.SalesOrderDetail sod
	ON p.ProductID = sod.ProductID

GROUP BY 
	p.ProductID,
	p.Name

HAVING ISNULL(SUM(sod.OrderQty), 0) < 100

ORDER BY p.Name;