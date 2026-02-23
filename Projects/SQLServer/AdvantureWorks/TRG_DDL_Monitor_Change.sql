GO

CREATE TABLE dbo.SchemaChangeLog
(
	LogID INT IDENTITY PRIMARY KEY,
	EventType NVARCHAR(50),
	ObjectName NVARCHAR(75),
	ObjectType NVARCHAR(50),
	ExecutedBy NVARCHAR(75),
	EventTime DATETIME2 DEFAULT SYSDATETIME(),
	TSQLCommand NVARCHAR(MAX)
);



GO

CREATE TRIGGER trg_ddl_schema_monitor
ON DATABASE
FOR CREATE_TABLE, ALTER_TABLE, DROP_TABLE
AS

BEGIN
	
	SET NOCOUNT ON;

	DECLARE @EventData XML = EVENTDATA();

	INSERT INTO dbo.SchemaChangeLog
	(
		EventType,
		ObjectName,
		ObjectType,
		ExecutedBy,
		TSQLCommand
	)
	VALUES
	(
		@EventData.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(50)'),
		@EventData.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(75)'),
		@EventData.value('(/EVENT_INSTANCE/ObjectType)[1]', 'NVARCHAR(50)'),
		ORIGINAL_LOGIN(),
		@EventData.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)')
	);

END;