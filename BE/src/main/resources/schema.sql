-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema side_dish
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema side_dish
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `baseball` DEFAULT CHARACTER SET utf8;
USE `baseball`;

-- -----------------------------------------------------
-- Table `side_dish`.`user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `baseball`.`user`;
CREATE TABLE IF NOT EXISTS `baseball`.`user` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(45),
    `email` VARCHAR(45) NOT NULL,
    `user_id` VARCHAR(45) NOT NULL,
    `token` VARCHAR(255),
    PRIMARY KEY (`id`))
    ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
