GO

CREATE NONCLUSTERED INDEX idx_SalesOrderHeadear_customerID_OrderDate
ON Sales.SalesOrderHeader(CustomerID, OrderDate) 
INCLUDE(TotalDue, Status);



GO

SELECT CustomerID, OrderDate, TotalDue, Status
FROM Sales.SalesOrderHeader
WHERE CustomerID = 13264 AND
OrderDate BETWEEN '2024-06-06' AND '2024-12-12';

