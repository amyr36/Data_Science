CREATE OR ALTER PROCEDURE report_churn_customers
	@InactiveDays INT = 180,
	@EndTime DATE = '2024-12-29'
AS

BEGIN
	
	SET NOCOUNT ON;

	-- CREATE CTE 
	WITH CustomerLastOrder AS
	(
		SELECT
			CustomerID,
			MAX(OrderDate) AS LastOrderDate
		FROM
			Sales.SalesOrderHeader
		WHERE
			CustomerID IS NOT NULL
		GROUP BY
			CustomerID
	)

	SELECT 
		CustomerID,
		LastOrderDate,
		DATEDIFF(DAY, LastOrderDate, @EndTime) AS InactiveTime
	FROM 
		CustomerLastOrder
	WHERE
		LastOrderDate <= DATEADD(DAY, -@InactiveDays, @EndTime); 

END

