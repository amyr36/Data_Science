CREATE  PROCEDURE customer_order_report
	@CustomerID INT,
	@StartDate DATE,
	@EndDate DATE
AS

BEGIN
	
	SET NOCOUNT ON

	IF @CustomerID IS NULL OR @CustomerID <= 0
		THROW 50001, 'Invalid CustomerID', 1

	IF @StartDate IS NULL OR @EndDate IS NULL
		THROW 50002, 'StartDate and EndDate must be provied', 1

	IF @EndDate < @StartDate
		THROW 50003, 'StartDate must be smaler than EndDate', 1

	IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderHeader WHERE CustomerID = @CustomerID)
		THROW 50004, 'CustomerID does not exist', 1

	SELECT 
		soh.CustomerID,
		soh.OrderDate,
		ISNULL(SUM(sod.OrderQty), 0) AS TotalOrders,
		ISNULL(SUM(soh.TotalDue), 0) AS TotalSales
	FROM 
		Sales.SalesOrderHeader soh
	LEFT JOIN 
		Sales.SalesOrderDetail sod
		ON
			soh.SalesOrderID = sod.SalesOrderID
	WHERE
		soh.CustomerID = @CustomerID
		AND
		OrderDate BETWEEN @StartDate AND @EndDate
	GROUP BY
		soh.CustomerID,
		soh.OrderDate
	ORDER BY
		soh.OrderDate

END