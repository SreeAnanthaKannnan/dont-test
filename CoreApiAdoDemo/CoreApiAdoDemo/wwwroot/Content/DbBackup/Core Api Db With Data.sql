use MESCore

CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](500) NOT NULL,
	[EmailId] [nvarchar](500) NULL,
	[Mobile] [nvarchar](20) NULL,
	[Address] [nvarchar](max) NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[Users] ON 

GO
INSERT [dbo].[Users] ([Id], [Name], [EmailId], [Mobile], [Address], [IsActive]) VALUES (1, N'Ravi', N'ravi@gmail.com', N'1234567890', N'Dwarka sector 1', 1)
GO
INSERT [dbo].[Users] ([Id], [Name], [EmailId], [Mobile], [Address], [IsActive]) VALUES (9, N'Oliver', N'oliver@isarrow.com', N'139768176', N'Star City', 1)
GO
INSERT [dbo].[Users] ([Id], [Name], [EmailId], [Mobile], [Address], [IsActive]) VALUES (7, N'Barry', N'Barry@isflash.com', N'1783983', N'Central City', 1)
GO
INSERT [dbo].[Users] ([Id], [Name], [EmailId], [Mobile], [Address], [IsActive]) VALUES (5, N'Bruce', N'bruce@isbatman.com', N'4388298', N'Gotham city', 1)
GO
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
/****** Object:  StoredProcedure [dbo].[DeleteUser]    Script Date: 08-06-2018 16:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
use MESCore

CREATE PROCEDURE [dbo].[GetUsers]
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM Users(NOLOCK) ORDER BY Id ASC
END

GO
/****** Object:  StoredProcedure [dbo].[SaveUser]    Script Date: 08-06-2018 16:33:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[DeleteUser]
(
@Id INT,
@ReturnCode NVARCHAR(20) OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON;
	SET @ReturnCode = 'C200'
	IF NOT EXISTS (SELECT 1 FROM Users WHERE Id = @Id)
	BEGIN
		SET @ReturnCode ='C203'
		RETURN
	END
	ELSE
	BEGIN
		DELETE FROM Users WHERE Id = @Id
		SET @ReturnCode = 'C200'
		RETURN
	END
END

GO


CREATE PROCEDURE [dbo].[SaveUser]
(
@Id INT,
@Name NVARCHAR(MAX),
@EmailId NVARCHAR(MAX),
@Mobile NVARCHAR(20),
@Address NVARCHAR(MAX),
@ReturnCode NVARCHAR(20) OUTPUT
)
AS
BEGIN
	SET @ReturnCode = 'C200'
	IF(@Id <> 0)
	BEGIN
		IF EXISTS (SELECT 1 FROM Users WHERE EmailId = @EmailId AND Id <> @Id)
		BEGIN
			SET @ReturnCode = 'C201'
			RETURN
		END
		IF EXISTS (SELECT 1 FROM Users WHERE Mobile = @Mobile AND Id <> @Id)
		BEGIN
			SET @ReturnCode = 'C202'
			RETURN
		END

		UPDATE Users SET
		Name = @Name,
		EmailId = @EmailId,
		Mobile = @Mobile,
		Address = @Address,
		IsActive = 1
		WHERE Id = @Id

		SET @ReturnCode = 'C200'
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT 1 FROM Users WHERE EmailId = @EmailId)
		BEGIN
			SET @ReturnCode = 'C201'
			RETURN
		END
		IF EXISTS (SELECT 1 FROM Users WHERE Mobile = @Mobile)
		BEGIN
			SET @ReturnCode = 'C202'
			RETURN
		END

		INSERT INTO Users (Name,EmailId,Mobile,Address,IsActive)
		VALUES (@Name,@EmailId,@Mobile,@Address,1)

		SET @ReturnCode = 'C200'
	END
END

GO

--SELECT @@SERVERNAME

--select * from dbo.users