GO

CREATE NONCLUSTERED INDEX IDX_SalesOrderDetail_ProductID
ON Sales.SalesOrderDetail(ProductID)
INCLUDE(LineTotal)



GO 

SELECT p.Name, SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesOrderDetail sod
JOIN Production.Product p
ON sod.ProductID = p.ProductID
WHERE sod.ProductID = 342
GROUP BY p.Name;
