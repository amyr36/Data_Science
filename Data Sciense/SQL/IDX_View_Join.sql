GO

CREATE VIEW vw_ProductSales WITH SCHEMABINDING AS
SELECT
    p.ProductID,
    p.Name,
    soh.SalesOrderID,
    soh.OrderDate,
    sod.LineTotal,
    sod.OrderQty
FROM Sales.SalesOrderDetail sod
JOIN Sales.SalesOrderHeader soh
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product p
    ON sod.ProductID = p.ProductID;
GO

CREATE UNIQUE CLUSTERED INDEX IX_vw_ProductSales
ON vw_ProductSales(ProductID, SalesOrderID);



GO

SELECT 
	p.Name,
	soh.OrderDate,
	SUM(sod.LineTotal) AS TotalSales,
	SUM(sod.OrderQty) AS TotalQty

FROM Production.Product p

JOIN Sales.SalesOrderDetail sod
ON p.ProductID = sod.ProductID

JOIN Sales.SalesOrderHeader soh
ON sod.SalesOrderID = soh.SalesOrderID

WHERE OrderDate BETWEEN '2024-01-01' AND '2024-12-29'

GROUP BY 
	p.Name,
	soh.OrderDate

ORDER BY TotalSales;

