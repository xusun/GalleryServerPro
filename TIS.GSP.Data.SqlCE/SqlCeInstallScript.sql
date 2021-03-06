﻿DROP TABLE gs_UserGalleryProfile;
GO
DROP TABLE gs_Synchronize;
GO
DROP TABLE gs_Role_Album;
GO
DROP TABLE gs_Role;
GO
DROP TABLE gs_MimeTypeGallery;
GO
DROP TABLE gs_MimeType;
GO
DROP TABLE gs_MediaObjectMetadata;
GO
DROP TABLE gs_MediaObject;
GO
DROP TABLE gs_GallerySetting;
GO
DROP TABLE gs_GalleryControlSetting;
GO
DROP TABLE gs_BrowserTemplate;
GO
DROP TABLE gs_AppSetting;
GO
DROP TABLE gs_AppError;
GO
DROP TABLE gs_Album;
GO
DROP TABLE gs_Gallery;
GO
DROP TABLE aspnet_UsersInRoles;
GO
DROP TABLE aspnet_Profile;
GO
DROP TABLE aspnet_Membership;
GO
DROP TABLE aspnet_Users;
GO
DROP TABLE aspnet_Roles;
GO
DROP TABLE aspnet_Applications;
GO

/* ASP.NET membership, roles, and profiles tables */
CREATE TABLE [aspnet_Applications] (
	[ApplicationName] nvarchar(256) NOT NULL
, [LoweredApplicationName] nvarchar(256) NOT NULL
, [ApplicationId] uniqueidentifier NOT NULL DEFAULT (newid())
, [Description] nvarchar(256) NULL
);
GO

CREATE TABLE [aspnet_Membership] (
	[ApplicationId] uniqueidentifier NOT NULL
, [UserId] uniqueidentifier NOT NULL
, [Password] nvarchar(128) NOT NULL
, [PasswordFormat] int NOT NULL DEFAULT ((0))
, [PasswordSalt] nvarchar(128) NOT NULL
, [MobilePIN] nvarchar(16) NULL
, [Email] nvarchar(256) NULL
, [LoweredEmail] nvarchar(256) NULL
, [PasswordQuestion] nvarchar(256) NULL
, [PasswordAnswer] nvarchar(128) NULL
, [IsApproved] bit NOT NULL
, [IsLockedOut] bit NOT NULL
, [CreateDate] datetime NOT NULL
, [LastLoginDate] datetime NOT NULL
, [LastPasswordChangedDate] datetime NOT NULL
, [LastLockoutDate] datetime NOT NULL
, [FailedPasswordAttemptCount] int NOT NULL
, [FailedPasswordAttemptWindowStart] datetime NOT NULL
, [FailedPasswordAnswerAttemptCount] int NOT NULL
, [FailedPasswordAnswerAttemptWindowStart] datetime NOT NULL
, [Comment] ntext NULL
);
GO

CREATE TABLE [aspnet_Profile] (
	[UserId] uniqueidentifier NOT NULL
, [PropertyNames] ntext NOT NULL
, [PropertyValuesString] ntext NOT NULL
, [PropertyValuesBinary] image NOT NULL
, [LastUpdatedDate] datetime NOT NULL
);
GO

CREATE TABLE [aspnet_Roles] (
	[ApplicationId] uniqueidentifier NOT NULL
, [RoleId] uniqueidentifier NOT NULL DEFAULT (newid())
, [RoleName] nvarchar(256) NOT NULL
, [LoweredRoleName] nvarchar(256) NOT NULL
, [Description] nvarchar(256) NULL
);
GO

CREATE TABLE [aspnet_Users] (
	[ApplicationId] uniqueidentifier NOT NULL
, [UserId] uniqueidentifier NOT NULL DEFAULT (newid())
, [UserName] nvarchar(256) NOT NULL
, [LoweredUserName] nvarchar(256) NOT NULL
, [MobileAlias] nvarchar(16) NULL DEFAULT (NULL)
, [IsAnonymous] bit NOT NULL DEFAULT ((0))
, [LastActivityDate] datetime NOT NULL
);
GO

CREATE TABLE [aspnet_UsersInRoles] (
	[UserId] uniqueidentifier NOT NULL
, [RoleId] uniqueidentifier NOT NULL
);
GO

/* GSP tables */
CREATE TABLE [gs_Role] (
	[RoleName] [nvarchar](256) NOT NULL CONSTRAINT [PK_gs_Role] PRIMARY KEY, 
	[AllowViewAlbumsAndObjects] [bit] NOT NULL, 
	[AllowViewOriginalImage] [bit] NOT NULL, 
	[AllowAddChildAlbum] [bit] NOT NULL, 
	[AllowAddMediaObject] [bit] NOT NULL, 
	[AllowEditAlbum] [bit] NOT NULL, 
	[AllowEditMediaObject] [bit] NOT NULL, 
	[AllowDeleteChildAlbum] [bit] NOT NULL, 
	[AllowDeleteMediaObject] [bit] NOT NULL, 
	[AllowSynchronize] [bit] NOT NULL, 
	[HideWatermark] [bit] NOT NULL, 
	[AllowAdministerGallery] [bit] NOT NULL, 
	[AllowAdministerSite] [bit] NOT NULL
);
GO

CREATE TABLE [gs_MimeType] (
	[MimeTypeId] [int] IDENTITY (1, 1) NOT NULL CONSTRAINT [PK_gs_MimeType] PRIMARY KEY,
	[FileExtension] [nvarchar](10) NOT NULL CONSTRAINT [UC_gs_MimeType_FileExtension] UNIQUE, 
	[MimeTypeValue] [nvarchar](200) NOT NULL, 
	[BrowserMimeTypeValue] [nvarchar](200) NOT NULL
);
GO

CREATE TABLE [gs_GalleryControlSetting] (
	[GalleryControlSettingId] [int] IDENTITY (1, 1) NOT NULL CONSTRAINT [PK_gs_GalleryControlSetting] PRIMARY KEY, 
	[ControlId] [nvarchar](350) NOT NULL, 
	[SettingName] [nvarchar](200) NOT NULL, 
	[SettingValue] [ntext] NOT NULL, 
	CONSTRAINT [UC_gs_GalleryControlSetting_ControlId_SettingName] UNIQUE([ControlId], [SettingName])
);
GO

CREATE TABLE [gs_Gallery] (
	[GalleryId] [int] IDENTITY (-2147483648, 1) NOT NULL CONSTRAINT [PK_gs_Gallery] PRIMARY KEY, 
	[Description] [nvarchar](1000) NOT NULL, 
	[DateAdded] [datetime] NOT NULL
);
GO

CREATE TABLE [gs_AppSetting] (
	[AppSettingId] [int] IDENTITY (1, 1) NOT NULL CONSTRAINT [PK_gs_AppSetting] PRIMARY KEY, 
	[SettingName] [nvarchar](200) NOT NULL, 
	[SettingValue] [ntext] NOT NULL
);
GO

