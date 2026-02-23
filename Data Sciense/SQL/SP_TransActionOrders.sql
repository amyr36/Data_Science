CREATE OR ALTER PROCEDURE SP_Order_TransAction
	@ProductID INT,
	@OrderQty INT,
	@CustomerID INT,
	@OrderID INT OUTPUT
AS

BEGIN

	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	DECLARE @StockQty INT; 

	BEGIN TRY
		BEGIN TRANSACTION

			SELECT 
				@StockQty = Quantity
			FROM 
				Production.ProductInventory
			WHERE
				@ProductID = ProductID;

			IF @StockQty IS NULL
				THROW 50001, 'Product not found in inventory.', 1;

			IF @StockQty < @OrderQty
				THROW 50002, 'Not enough stock available.', 1;


			INSERT INTO Sales.SalesOrderHeader
				(OrderDate, DueDate, CustomerID, Status, OnlineOrderFlag)
			VALUES
				(GETDATE(), DATEADD(DAY, 7, GETDATE()), @CustomerID, 5, 1);
			SET 
				@OrderID = SCOPE_IDENTITY();


			INSERT INTO Sales.SalesOrderDetail
				(SalesOrderID, OrderQty, ProductID, UnitPrice)
			SELECT
				@OrderID,
				@OrderQty,
				@ProductID,
				ListPrice
			FROM 
				Production.Product
			WHERE 
				ProductID=@ProductID;

			UPDATE Production.ProductInventory
			SET
				Quantity = Quantity - @OrderQty
			WHERE 
				ProductID = @ProductID

		COMMIT;
	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK;

		THROW;
	END CATCH;
END;


				

