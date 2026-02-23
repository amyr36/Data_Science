CREATE TABLE Audit_DataVolumAlert
(
	AlertID INT IDENTITY PRIMARY KEY,
	TableName SYSNAME,
	RowInserted INT,
	AlterTime DateTime2 DEFAULT SYSDATETIME()
);

GO

CREATE TRIGGER TRG_monitor_SalesOrderDetail_Volume
ON Sales.SalesOrderDetail
AFTER INSERT
AS

BEGIN

	SET NOCOUNT ON;

	DECLARE @RowCount INT;
	SELECT @RowCount = COUNT(*) FROM inserted;

	IF @RowCount > 500
	BEGIN
		INSERT INTO Audit_DataVolumAlert
			(RowInserted, TableName)
		VALUES(@RowCount, 'Sales.SalesOrderDetail');
	END

END;

GO