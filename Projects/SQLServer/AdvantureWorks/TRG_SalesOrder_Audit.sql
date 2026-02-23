CREATE TABLE SalesOrder_Audit
(
	AuditID INT IDENTITY PRIMARY KEY,
	SalesOrderID INT,
	OldTotalDue DECIMAL(18, 2),
	NewTotalDue DECIMAL(18, 2),
	ChangedAt DATETIME2 DEFAULT SYSDATETIME(),
	ChangedBy SYSNAME DEFAULT SUSER_SNAME()
);



CREATE TRIGGER TRG_SalesOrder_TotalDue_Audit
ON Sales.SalesOrderHeader
AFTER UPDATE
AS

BEGIN
	
	SET NOCOUNT ON;

	IF NOT UPDATE(TotalDue)
		RETURN;

	INSERT INTO SalesOrder_Audit
	(SalesOrderID, OldTotalDue, NewTotalDue)

	SELECT
		i.SalesOrderID,
		d.TotalDue,
		i.TotalDue
	FROM 
		inserted i
	JOIN 
		deleted d
		ON i.SalesOrderID = d.SalesOrderID
	WHERE
		ISNULL(i.TotalDue, 0) <> ISNULL(d.TotalDue, 0);

END;