CREATE TABLE [gs_BrowserTemplate] (
	[BrowserTemplateId] [int] IDENTITY (1, 1) NOT NULL CONSTRAINT [PK_gs_BrowserTemplate] PRIMARY KEY, 
	[MimeType] [nvarchar](200) NOT NULL, 
	[BrowserId] [nvarchar](50) NOT NULL, 
	[HtmlTemplate] [ntext] NOT NULL, 
	[ScriptTemplate] [ntext] NOT NULL, 
	CONSTRAINT [UC_gs_BrowserTemplate_MimeType_BrowserId] UNIQUE([MimeType], [BrowserId])
);
GO

CREATE TABLE [gs_AppError] (
	[AppErrorId] [int] IDENTITY (1, 1) NOT NULL CONSTRAINT [PK_gs_AppError] PRIMARY KEY, 
	[FKGalleryId] [int] NOT NULL, 
	[TimeStamp] [datetime] NOT NULL, 
	[ExceptionType] [nvarchar](1000) NOT NULL, 
	[Message] [nvarchar](4000) NOT NULL, 
	[Source] [nvarchar](1000) NOT NULL, 
	[TargetSite] [ntext] NOT NULL, 
	[StackTrace] [ntext] NOT NULL, 
	[ExceptionData] [ntext] NOT NULL, 
	[InnerExType] [nvarchar](1000) NOT NULL, 
	[InnerExMessage] [nvarchar](4000) NOT NULL, 
	[InnerExSource] [nvarchar](1000) NOT NULL, 
	[InnerExTargetSite] [ntext] NOT NULL, 
	[InnerExStackTrace] [ntext] NOT NULL, 
	[InnerExData] [ntext] NOT NULL, 
	[Url] [nvarchar](1000) NOT NULL, 
	[FormVariables] [ntext] NOT NULL, 
	[Cookies] [ntext] NOT NULL, 
	[SessionVariables] [ntext] NOT NULL, 
	[ServerVariables] [ntext] NOT NULL
);
GO

CREATE TABLE [gs_Album] (
	[AlbumId] [int] IDENTITY (1, 1) NOT NULL CONSTRAINT [PK_gs_Album] PRIMARY KEY, 
	[FKGalleryId] [int] NOT NULL, 
	[AlbumParentId] [int] NOT NULL, 
	[Title] [nvarchar](1000) NOT NULL CONSTRAINT [DF_gs_Album_Title] DEFAULT (''), 
	[DirectoryName] [nvarchar](255) NOT NULL CONSTRAINT [DF_gs_Album_DirectoryName] DEFAULT (''), 
	[Summary] [ntext] NOT NULL CONSTRAINT [DF_gs_Album_Summary] DEFAULT (''), 
	[ThumbnailMediaObjectId] [int] NOT NULL CONSTRAINT [DF_gs_Album_ThumbnailMediaObjectId] DEFAULT ((0)), 
	[Seq] [int] NOT NULL, 
	[DateStart] [datetime] NULL, 
	[DateEnd] [datetime] NULL, 
	[DateAdded] [datetime] NOT NULL, 
	[CreatedBy] [nvarchar](256) NOT NULL, 
	[LastModifiedBy] [nvarchar](256) NOT NULL, 
	[DateLastModified] [datetime] NOT NULL, 
	[OwnedBy] [nvarchar](256) NOT NULL, 
	[OwnerRoleName] [nvarchar](256) NOT NULL, 
	[IsPrivate] [bit] NOT NULL CONSTRAINT [DF_gs_Album_IsPrivate] DEFAULT ((0))
);
GO

CREATE TABLE [gs_GallerySetting] (
	[GallerySettingId] [int] IDENTITY (1, 1) NOT NULL CONSTRAINT [PK_gs_GallerySetting] PRIMARY KEY, 
	[FKGalleryId] [int] NOT NULL, 
	[IsTemplate] [bit] NOT NULL, 
	[SettingName] [nvarchar](200) NOT NULL, 
	[SettingValue] [ntext] NOT NULL, 
	CONSTRAINT [UC_gs_GallerySetting_FKGalleryId_SettingName] UNIQUE NONCLUSTERED ([FKGalleryId], [SettingName])
);
GO

CREATE TABLE [gs_MimeTypeGallery] (
	[MimeTypeGalleryId] [int] IDENTITY (1, 1) NOT NULL CONSTRAINT [PK_gs_MimeTypeGallery] PRIMARY KEY, 
	[FKGalleryId] [int] NOT NULL, 
	[FKMimeTypeId] [int] NOT NULL, 
	[IsEnabled] [bit] NOT NULL, 
	CONSTRAINT [UC_gs_MimeTypeGallery_FKGalleryId_FKMimeTypeId] UNIQUE NONCLUSTERED ([FKGalleryId], [FKMimeTypeId])
);
GO

CREATE TABLE [gs_Synchronize] (
	[FKGalleryId] [int] NOT NULL CONSTRAINT [PK_gs_Synchronize] PRIMARY KEY, 
	[SynchId] [nchar](36) NOT NULL, 
	[SynchState] [int] NOT NULL, 
	[TotalFiles] [int] NOT NULL, 
	[CurrentFileIndex] [int] NOT NULL
);
GO

CREATE TABLE [gs_UserGalleryProfile] (
	[ProfileId] [int] IDENTITY (1, 1) NOT NULL CONSTRAINT [PK_gs_UserGalleryProfile] PRIMARY KEY, 
	[UserName] [nvarchar](256) NOT NULL, 
	[FKGalleryId] [int] NOT NULL, 
	[SettingName] [nvarchar](200) NOT NULL, 
	[SettingValue] [ntext] NOT NULL, 
	CONSTRAINT [UC_gs_UserGalleryProfile_UserName_FKGalleryId_SettingName] UNIQUE([UserName], [FKGalleryId], [SettingName])
);
GO

CREATE TABLE [gs_Role_Album] (
	[FKRoleName] [nvarchar](256) NOT NULL, 
	[FKAlbumId] [int] NOT NULL, 
	CONSTRAINT [PK_gs_Role_Album] PRIMARY KEY ([FKRoleName], [FKAlbumId])
);
GO

