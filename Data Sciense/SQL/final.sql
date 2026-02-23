DECLARE @MaxDate datetime;
SELECT @MaxDate = MAX(OrderDate) FROM Sales.SalesOrderHeader;

SELECT 
    base.CustomerID,
    base.TotalSpent,
    base.CustomerRank,
    p.EmailPromotion,
    CASE 
        WHEN base.LastOrderDate < DATEADD(month, -4, @MaxDate) THEN 1 
        ELSE 0 
    END AS IsChurned
FROM (
    SELECT
        c.CustomerID,
        c.PersonID,
        SUM(soh.TotalDue) AS TotalSpent,
        MAX(soh.OrderDate) AS LastOrderDate,
        DENSE_RANK() OVER(ORDER BY SUM(soh.TotalDue) DESC) AS CustomerRank
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
    GROUP BY c.CustomerID, c.PersonID
) AS base
JOIN Person.Person p ON base.PersonID = p.BusinessEntityID;

