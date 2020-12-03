USE [ALBA_POC]
GO
/****** Object:  StoredProcedure [dbo].[ExceptionLogging]    Script Date: 03-12-2020 11:44:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER Procedure [dbo].[ExceptionLogging]  

   (  
@ExceptionMsg varchar(100)=null, 
@ExceptionStackTrace varchar(100)=null, 
@ExceptionType varchar(100)=null,  
@ExceptionSource nvarchar(max)=null,  
@ExceptionURL varchar(100)=null,
@UserId varchar(100)=null
) 
AS
BEGIN 
Insert into [dbo].[ExceptionLoggingToDataBase]
(  
ExceptionMsg , 
ExceptionStackTrace,
ExceptionType,   
ExceptionSource,  
ExceptionURL,  
Logdate,
UserID
)  
select  
@ExceptionMsg,  
@ExceptionStackTrace,
@ExceptionType,  
@ExceptionSource,  
@ExceptionURL,  
getdate() ,
@UserId
 END 
 
/* **********************************************************************
Author:  P0312
Creation Date: 12-11-2020
Desc: Template for StoreProc
*************************************************************************
Sample
======
exec --INSERT PROC NAME AND PARAMETERS HERE
 
GRANT EXECUTE on [PROC NAME HERE] TO public
 
Change History
DATE		CHANGED BY		DESCRIPTION
	
*/
BEGIN

DECLARE @transtate BIT
IF @@TRANCOUNT = 0
BEGIN
	SET @transtate = 1
	BEGIN TRANSACTION transtate
END
 
BEGIN TRY
 
/*INSERT CODE HERE*/
	
	IF @transtate = 1 
        AND XACT_STATE() = 1
        COMMIT TRANSACTION transtate
END TRY
BEGIN CATCH
 
DECLARE @Error_Message VARCHAR(5000)
DECLARE @Error_Severity INT
DECLARE @Error_State INT
 
SELECT @Error_Message = ERROR_MESSAGE()
SELECT @Error_Severity = ERROR_SEVERITY()
SELECT @Error_State = ERROR_STATE()
 
   IF @transtate = 1 
   AND XACT_STATE() <> 0
   ROLLBACK TRANSACTION
 
RAISERROR (@Error_Message, @Error_Severity, @Error_State)
 
END CATCH
END
 
--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
