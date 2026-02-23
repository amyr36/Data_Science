CREATE PROCEDURE SP_RFM_Customer
	@FromDate DATE = NULL,
	@ToDate DATE = NULL
AS

BEGIN
	
	SET NOCOUNT ON;

	SELECT 
		CustomerID,
		DATEDIFF(DAY, MAX(OrderDate), GETDATE()) AS Recency,
		COUNT(SalesOrderID) AS Frequency,
		SUM(TotalDue) AS Monetary
	FROM 
		Sales.SalesOrderHeader
	WHERE 
		CustomerID IS NOT NULL 
		AND (@FromDate IS NULL OR @FromDate <= OrderDate)
		AND (@ToDate   IS NULL OR DATEADD(DAY, 1, @ToDate) > OrderDate)
	GROUP BY
		 CustomerID;

END;