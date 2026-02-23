SELECT
	CASE soh.Status
		WHEN 1 THEN 'In Process'
		WHEN 2 THEN 'Approved'
		WHEN 3 THEN 'BackOrdered'
		WHEN 4 THEN 'Rejected'
		WHEN 5 THEN 'Shipped'
		WHEN 6 THEN 'Cancelled'
	END AS OrderStatus,
	COUNT(*) AS OrderCount

FROM Sales.SalesOrderHeader soh

GROUP BY soh.Status

ORDER BY OrderCount DESC;
