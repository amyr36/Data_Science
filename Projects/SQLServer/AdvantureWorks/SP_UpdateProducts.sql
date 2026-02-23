CREATE PROCEDURE update_products
	@ProductID INT,
	@Name NVARCHAR(50),
	@Color NVARCHAR(40)
AS

BEGIN

	SET NOCOUNT ON

	BEGIN TRY
		BEGIN TRAN

			IF @Name IS NULL OR LEN(@Name) = 0
				THROW 50001, 'Invalid Name', 1

			UPDATE Production.Product
			SET
				Name = @Name,
				Color = @Color
			WHERE
				ProductID = @ProductID
				AND
				(
					Name <> @Name
					OR
					ISNULL(Color, '') <> ISNULL(@Color, '')
				)

			IF NOT EXISTS ( SELECT 1 FROM Production.Product WHERE ProductID = @ProductID)
				THROW 50002, 'Product ID not found', 1
		COMMIT TRAN
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		THROW
	END CATCH

END
