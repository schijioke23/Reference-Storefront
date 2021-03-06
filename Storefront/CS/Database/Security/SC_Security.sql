IF OBJECT_ID('tempdb..#SCSecurity') IS NOT NULL
BEGIN
	DROP TABLE #SCSecurity
END

SET NOCOUNT ON

CREATE TABLE #SCSecurity (
	DatabaseName varchar(100),
	UserName varchar(100),
	RoleName varchar(100)
)

/* Sitecore Core DB */
INSERT INTO #SCSecurity VALUES ('$(SC_DB_NAME_CORE)', '$(CS_USER_FOUNDATION)', 'db_datareader')
INSERT INTO #SCSecurity VALUES ('$(SC_DB_NAME_CORE)', '$(CS_USER_FOUNDATION)', 'db_datawriter')

/* Sitecore Web DB */
INSERT INTO #SCSecurity VALUES ('$(SC_DB_NAME_WEB)', '$(CS_USER_FOUNDATION)', 'db_datareader')
INSERT INTO #SCSecurity VALUES ('$(SC_DB_NAME_WEB)', '$(CS_USER_FOUNDATION)', 'db_datawriter')

/* Sitecore Master DB */
INSERT INTO #SCSecurity VALUES ('$(SC_DB_NAME_MASTER)', '$(CS_USER_FOUNDATION)', 'db_datareader')
INSERT INTO #SCSecurity VALUES ('$(SC_DB_NAME_MASTER)', '$(CS_USER_FOUNDATION)', 'db_datawriter')

/* Sitecore DMS DB */
IF EXISTS (SELECT * FROM sys.databases WHERE name = '$(SC_DB_NAME_DMS)')
BEGIN
	INSERT INTO #SCSecurity VALUES ('$(SC_DB_NAME_DMS)', '$(CS_USER_FOUNDATION)', 'db_datareader')
	INSERT INTO #SCSecurity VALUES ('$(SC_DB_NAME_DMS)', '$(CS_USER_FOUNDATION)', 'db_datawriter')
END

GO

DECLARE @databaseName VARCHAR(100)
DECLARE @userName VARCHAR(100)
DECLARE @roleName VARCHAR(100)
DECLARE @dynamicSQL VARCHAR(MAX)

DECLARE db_cursor CURSOR FOR  
SELECT DatabaseName, UserName, RoleName
FROM #SCSecurity

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @databaseName, @userName, @roleName   

WHILE @@FETCH_STATUS = 0   
BEGIN   
	USE [master]
	
	/* If the user does not exist as a login, add it to the system security */	
	IF NOT EXISTS(SELECT name FROM master.dbo.syslogins WHERE name = @userName)
	BEGIN
		PRINT 'Creating login ' + @userName
		EXEC( 'CREATE LOGIN [' + @userName + '] FROM WINDOWS' )
	END
	
	
	SET @dynamicSQL = 'USE [' + @databaseName + ']; ' +
		'DECLARE @isLogin bit;' +
		'IF  NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = ''' + @userName + ''') ' +
		'BEGIN ' +
			'PRINT ''Creating user ' + @userName + '''; ' +
			' CREATE USER [' + @userName + '] FOR LOGIN [' + @userName + '];' +
		'END ' +
		'EXECUTE AS LOGIN = ''' + @userName + ''';' +
			'SET @isLogin = IS_MEMBER(''' + @roleName + ''');' +
		'REVERT;' +
		
		'IF @isLogin = 0 ' +
		'BEGIN ' +
			'PRINT ''Adding user ' + @userName + ' to role ' + @roleName + ''';' +
			'EXEC sp_addrolemember ''' + @roleName + ''', ''' + @userName + ''';' +
			'GRANT EXECUTE TO [' + @userName + '];' +
		'END;'
	EXEC( @dynamicSQL)
	
	FETCH NEXT FROM db_cursor INTO @databaseName, @userName, @roleName   
END

CLOSE db_cursor   
DEALLOCATE db_cursor
