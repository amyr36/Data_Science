WITH MonthlySales AS 
(
	SELECT
		YEAR(OrderDate) AS YEAR,
		MONTH(OrderDate) AS MONTH,
		SUM(TotalDue) AS TotalSales

	FROM Sales.SalesOrderHeader

	GROUP BY 
		YEAR(OrderDate),
		MONTH(OrderDate)
)

SELECT 
	MONTH,
	YEAR,
	TotalSales,
	COALESCE 
	(
		(TotalSales - LAG(TotalSales) OVER (ORDER BY YEAR DESC, MONTH DESC))
		* 100 /
        LAG(TotalSales) OVER (ORDER BY YEAR,  MONTH),
        0
    ) AS GrowthPercent

FROM MonthlySales;