CREATE TABLE [gs_MediaObject](
	[MediaObjectId] [int] IDENTITY(1,1) NOT NULL CONSTRAINT [PK_gs_MediaObject] PRIMARY KEY,
	[FKAlbumId] [int] NOT NULL,
	[Title] [ntext] NOT NULL CONSTRAINT [DF_gs_MediaObject_Title]  DEFAULT (''),
	[HashKey] [nchar](47) NOT NULL CONSTRAINT [DF_gs_MediaObject_HashKey]  DEFAULT (''),
	[ThumbnailFilename] [nvarchar](255) NOT NULL CONSTRAINT [DF_gs_MediaObject_ThumbnailFilename]  DEFAULT (''),
	[ThumbnailWidth] [int] NOT NULL CONSTRAINT [DF_gs_MediaObject_ThumbnailWidth]  DEFAULT ((0)),
	[ThumbnailHeight] [int] NOT NULL CONSTRAINT [DF_gs_MediaObject_ThumbnailHeight]  DEFAULT ((0)),
	[ThumbnailSizeKB] [int] NOT NULL,
	[OptimizedFilename] [nvarchar](255) NOT NULL CONSTRAINT [DF_gs_MediaObject_OptimizedFilename]  DEFAULT (''),
	[OptimizedWidth] [int] NOT NULL CONSTRAINT [DF_gs_MediaObject_OptimizedWidth]  DEFAULT ((0)),
	[OptimizedHeight] [int] NOT NULL CONSTRAINT [DF_gs_MediaObject_OptimizedHeight]  DEFAULT ((0)),
	[OptimizedSizeKB] [int] NOT NULL,
	[OriginalFilename] [nvarchar](255) NOT NULL CONSTRAINT [DF_gs_MediaObject_OriginalFilename]  DEFAULT (''),
	[OriginalWidth] [int] NOT NULL CONSTRAINT [DF_gs_MediaObject_OriginalWidth]  DEFAULT ((0)),
	[OriginalHeight] [int] NOT NULL CONSTRAINT [DF_gs_MediaObject_OriginalHeight]  DEFAULT ((0)),
	[OriginalSizeKB] [int] NOT NULL,
	[ExternalHtmlSource] [ntext] NOT NULL,
	[ExternalType] [nvarchar](15) NOT NULL,
	[Seq] [int] NOT NULL,
	[CreatedBy] [nvarchar](256) NOT NULL,
	[DateAdded] [datetime] NOT NULL,
	[LastModifiedBy] [nvarchar](256) NOT NULL,
	[DateLastModified] [datetime] NOT NULL,
	[IsPrivate] [bit] NOT NULL CONSTRAINT [DF_gs_MediaObject_IsPrivate]  DEFAULT ((0))
);
GO

CREATE TABLE [gs_MediaObjectMetadata](
	[MediaObjectMetadataId] [int] IDENTITY(1,1) NOT NULL CONSTRAINT [PK_gs_MediaObjectMetadata] PRIMARY KEY,
	[FKMediaObjectId] [int] NOT NULL,
	[MetadataNameIdentifier] [int] NOT NULL,
	[Description] [nvarchar](200) NOT NULL,
	[Value] [ntext] NOT NULL
);
GO

