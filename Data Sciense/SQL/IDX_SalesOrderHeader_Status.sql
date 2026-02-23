GO

CREATE NONCLUSTERED INDEX IDX_SalesOrderHeader_Status
ON Sales.SalesOrderHeader(CustomerID)
WHERE Status = 5;



GO

SELECT CustomerID FROM Sales.SalesOrderHeader
WHERE Status = 5
AND CustomerID = 13798


