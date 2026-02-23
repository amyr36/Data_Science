SELECT
	p.Name AS ProductName,
	pc.Name AS ProductCategory,
	SUM(LineTotal) AS Renevue,
	RANK() OVER(PARTITION BY pc.Name
				ORDER BY SUM(LineTotal) DESC) AS RevenueRank

FROM Sales.SalesOrderDetail sod

JOIN Production.Product p
	ON sod.ProductID = p.ProductID

JOIN Production.ProductSubcategory ps
	ON p.ProductSubcategoryID = ps.ProductSubcategoryID

JOIN Production.ProductCategory pc
	ON ps.ProductCategoryID = pc.ProductCategoryID

GROUP BY 
	p.Name,
	pc.Name