/* ASP.NET membership, roles, and profiles constraints and indexes */
ALTER TABLE [aspnet_Applications] ADD CONSTRAINT [PK_aspnet_Applications] PRIMARY KEY ([ApplicationId]);
GO
ALTER TABLE [aspnet_Profile] ADD CONSTRAINT [PK_aspnet_Profile] PRIMARY KEY ([UserId]);
GO
ALTER TABLE [aspnet_Roles] ADD CONSTRAINT [PK_aspnet_Roles] PRIMARY KEY ([RoleId]);
GO
ALTER TABLE [aspnet_Users] ADD CONSTRAINT [PK_aspnet_Users] PRIMARY KEY ([UserId]);
GO
ALTER TABLE [aspnet_UsersInRoles] ADD CONSTRAINT [PK_aspnet_UsersInRoles] PRIMARY KEY ([RoleId],[UserId]);
GO
CREATE INDEX [IDX_aspnet_Applications_LoweredApplicationName] ON [aspnet_Applications] ([LoweredApplicationName] ASC);
GO
CREATE UNIQUE INDEX [IDX_aspnet_Applications_ApplicationName] ON [aspnet_Applications] ([ApplicationName] ASC);
GO
CREATE INDEX [IDX_aspnet_Membership_ApplicationId_LoweredEmail] ON [aspnet_Membership] ([ApplicationId] ASC,[LoweredEmail] ASC);
GO
CREATE UNIQUE INDEX [IDX_aspnet_Roles_ApplicationId_LoweredUserName] ON [aspnet_Roles] ([ApplicationId] ASC,[LoweredRoleName] ASC);
GO
CREATE UNIQUE INDEX [IDX_aspnet_Users_ApplicationId_LoweredUserName] ON [aspnet_Users] ([ApplicationId] ASC,[LoweredUserName] ASC);
GO
CREATE INDEX [IDX_aspnet_Users_ApplicationId_LastActivityDate] ON [aspnet_Users] ([ApplicationId] ASC,[LastActivityDate] ASC);
GO
CREATE INDEX [IDX_aspnet_UsersInRoles_RoleId] ON [aspnet_UsersInRoles] ([RoleId] ASC);
GO
ALTER TABLE [aspnet_Membership] ADD CONSTRAINT [FK_aspnet_Membership_aspnet_Applications] FOREIGN KEY ([ApplicationId]) REFERENCES [aspnet_Applications]([ApplicationId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
ALTER TABLE [aspnet_Membership] ADD CONSTRAINT [FK_aspnet_Membership_aspnet_Users] FOREIGN KEY ([UserId]) REFERENCES [aspnet_Users]([UserId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
ALTER TABLE [aspnet_Profile] ADD CONSTRAINT [FK_aspnet_Profile_aspnet_Users] FOREIGN KEY ([UserId]) REFERENCES [aspnet_Users]([UserId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
ALTER TABLE [aspnet_Roles] ADD CONSTRAINT [FK__aspnet_Roles_aspnet_Applications] FOREIGN KEY ([ApplicationId]) REFERENCES [aspnet_Applications]([ApplicationId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
ALTER TABLE [aspnet_Users] ADD CONSTRAINT [FK__aspnet_Users_aspnet_Applications] FOREIGN KEY ([ApplicationId]) REFERENCES [aspnet_Applications]([ApplicationId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
ALTER TABLE [aspnet_UsersInRoles] ADD CONSTRAINT [FK__aspnet_UsersInRoles_aspnet_Roles] FOREIGN KEY ([RoleId]) REFERENCES [aspnet_Roles]([RoleId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO
ALTER TABLE [aspnet_UsersInRoles] ADD CONSTRAINT [FK__aspnet_UsersInRoles_aspnet_Users] FOREIGN KEY ([UserId]) REFERENCES [aspnet_Users]([UserId]) ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

/* GSP constraints and indexes */
CREATE NONCLUSTERED INDEX [IDX_gs_AppError_FKGalleryId] ON [gs_AppError] (FKGalleryId);
GO
CREATE NONCLUSTERED INDEX [IDX_gs_Album_AlbumParentId_FKGalleryId] ON [gs_Album] ([AlbumParentId], [FKGalleryId]);
GO
CREATE NONCLUSTERED INDEX [IDX_gs_Album_AlbumId] ON [gs_Album] ([AlbumId]);
GO
CREATE NONCLUSTERED INDEX [IDX_gs_MediaObject_FKAlbumId] ON [gs_MediaObject] ([FKAlbumId]);
GO
CREATE NONCLUSTERED INDEX [IDX_gs_MediaObject_MediaObjectId_FKAlbumId] ON [gs_MediaObject] ([OriginalFilename], [MediaObjectId], [FKAlbumId]);
GO
CREATE NONCLUSTERED INDEX [IDX_gs_MediaObjectMetadata_FKMediaObjectId] ON [gs_MediaObjectMetadata] ([FKMediaObjectId]);
GO

ALTER TABLE [gs_Album] ADD CONSTRAINT [FK_gs_Album_gs_Gallery] FOREIGN KEY ([FKGalleryId]) REFERENCES [gs_Gallery]([GalleryId]) ON DELETE CASCADE;
GO
ALTER TABLE [gs_AppError] ADD CONSTRAINT [FK_gs_AppError_gs_Gallery] FOREIGN KEY ([FKGalleryId]) REFERENCES [gs_Gallery]([GalleryId]) ON DELETE CASCADE;
GO
ALTER TABLE [gs_GallerySetting] ADD CONSTRAINT [FK_gs_GallerySetting_gs_Gallery] FOREIGN KEY ([FKGalleryId]) REFERENCES [gs_Gallery]([GalleryId]) ON DELETE CASCADE;
GO
ALTER TABLE [gs_MediaObject] ADD CONSTRAINT [FK_gs_MediaObject_gs_Album] FOREIGN KEY ([FKAlbumId]) REFERENCES [gs_Album]([AlbumId]) ON DELETE CASCADE;
GO
ALTER TABLE [gs_MediaObjectMetadata] ADD CONSTRAINT [FK_gs_MediaObjectMetadata_gs_MediaObject] FOREIGN KEY ([FKMediaObjectId]) REFERENCES [gs_MediaObject]([MediaObjectId]) ON DELETE CASCADE;
GO
ALTER TABLE [gs_MimeTypeGallery] ADD CONSTRAINT [FK_gs_MimeTypeGallery_gs_Gallery] FOREIGN KEY ([FKGalleryId]) REFERENCES [gs_Gallery]([GalleryId]) ON DELETE CASCADE;
GO
ALTER TABLE [gs_MimeTypeGallery] ADD CONSTRAINT [FK_gs_MimeTypeGallery_gs_MimeType] FOREIGN KEY ([FKMimeTypeId]) REFERENCES [gs_MimeType]([MimeTypeId]) ON DELETE CASCADE;
GO
ALTER TABLE [gs_Role_Album] ADD CONSTRAINT [FK_gs_Role_Album_gs_Album] FOREIGN KEY ([FKAlbumId]) REFERENCES [gs_Album]([AlbumId]) ON DELETE CASCADE;
GO
ALTER TABLE [gs_Role_Album] ADD CONSTRAINT [FK_gs_Role_Album_gs_Role] FOREIGN KEY ([FKRoleName]) REFERENCES [gs_Role]([RoleName]) ON DELETE CASCADE;
GO
ALTER TABLE [gs_Synchronize] ADD CONSTRAINT [FK_gs_Synchronize_gs_Gallery] FOREIGN KEY ([FKGalleryId]) REFERENCES [gs_Gallery]([GalleryId]) ON DELETE CASCADE;
GO
ALTER TABLE [gs_UserGalleryProfile] ADD CONSTRAINT [FK_gs_UserGalleryProfile_gs_Gallery] FOREIGN KEY ([FKGalleryId]) REFERENCES [gs_Gallery]([GalleryId]) ON DELETE CASCADE;
GO

/* Insert data */

/* Table template gallery record; Will be inserted with GalleryId -2147483648 */
INSERT INTO [gs_Gallery] ([Description], [DateAdded]) VALUES ('Template Gallery', GETDATE());
GO
/* Alter table so that the next record will have a gallery ID = 1 */
ALTER TABLE [gs_Gallery] ALTER COLUMN [GalleryId] IDENTITY (1, 1);
GO

/* Table gs_AppSetting */
INSERT INTO [gs_AppSetting] ([SettingName], [SettingValue]) VALUES ('MediaObjectDownloadBufferSize','32768');
GO
INSERT INTO [gs_AppSetting] ([SettingName], [SettingValue]) VALUES ('EncryptMediaObjectUrlOnClient','False');
GO
INSERT INTO [gs_AppSetting] ([SettingName], [SettingValue]) VALUES ('EncryptionKey','mNU-h7:5f_)3=c%@^}#U9Tn*');
GO
INSERT INTO [gs_AppSetting] ([SettingName], [SettingValue]) VALUES ('JQueryScriptPath','//ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js');
GO
INSERT INTO [gs_AppSetting] ([SettingName], [SettingValue]) VALUES ('JQueryUiScriptPath','//ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js');
GO
INSERT INTO [gs_AppSetting] ([SettingName], [SettingValue]) VALUES ('MembershipProviderName','');
GO
INSERT INTO [gs_AppSetting] ([SettingName], [SettingValue]) VALUES ('RoleProviderName','');
GO
INSERT INTO [gs_AppSetting] ([SettingName], [SettingValue]) VALUES ('ProductKey','');
GO
INSERT INTO [gs_AppSetting] ([SettingName], [SettingValue]) VALUES ('EnableCache','True');
GO
INSERT INTO [gs_AppSetting] ([SettingName], [SettingValue]) VALUES ('AllowGalleryAdminToManageUsersAndRoles','True');
GO
INSERT INTO [gs_AppSetting] ([SettingName], [SettingValue]) VALUES ('AllowGalleryAdminToViewAllUsersAndRoles','True');
GO
INSERT INTO [gs_AppSetting] ([SettingName], [SettingValue]) VALUES ('MaxNumberErrorItems','200');
GO
INSERT INTO [gs_AppSetting] ([SettingName], [SettingValue]) VALUES ('DataSchemaVersion','2.5.0');
GO

/* Table gs_GallerySetting */
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'MediaObjectPath','gs\mediaobjects');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ThumbnailPath','');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'OptimizedPath','');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'MediaObjectPathIsReadOnly','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ShowHeader','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'GalleryTitle','Media Gallery');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'GalleryTitleUrl','~/');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ShowLogin','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ShowSearch','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ShowErrorDetails','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EnableExceptionHandler','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'DefaultAlbumDirectoryNameLength','25');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'SynchAlbumTitleAndDirectoryName','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EmptyAlbumThumbnailBackgroundColor','#369');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EmptyAlbumThumbnailText','Empty');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EmptyAlbumThumbnailFontName','Verdana');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EmptyAlbumThumbnailFontSize','13');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EmptyAlbumThumbnailFontColor','White');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EmptyAlbumThumbnailWidthToHeightRatio','1.33');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'MaxAlbumThumbnailTitleDisplayLength','20');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'MaxMediaObjectThumbnailTitleDisplayLength','16');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'MediaObjectCaptionTemplate','{Title}');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AllowUserEnteredHtml','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AllowUserEnteredJavascript','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AllowedHtmlTags','p,a,div,span,br,ul,ol,li,table,tr,td,th,h1,h2,h3,h4,h5,h6,strong,b,em,i,u,cite,blockquote,address,pre,hr,img,dl,dt,dd,code,tt');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AllowedHtmlAttributes','href,class,style,id,src,title,alt,target,name');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AllowCopyingReadOnlyObjects','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AllowManageOwnAccount','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AllowDeleteOwnAccount','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'MediaObjectTransitionType','Fade');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'MediaObjectTransitionDuration','0.2');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'SlideshowInterval','4000');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AllowUnspecifiedMimeTypes','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ImageTypesStandardBrowsersCanDisplay','.jpg,.jpeg,.gif,.png');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'SilverlightFileTypes','.mp3,.wma,.wmv,.asf,.asx,.m4a');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ImageMagickFileTypes','.pdf,.txt,.eps,.psd,.tif,.tiff');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AllowAnonymousHiResViewing','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EnableMetadata','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ExtractMetadata','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ExtractMetadataUsingWpf','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'MetadataDisplaySettings','29:T,34:T,35:F,8:T,102:T,106:T,22:T,14:T,9:T,5:T,28:T,2:T,26:T,4:T,6:T,7:T,12:T,13:T,15:T,16:T,17:T,18:T,21:T,23:T,24:T,10:T,25:T,27:T,11:T,1:T,32:T,3:T,0:T,31:T,20:T,30:T,33:T,19:T,36:T,37:F,38:T,39:F,40:T,101:F,103:F,104:F,105:F,108:F,107:F,110:T,109:T,1012:T,1013:T,1010:T,1011:T,1014:T,1017:T,1018:T,1015:T,1016:T,1003:T,1004:T,1001:T,1002:T,1005:T,1008:T,1009:T,1006:T,1007:T');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'GpsMapUrlTemplate','<a href=''http://bing.com/maps/default.aspx?sp=point.{GpsLatitude}_{GpsLongitude}_{TitleNoHtml}__{MediaObjectPageUrl}_{MediaObjectUrl}&style=a&lvl=15'' target=''_blank'' title=''View map''>{GpsLocation}</a>');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EnableMediaObjectDownload','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EnableGalleryObjectZipDownload','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EnableAlbumZipDownload','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EnablePermalink','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EnableSlideShow','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'MaxThumbnailLength','115');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ThumbnailImageJpegQuality','70');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ThumbnailClickShowsOriginal','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ThumbnailWidthBuffer','30');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ThumbnailHeightBuffer','70');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ThumbnailFileNamePrefix','zThumb_');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'MaxOptimizedLength','640');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'OptimizedImageJpegQuality','70');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'OptimizedImageTriggerSizeKb','50');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'OptimizedFileNamePrefix','zOpt_');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'OriginalImageJpegQuality','95');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'DiscardOriginalImageDuringImport','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ApplyWatermark','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'ApplyWatermarkToThumbnails','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'WatermarkText','Copyright 2010, Your Company Name, All Rights Reserved');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'WatermarkTextFontName','Verdana');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'WatermarkTextFontSize','13');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'WatermarkTextWidthPercent','50');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'WatermarkTextColor','White');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'WatermarkTextOpacityPercent','35');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'WatermarkTextLocation','BottomCenter');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'WatermarkImagePath','gs/images/gsplogo.png');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'WatermarkImageWidthPercent','85');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'WatermarkImageOpacityPercent','25');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'WatermarkImageLocation','MiddleCenter');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'SendEmailOnError','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EmailFromName','Gallery Server Pro');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EmailFromAddress','webmaster@yourisp.com');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'SmtpServer','');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'SmtpServerPort','');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'SendEmailUsingSsl','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AutoStartMediaObject','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'DefaultVideoPlayerWidth','640');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'DefaultVideoPlayerHeight','480');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'DefaultAudioPlayerWidth','600');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'DefaultAudioPlayerHeight','60');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'DefaultGenericObjectWidth','640');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'DefaultGenericObjectHeight','480');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'MaxUploadSize','2097151');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AllowAddLocalContent','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AllowAddExternalContent','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AllowAnonymousBrowsing','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'PageSize','0');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'PagerLocation','TopAndBottom');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EnableSelfRegistration','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'RequireEmailValidationForSelfRegisteredUser','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'RequireApprovalForSelfRegisteredUser','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'UseEmailForAccountName','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'DefaultRolesForSelfRegisteredUser','');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'UsersToNotifyWhenAccountIsCreated','');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'UsersToNotifyWhenErrorOccurs','');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EnableUserAlbum','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EnableUserAlbumDefaultForUser','True');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'UserAlbumParentAlbumId','0');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'UserAlbumNameTemplate','{UserName}''s gallery');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'UserAlbumSummaryTemplate','Welcome to your personal gallery. You can easily add photos, video, and other files. When you are logged in, an Actions menu appears in the upper left to help you manage your gallery.');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'RedirectToUserAlbumAfterLogin','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'VideoThumbnailPosition','3');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EnableAutoSync','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'AutoSyncIntervalMinutes','1440');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'LastAutoSync','');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'EnableRemoteSync','False');
GO
INSERT INTO [gs_GallerySetting] ([FKGalleryId], [IsTemplate], [SettingName], [SettingValue]) VALUES (-2147483648,1,'RemoteAccessPassword','');
GO

/* Table gs_MimeType */
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.afl','video/animaflex','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.aif','audio/aiff','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.aifc','audio/aiff','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.aiff','audio/aiff','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.asf','video/x-ms-asf','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.asx','video/x-ms-asf','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.au','audio/basic','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.avi','video/x-ms-wvx','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.avs','video/avs-video','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.bm','image/bmp','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.bmp','image/bmp','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.chm','application/vnd.ms-htmlhelp','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.css','text/css','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.divx','video/divx','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.dl','video/dl','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.doc','application/msword','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.docm','application/vnd.ms-word.document.macroEnabled.12','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.docx','application/vnd.openxmlformats-officedocument.wordprocessingml.document','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.dotx','application/vnd.openxmlformats-officedocument.wordprocessingml.template','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.dot','application/msword','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.dotm','application/vnd.ms-word.template.macroEnabled.12','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.dtd','application/xml-dtd','text/plain');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.dwg','image/vnd.dwg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.dxf','image/vnd.dwg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.emf','image/x-emf','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.eps','image/postscript','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.exe','application/octet-stream','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.f4v','video/f4v','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.fif','image/fif','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.fli','video/fli','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.flo','image/florian','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.flv','video/x-flv','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.fpx','image/vnd.fpx','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.funk','audio/make','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.g3','image/g3fax','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.gif','image/gif','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.gl','video/gl','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.htm','text/html','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.html','text/html','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.ico','image/ico','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.ief','image/ief','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.iefs','image/ief','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.it','audio/it','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.jar','application/java-archive','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.jfif','image/jpeg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.jfif-tbnl','image/jpeg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.jpe','image/jpeg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.jpeg','image/jpeg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.jpg','image/jpeg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.js','text/javascript','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.jut','image/jutvision','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.kar','audio/midi','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.la','audio/nspaudio','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.lma','audio/nspaudio','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.m1v','video/mpeg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.m2a','audio/mpeg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.m2v','video/mpeg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.m4a','audio/m4a','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.m4v','video/m4v','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.mcf','image/vasa','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.mht','message/rfc822','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.mid','audio/midi','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.midi','audio/midi','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.mod','audio/mod','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.moov','video/quicktime','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.mov','video/mp4','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.mp2','audio/mpeg','application/x-mplayer2');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.mp3','audio/x-mp3','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.mp4','video/mp4','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.mpa','audio/mpeg','application/x-mplayer2');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.mpe','video/mpeg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.mpeg','video/mpeg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.mpg','video/mpeg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.mpga','audio/mpeg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.my','audio/make','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.nap','image/naplps','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.naplps','image/naplps','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.oga','audio/ogg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.ogg','video/ogg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.ogv','video/ogg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.pdf','application/pdf','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.pfunk','audio/make','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.pic','image/pict','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.pict','image/pict','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.png','image/png','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.potm','application/vnd.ms-powerpoint.template.macroEnabled.12','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.potx','application/vnd.openxmlformats-officedocument.presentationml.template','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.ppam','application/vnd.ms-powerpoint.addin.macroEnabled.12','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.pps','application/vnd.ms-powerpoint','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.ppsm','application/vnd.ms-powerpoint.slideshow.macroEnabled.12','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.ppsx','application/vnd.openxmlformats-officedocument.presentationml.slideshow','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.ppt','application/vnd.ms-powerpoint','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.pptm','application/vnd.ms-powerpoint.presentation.macroEnabled.12','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.pptx','application/vnd.openxmlformats-officedocument.presentationml.presentation','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.psd','image/psd','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.qcp','audio/vnd.qcelp','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.qt','video/quicktime','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.ra','audio/x-pn-realaudio','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.ram','audio/x-pn-realaudio','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.ras','image/cmu-raster','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.rast','image/cmu-raster','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.rf','image/vnd.rn-realflash','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.rmi','audio/mid','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.rp','image/vnd.rn-realpix','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.rtf','application/rtf','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.rv','video/vnd.rn-realvideo','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.sgml','text/sgml','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.s3m','audio/s3m','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.snd','audio/basic','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.svf','image/vnd.dwg','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.svg','image/svg+xml','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.swf','application/x-shockwave-flash','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.tif','image/tiff','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.tiff','image/tiff','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.tsi','audio/tsp-audio','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.tsp','audio/tsplayer','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.turbot','image/florian','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.txt','text/plain','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.vdo','video/vdo','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.viv','video/vivo','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.vivo','video/vivo','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.voc','audio/voc','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.vos','video/vosaic','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.vox','audio/voxware','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.wax','audio/x-ms-wax','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.wav','audio/wav','application/x-mplayer2');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.wbmp','image/vnd.wap.wbmp','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.webm','video/webm','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.wmf','image/wmf','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.wma','audio/x-ms-wma','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.wmv','video/x-ms-wmv','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.wvx','video/x-ms-wvx','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.xbap','application/x-ms-xbap','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.xaml','application/xaml+xml','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.xlam','application/vnd.ms-excel.addin.macroEnabled.12','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.xls','application/vnd.ms-excel','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.xlsb','application/vnd.ms-excel.sheet.binary.macroEnabled.12','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.xlsm','application/vnd.ms-excel.sheet.macroEnabled.12','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.xltm','application/vnd.ms-excel.template.macroEnabled.12','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.xltx','application/vnd.openxmlformats-officedocument.spreadsheetml.template','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.xif','image/vnd.xiff','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.xml','text/xml','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.xps','application/vnd.ms-xpsdocument','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.x-png','image/png','');
GO
INSERT INTO [gs_MimeType] ([FileExtension], [MimeTypeValue], [BrowserMimeTypeValue]) VALUES ('.zip','application/octet-stream','');
GO

