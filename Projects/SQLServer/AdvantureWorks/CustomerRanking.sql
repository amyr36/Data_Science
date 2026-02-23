SELECT 
	*,
	CASE 
		WHEN CustomerRank <= 100 THEN 'Platinum' 
		WHEN CustomerRank BETWEEN 101 AND 500 THEN 'Gold'
		ELSE 'Silver'
	END AS CustomerCategory

FROM
(
	SELECT
		c.CustomerID,
		p.FirstName + ' ' + p.LastName AS CustomerName,
		SUM(soh.TotalDue) AS TotalSpent,
		DENSE_RANK() OVER(ORDER BY SUM(TotalDue) DESC) AS CustomerRank
	
	FROM Sales.Customer c

	JOIN Sales.SalesOrderHeader soh
		ON c.CustomerID = soh.CustomerID
	JOIN Person.Person p
		ON c.PersonID = p.BusinessEntityID

	GROUP BY 
		c.CustomerID, 
		p.FirstName,
		p.LastName

) AS RAnkedCustomers;
	
