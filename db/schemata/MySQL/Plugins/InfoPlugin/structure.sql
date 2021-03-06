CREATE TABLE `Info` (
    `Id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
    `AccountId` BIGINT(20) UNSIGNED NOT NULL,
    `InfoTxt` VARCHAR(1024) NULL,
    `CreatedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `LastModifiedAt` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `IsActive` TINYINT(1) NOT NULL DEFAULT 1,
    `IsDeleted` TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`Id`),
    UNIQUE KEY (`AccountId`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
/* Why the funny collation? Unicode emoji. */

ALTER TABLE `Info`
    ADD FOREIGN KEY `FK_nicks_AccountId` (`AccountId`) REFERENCES `Account` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE;