/* Table gs_BrowserTemplate */
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('image/*','default','<div class="gsp_i_c" style="width:{Width}px;"><img id="mo_img" src="{MediaObjectUrl}" class="{CssClass}" alt="{TitleNoHtml}" title="{TitleNoHtml}" style="height:{Height}px;width:{Width}px;" /></div>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('image/*','ie1to8','<div class="gsp_floatcontainer"><div class="op1"><div class="op2"><div class="sb"><div class="ib"><img id="mo_img" src="{MediaObjectUrl}" class="{CssClass}" alt="{TitleNoHtml}" title="{TitleNoHtml}" style="height:{Height}px;width:{Width}px;" /></div></div></div></div></div>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('audio/*','default','<object type="{MimeType}" data="{MediaObjectUrl}" style="width:{Width}px;height:{Height}px;" ><param name="autostart" value="{AutoStartMediaObjectInt}" /><param name="controller" value="true" /></object>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('audio/*','ie','<object classid="clsid:6BF52A52-394A-11D3-B153-00C04F79FAA6" standby="Loading audio..." style="width:{Width}px;height:{Height}px;"><param name="url" value="{MediaObjectUrl}" /><param name="src" value="{MediaObjectUrl}" /><param name="autostart" value="{AutoStartMediaObjectText}" /><param name="showcontrols" value="true" /></object>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('audio/m4a','default','<div id=''mp1p''></div>','if (_pageLoadHasFired) gsp_runSilverlight(); else Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(gsp_runSilverlight); function gsp_runSilverlight() { Sys.UI.Silverlight.Control.createObject(''mp1p'', ''<object type="application/x-silverlight" id="mp1" style="height:{Height}px;width:{Width}px;"><param name="Windowless" value="True" /><a href="http://go2.microsoft.com/fwlink/?LinkID=114576&amp;v=1.0"><img src="http://go2.microsoft.com/fwlink/?LinkID=108181" alt="Get Microsoft Silverlight" style="border-width:0;" /></a></object>''); Sys.Application.add_init(function() { $create(Sys.UI.Silverlight.MediaPlayer, { "mediaSource": "{MediaObjectUrl}", "scaleMode": 1, "source": "{GalleryPath}/skins/mediaplayer/AudioGray.xaml","autoPlay":{AutoStartMediaObjectText} }, null, null, $get("mp1p")); }); Sys.Application.initialize();Array.add(_mediaObjectsToDispose, "mp1");}');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('audio/ogg','default','<audio src="{MediaObjectUrl}" controls autobuffer {AutoPlay}><p>Cannot play: Your browser does not support the <code>audio</code> element or the codec of this file. Use another browser or download the file by clicking the download toolbar button above (available only when downloading is enabled).</p></audio>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('audio/ogg','ie','<p>Cannot play: Internet Explorer cannot play Ogg Theora files. Use another browser or download the file by clicking the download toolbar button above (available only when downloading is enabled).</p>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('audio/wav','default','<audio src="{MediaObjectUrl}" controls autobuffer {AutoPlay}><p>Cannot play: Your browser does not support the <code>audio</code> element or the codec of this file. Use another browser or download the file by clicking the download toolbar button above (available only when downloading is enabled).</p></audio>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('audio/wav','ie','<object classid="clsid:6BF52A52-394A-11D3-B153-00C04F79FAA6" standby="Loading audio..." style="width:{Width}px;height:{Height}px;"><param name="url" value="{MediaObjectUrl}" /><param name="src" value="{MediaObjectUrl}" /><param name="autostart" value="{AutoStartMediaObjectText}" /><param name="showcontrols" value="true" /></object>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('audio/x-mp3','default','<div id=''mp1p''></div>','if (_pageLoadHasFired) gsp_runSilverlight(); else Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(gsp_runSilverlight); function gsp_runSilverlight() { Sys.UI.Silverlight.Control.createObject(''mp1p'', ''<object type="application/x-silverlight" id="mp1" style="height:{Height}px;width:{Width}px;"><param name="Windowless" value="True" /><a href="http://go2.microsoft.com/fwlink/?LinkID=114576&amp;v=1.0"><img src="http://go2.microsoft.com/fwlink/?LinkID=108181" alt="Get Microsoft Silverlight" style="border-width:0;" /></a></object>''); Sys.Application.add_init(function() { $create(Sys.UI.Silverlight.MediaPlayer, { "mediaSource": "{MediaObjectUrl}", "scaleMode": 1, "source": "{GalleryPath}/skins/mediaplayer/AudioGray.xaml","autoPlay":{AutoStartMediaObjectText} }, null, null, $get("mp1p")); }); Sys.Application.initialize();Array.add(_mediaObjectsToDispose, "mp1");}');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('audio/x-ms-wma','default','<div id=''mp1p''></div>','if (_pageLoadHasFired) gsp_runSilverlight(); else Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(gsp_runSilverlight); function gsp_runSilverlight() { Sys.UI.Silverlight.Control.createObject(''mp1p'', ''<object type="application/x-silverlight" id="mp1" style="height:{Height}px;width:{Width}px;"><param name="Windowless" value="True" /><a href="http://go2.microsoft.com/fwlink/?LinkID=114576&amp;v=1.0"><img src="http://go2.microsoft.com/fwlink/?LinkID=108181" alt="Get Microsoft Silverlight" style="border-width:0;" /></a></object>''); Sys.Application.add_init(function() { $create(Sys.UI.Silverlight.MediaPlayer, { "mediaSource": "{MediaObjectUrl}", "scaleMode": 1, "source": "{GalleryPath}/skins/mediaplayer/AudioGray.xaml","autoPlay":{AutoStartMediaObjectText} }, null, null, $get("mp1p")); }); Sys.Application.initialize();Array.add(_mediaObjectsToDispose, "mp1");}');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/*','default','<object type="{MimeType}" data="{MediaObjectUrl}" style="width:{Width}px;height:{Height}px;" ><param name="src" value="{MediaObjectUrl}" /><param name="autostart" value="{AutoStartMediaObjectInt}" /></object>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/*','ie','<object type="{MimeType}" data="{MediaObjectUrl}" style="width:{Width}px;height:{Height}px;"><param name="src" value="{MediaObjectUrl}" /><param name="autostart" value="{AutoStartMediaObjectText}" /></object>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/ogg','default','<video src="{MediaObjectUrl}" controls autobuffer {AutoPlay}><p>Cannot play: Your browser does not support the <code>video</code> element or the codec of this file. Use another browser or download the file by clicking the download toolbar button above (available only when downloading is enabled).</p></video>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/ogg','ie','<p>Cannot play: Internet Explorer cannot play Ogg Theora files. Use another browser or download the file by clicking the download toolbar button above (available only when downloading is enabled).</p>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/x-ms-wmv','default','<div id=''mp1p''></div>','if (_pageLoadHasFired) gsp_runSilverlight(); else Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(gsp_runSilverlight); function gsp_runSilverlight() { Sys.UI.Silverlight.Control.createObject(''mp1p'', ''<object type="application/x-silverlight" id="mp1" style="height:{Height}px;width:{Width}px;"><param name="Windowless" value="True" /><a href="http://go2.microsoft.com/fwlink/?LinkID=114576&amp;v=1.0"><img src="http://go2.microsoft.com/fwlink/?LinkID=108181" alt="Get Microsoft Silverlight" style="border-width:0;" /></a></object>''); Sys.Application.add_init(function() { $create(Sys.UI.Silverlight.MediaPlayer, { "mediaSource": "{MediaObjectUrl}", "scaleMode": 1, "source": "{GalleryPath}/skins/mediaplayer/Professional.xaml","autoPlay":{AutoStartMediaObjectText} }, null, null, $get("mp1p")); }); Sys.Application.initialize();Array.add(_mediaObjectsToDispose, "mp1");}');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/mp4','default','<script type="text/javascript" src="{GalleryPath}/script/flowplayer-3.2.4.min.js"></script><a href="{MediaObjectUrl}" style="display:block;width:{Width}px;height:{Height}px" id="gsp_player"></a>','$get("gsp_player").href=$get("gsp_player").href.replace(/&/g, "%26");flowplayer("gsp_player", { src: "{GalleryPath}/script/flowplayer-3.2.5.swf", wmode: "opaque" }, { clip:{ autoPlay: {AutoStartMediaObjectText}, scaling: "fit" } });');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/m4v','default','<script type="text/javascript" src="{GalleryPath}/script/flowplayer-3.2.4.min.js"></script><a href="{MediaObjectUrl}" style="display:block;width:{Width}px;height:{Height}px" id="gsp_player"></a>','$get("gsp_player").href=$get("gsp_player").href.replace(/&/g, "%26");flowplayer("gsp_player", { src: "{GalleryPath}/script/flowplayer-3.2.5.swf", wmode: "opaque" }, { clip:{ autoPlay: {AutoStartMediaObjectText}, scaling: "fit" } });');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/x-ms-asf','default','<div id=''mp1p''></div>','if (_pageLoadHasFired) gsp_runSilverlight(); else Sys.WebForms.PageRequestManager.getInstance().add_pageLoaded(gsp_runSilverlight); function gsp_runSilverlight() { Sys.UI.Silverlight.Control.createObject(''mp1p'', ''<object type="application/x-silverlight" id="mp1" style="height:{Height}px;width:{Width}px;"><param name="Windowless" value="True" /><a href="http://go2.microsoft.com/fwlink/?LinkID=114576&amp;v=1.0"><img src="http://go2.microsoft.com/fwlink/?LinkID=108181" alt="Get Microsoft Silverlight" style="border-width:0;" /></a></object>''); Sys.Application.add_init(function() { $create(Sys.UI.Silverlight.MediaPlayer, { "mediaSource": "{MediaObjectUrl}", "scaleMode": 1, "source": "{GalleryPath}/skins/mediaplayer/Professional.xaml","autoPlay":{AutoStartMediaObjectText} }, null, null, $get("mp1p")); }); Sys.Application.initialize();Array.add(_mediaObjectsToDispose, "mp1");}');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/quicktime','default','<object type="{MimeType}" data="{MediaObjectUrl}" style="width:{Width}px;height:{Height}px;"><param name="autoplay" value="{AutoStartMediaObjectText}" /><param name="controller" value="true" /><param name="pluginurl" value="http://www.apple.com/quicktime/download/" /></object>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/quicktime','ie','<object classid="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" codebase="http://www.apple.com/qtactivex/qtplugin.cab" style="width:{Width}px;height:{Height}px;"><param name="src" value="{MediaObjectUrl}" /><param name="autoplay" value="{AutoStartMediaObjectText}" /><param name="controller" value="true" /><param name="pluginspage" value="http://www.apple.com/quicktime/download/" /></object>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/divx','default','<object type="{MimeType}" data="{HostUrl}{MediaObjectUrl}" style="width:{Width}px;height:{Height}px;"><param name="src" value="{HostUrl}{MediaObjectUrl}" /><param name="mode" value="full" /><param name="minVersion" value="1.0.0" /><param name="allowContextMenu" value="true" /><param name="autoPlay" value="{AutoStartMediaObjectText}" /><param name="loop" value="false" /><param name="bannerEnabled" value="false" /><param name="bufferingMode" value="auto" /><param name="previewMessage" value="Click to start video" /><param name="previewMessageFontSize" value="24" /><param name="movieTitle" value="{TitleNoHtml}" /></object>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/divx','ie','<object classid="clsid:67DABFBF-D0AB-41fa-9C46-CC0F21721616" codebase="http://go.divx.com/plugin/DivXBrowserPlugin.cab" style="width:{Width}px;height:{Height}px;"><param name="src" value="{HostUrl}{MediaObjectUrl}" /><param name="mode" value="full" /><param name="minVersion" value="1.0.0" /><param name="allowContextMenu" value="true" /><param name="autoPlay" value="{AutoStartMediaObjectText}" /><param name="loop" value="false" /><param name="bannerEnabled" value="false" /><param name="bufferingMode" value="auto" /><param name="previewMessage" value="Click to start video" /><param name="previewMessageFontSize" value="24" /><param name="movieTitle" value="{TitleNoHtml}" /></object>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/webm','default','<video src="{MediaObjectUrl}" controls autobuffer {AutoPlay}><p>Cannot play: Your browser does not support the <code>video</code> element or the codec of this file. Use another browser or download the file by clicking the download toolbar button above (available only when downloading is enabled).</p></video>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('application/x-shockwave-flash','default','<object type="{MimeType}" data="{MediaObjectUrl}" style="width:{Width}px;height:{Height}px;" id="flash_plugin" standby="loading movie..."><param name="movie" value="{MediaObjectUrl}" /><param name="allowScriptAccess" value="sameDomain" /><param name="quality" value="best" /><param name="wmode" value="opaque" /><param name="scale" value="default" /><param name="bgcolor" value="#FFFFFF" /><param name="salign" value="TL" /><param name="FlashVars" value="playerMode=embedded" /><p><strong>Cannot play Flash content</strong> Your browser does not have the Flash plugin or it is disabled. To view the content, install the Macromedia Flash plugin or, if it is already installed, enable it.</p></object>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('application/x-shockwave-flash','ie','<object type="{MimeType}" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0&quot; id="flash_activex" standby="loading movie..." style="width:{Width}px;height:{Height}px;"><param name="movie" value="{MediaObjectUrl}" /><param name="quality" value="high" /><param name="wmode" value="opaque" /><param name="bgcolor" value="#FFFFFF" /><p><strong>Cannot play Flash content</strong> Your browser does not have the Flash plugin or it is disabled. To view the content, install the Macromedia Flash plugin or, if it is already installed, enable it.</p></object>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('application/x-shockwave-flash','ie5to9mac','<object type="{MimeType}" data="{MediaObjectUrl}" style="width:{Width}px;height:{Height}px;" id="flash_plugin" standby="loading movie..."><param name="movie" value="{MediaObjectUrl}" /><param name="allowScriptAccess" value="sameDomain" /><param name="quality" value="best" /><param name="scale" value="default" /><param name="bgcolor" value="#FFFFFF" /><param name="wmode" value="opaque" /><param name="salign" value="TL" /><param name="FlashVars" value="playerMode=embedded" /><strong>Cannot play Flash content</strong> Your browser does not have the Flash plugin or it is disabled. To view the content, install the Macromedia Flash plugin or, if it is already installed, enable it.</object>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/f4v','default','<script type="text/javascript" src="{GalleryPath}/script/flowplayer-3.2.4.min.js"></script><a href="{MediaObjectUrl}" style="display:block;width:{Width}px;height:{Height}px" id="gsp_player"></a>','$get("gsp_player").href=$get("gsp_player").href.replace(/&/g, "%26");flowplayer("gsp_player", { src: "{GalleryPath}/script/flowplayer-3.2.5.swf", wmode: "opaque" }, { clip:{ autoPlay: {AutoStartMediaObjectText}, scaling: "fit" } });');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('video/x-flv','default','<script type="text/javascript" src="{GalleryPath}/script/flowplayer-3.2.4.min.js"></script><a href="{MediaObjectUrl}" style="display:block;width:{Width}px;height:{Height}px" id="gsp_player"></a>','$get("gsp_player").href=$get("gsp_player").href.replace(/&/g, "%26");flowplayer("gsp_player", { src: "{GalleryPath}/script/flowplayer-3.2.5.swf", wmode: "opaque" }, { clip:{ autoPlay: {AutoStartMediaObjectText}, scaling: "fit" } });');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('application/pdf','default','<p><a href="{MediaObjectUrl}">Enlarge PDF to fit browser window</a></p><iframe src="{MediaObjectUrl}" frameborder="0" style="width:680px;height:600px;border:1px solid #000;"></iframe>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('text/plain','default','<p><a href="{MediaObjectUrl}">Enlarge file to fit browser window</a></p><iframe src="{MediaObjectUrl}" frameborder="0" style="width:680px;height:600px;border:1px solid #000;"></iframe>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('text/html','default','<p><a href="{MediaObjectUrl}">Enlarge file to fit browser window</a></p><iframe src="{MediaObjectUrl}" frameborder="0" style="width:680px;height:600px;border:1px solid #000;"></iframe>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('application/vnd.openxmlformats-officedocument.wordprocessingml.document','default','<p style="margin-bottom:5em;"><a href="{MediaObjectUrl}" title="Download {TitleNoHtml}">Download {TitleNoHtml}</a></p>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('application/msword','default','<p style="margin-bottom:5em;"><a href="{MediaObjectUrl}" title="Download {TitleNoHtml}">Download {TitleNoHtml}</a></p>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('message/rfc822','default','<p class="gsp_msgfriendly">This browser cannot display web archive files (.mht). Use Internet Explorer or download it by clicking the download link in the toolbar.</p>','');
GO
INSERT INTO [gs_BrowserTemplate] ([MimeType], [BrowserId], [HtmlTemplate], [ScriptTemplate]) VALUES ('message/rfc822','ie','<p><a href="{MediaObjectUrl}">Enlarge to fit browser window</a></p><iframe src="{MediaObjectUrl}" frameborder="0" style="width:680px;height:600px;border:1px solid #000;"></iframe>','');
GO
