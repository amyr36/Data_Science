SELECT
	st.Name AS StoreName,
	CONVERT(DATE, soh.OrderDate) AS OrderDay,
	SUM(soh.TotalDue) AS DailyRevenue

FROM Sales.SalesOrderHeader soh

JOIN Sales.Customer c
	ON soh.CustomerID = c.CustomerID

JOIN Sales.Store st
	ON c.StoreID = st.BusinessEntityID

GROUP BY 
	st.Name,
	CONVERT(DATE, soh.OrderDate)

ORDER BY 
	StoreName, 
	DailyRevenue;