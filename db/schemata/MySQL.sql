CREATE TABLE `servers` (
    `Id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `Host` VARCHAR(128) NOT NULL,
    `Port` INTEGER(11) NOT NULL DEFAULT 6667,
    `BotNick` VARCHAR(32) NOT NULL,
    `BotNickPassword` VARCHAR(64) NOT NULL,
    `BotUserName` VARCHAR(32) NOT NULL,
    `BotRealName` VARCHAR(128) NOT NULL DEFAULT 'Lumbricus IRC Bot (https://github.com/TwoWholeWorms/lumbricus)',
    `NickServNick` VARCHAR(32) NOT NULL DEFAULT 'NickServ',
    `NickServHost` VARCHAR(128) NOT NULL DEFAULT 'NickServ!NickServ@services.',
    `AutoConnect` TINYINT(1) NOT NULL DEFAULT 1,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    `CreatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `LastModifiedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id`)
) Engine=InnoDB DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
/* Why the funny collation? Unicode emoji. */

CREATE TABLE `channels` (
    `Id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `Server_Id` BIGINT(20) UNSIGNED NOT NULL,
    `Name` VARCHAR(32) NOT NULL,
    `AutoJoin` TINYINT(1) NOT NULL DEFAULT 1,
    `AllowCommandsInChannel` TINYINT(1) NOT NULL DEFAULT 0,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    `CreatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `LastModifiedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id`)
) Engine=InnoDB DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `accounts` (
    `Id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `Server_Id` BIGINT(20) UNSIGNED NOT NULL,
    `Name` VARCHAR(32) NOT NULL,
    `DisplayName` VARCHAR(32) NOT NULL,
    `UserName` VARCHAR(32) NOT NULL,
    `Host` VARCHAR(128) NOT NULL,
    `PrimaryNick_Id` BIGINT(20) UNSIGNED,
    `FirstSeenAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `LastSeenAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `ChannelLastSeenIn_Id` BIGINT(20) UNSIGNED,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    `CreatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `LastModifiedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `IsOp` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`)
) Engine=InnoDB DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `nicks` (
    `Id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `Server_Id` BIGINT(20) UNSIGNED NOT NULL,
    `Name` VARCHAR(32) NOT NULL,
    `DisplayName` VARCHAR(32) NOT NULL,
    `UserName` VARCHAR(32),
    `Host` VARCHAR(128),
    `Account_Id` BIGINT(20) UNSIGNED,
    `FirstSeenAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `LastSeenAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `ChannelLastSeenIn_Id` BIGINT(20) UNSIGNED,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    `CreatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `LastModifiedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id`)
) Engine=InnoDB DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `logs` (
    `Id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `Server_Id` BIGINT(20) UNSIGNED,
    `NickId` BIGINT(20) UNSIGNED,
    `Account_Id` BIGINT(20) UNSIGNED,
    `Channel_Id` BIGINT(20) UNSIGNED,
    `IrcCommand` INTEGER(11) UNSIGNED NOT NULL,
    `Trail` VARCHAR(512),
    `Line` VARCHAR(512) NOT NULL,
    `LoggedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id`)
) Engine=InnoDB DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `bans` (
    `Id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `Mask` VARCHAR(128) NOT NULL,
    `Server_Id` BIGINT(20) UNSIGNED,
    `NickId` BIGINT(20) UNSIGNED,
    `Account_Id` BIGINT(20) UNSIGNED,
    `Channel_Id` BIGINT(20) UNSIGNED,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsMugshotBan` TINYINT(1) NOT NULL DEFAULT 1,
    `CreatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `LastModifiedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `BannerAccount_Id` BIGINT(20) UNSIGNED,
    `BanMessage` VARCHAR(512),
    `UnbannedAt` TIMESTAMP,
    `UnbannerAccount_Id` BIGINT(20) UNSIGNED,
    `UnbanMessage` VARCHAR(512),
    PRIMARY KEY (`Id`)
) Engine=InnoDB DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE TABLE `settings` (
    `Id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `Section` VARCHAR(32) NOT NULL,
    `Name` VARCHAR(32) NOT NULL,
    `Value` VARCHAR(512) NOT NULL,
    `DefaultValue` VARCHAR(512) NOT NULL,
    PRIMARY KEY (`Id`)
) Engine=InnoDB DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

ALTER TABLE `channels`
    ADD FOREIGN KEY `FK_channels_ServerId` (`Server_Id`) REFERENCES `servers` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `accounts`
    ADD FOREIGN KEY `FK_accounts_ServerId` (`Server_Id`) REFERENCES `servers` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY `FK_accounts_PrimaryNickId` (`PrimaryNick_Id`) REFERENCES `nicks` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD FOREIGN KEY `FK_accounts_ChannelLastSeenInId` (`ChannelLastSeenIn_Id`) REFERENCES `channels` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `nicks`
    ADD FOREIGN KEY `FK_nicks_ServerId` (`Server_Id`) REFERENCES `servers` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY `FK_nicks_AccountId` (`Account_Id`) REFERENCES `accounts` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY `FK_nicks_ChannelLastSeenInId` (`ChannelLastSeenIn_Id`) REFERENCES `channels` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `logs`
    ADD FOREIGN KEY `FK_logs_ServerId` (`Server_Id`) REFERENCES `servers` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD FOREIGN KEY `FK_logs_ChannelId` (`Channel_Id`) REFERENCES `channels` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD FOREIGN KEY `FK_logs_AccountId` (`Account_Id`) REFERENCES `accounts` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD FOREIGN KEY `FK_logs_NickId` (`NickId`) REFERENCES `nicks` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE `bans`
    ADD FOREIGN KEY `FK_logs_ServerId` (`Server_Id`) REFERENCES `servers` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY `FK_logs_ChannelId` (`Channel_Id`) REFERENCES `channels` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY `FK_logs_AccountId` (`Account_Id`) REFERENCES `accounts` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD FOREIGN KEY `FK_logs_NickId` (`NickId`) REFERENCES `nicks` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD FOREIGN KEY `FK_logs_BannerAccountId` (`BannerAccount_Id`) REFERENCES `accounts` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE,
    ADD FOREIGN KEY `FK_logs_UnbannerAccountId` (`UnbannerAccount_Id`) REFERENCES `accounts` (`Id`) ON DELETE SET NULL ON UPDATE CASCADE;