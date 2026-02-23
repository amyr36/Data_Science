CREATE PROCEDURE SP_get_customer_behavier
	@CustomerID INT,
	@CustomerLifeTimeDays INT OUTPUT,
	@OrderPerDay INT OUTPUT
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @OrderCount INT;

	SELECT
		@CustomerLifeTimeDays = DATEDIFF(DAY, MIN(OrderDate), MAX(OrderDate)),
		@OrderCount = COUNT(DISTINCT SalesOrderID)
	FROM
		Sales.SalesOrderHeader
	WHERE 
		CustomerID = @CustomerID
	GROUP BY
		CustomerID;

	SET @OrderPerDay = 
		CASE
			WHEN @CustomerLifeTimeDays = 0 OR @CustomerLifeTimeDays IS NULL THEN 0
			ELSE @OrderCount * 1.0 / @CustomerLifeTimeDays
		END;

END;


		
								