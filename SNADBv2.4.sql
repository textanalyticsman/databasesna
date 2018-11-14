-- MySQL Script generated by MySQL Workbench
-- 11/14/18 23:51:12
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema snadb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema snadb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `snadb` DEFAULT CHARACTER SET utf8 ;
USE `snadb` ;

-- -----------------------------------------------------
-- Table `snadb`.`CORPUS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `snadb`.`CORPUS` (
  `CORPID` INT NOT NULL AUTO_INCREMENT COMMENT 'Example CORP0001',
  `CORPDESC` VARCHAR(600) NULL COMMENT 'Example: Corpus related to the case XYZ',
  PRIMARY KEY (`CORPID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `snadb`.`DOCUMENT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `snadb`.`DOCUMENT` (
  `DOCID` INT NOT NULL AUTO_INCREMENT COMMENT 'Example: DOC0001',
  `TITLE` TEXT NULL,
  `CONTENT` MEDIUMTEXT NULL,
  `DATE` VARCHAR(100) NULL,
  `CORPID` INT NOT NULL,
  PRIMARY KEY (`DOCID`),
  INDEX `fk_DOCUMENT_CORPUS1_idx` (`CORPID` ASC),
  CONSTRAINT `fk_DOCUMENT_CORPUS1`
    FOREIGN KEY (`CORPID`)
    REFERENCES `snadb`.`CORPUS` (`CORPID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `snadb`.`Paragraph`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `snadb`.`Paragraph` (
  `PARAGRAPHID` INT NOT NULL AUTO_INCREMENT,
  `PARAGRAPHORDER` INT NULL,
  `DOCID` INT NOT NULL,
  `PARAGRAPHCONTENT` MEDIUMTEXT NULL,
  PRIMARY KEY (`PARAGRAPHID`),
  INDEX `fk_Paragraph_DOCUMENT1_idx` (`DOCID` ASC),
  CONSTRAINT `fk_Paragraph_DOCUMENT1`
    FOREIGN KEY (`DOCID`)
    REFERENCES `snadb`.`DOCUMENT` (`DOCID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `snadb`.`SENTENCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `snadb`.`SENTENCE` (
  `SENTENCEID` INT NOT NULL AUTO_INCREMENT COMMENT 'Example: SENT000001',
  `SENTENCEORDER` INT(11) NULL COMMENT 'For example 1, which means the position of that sentence within the document',
  `SENTENCECONTENT` MEDIUMTEXT NULL,
  `PARAGRAPHID` INT NOT NULL,
  PRIMARY KEY (`SENTENCEID`),
  INDEX `fk_SENTENCE_Paragraph1_idx` (`PARAGRAPHID` ASC),
  CONSTRAINT `fk_SENTENCE_Paragraph1`
    FOREIGN KEY (`PARAGRAPHID`)
    REFERENCES `snadb`.`Paragraph` (`PARAGRAPHID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `snadb`.`ENTITYRAW`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `snadb`.`ENTITYRAW` (
  `ENTITYID` INT NOT NULL AUTO_INCREMENT COMMENT 'Example: ENT000001',
  `ENTITYNAME` VARCHAR(600) NULL COMMENT 'Example: Raúl Castillo Castillo',
  `ENTITYTYPE` CHAR(3) NULL COMMENT 'Example: ORG, PER, LOC, OTH',
  `SENTENCEID` INT NULL,
  PRIMARY KEY (`ENTITYID`),
  INDEX `fk_ENTITY_SENTENCE1_idx` (`SENTENCEID` ASC),
  CONSTRAINT `fk_ENTITY_SENTENCE1`
    FOREIGN KEY (`SENTENCEID`)
    REFERENCES `snadb`.`SENTENCE` (`SENTENCEID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `snadb`.`CLUSTER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `snadb`.`CLUSTER` (
  `CLUSTERID` INT NOT NULL AUTO_INCREMENT,
  `CLUSTERSIZE` INT NULL,
  `EPS` DOUBLE NULL,
  `MINPTS` INT NULL,
  `CORPID` INT NOT NULL,
  `LABEL` INT NULL,
  PRIMARY KEY (`CLUSTERID`),
  INDEX `fk_CLUSTER_CORPUS1_idx` (`CORPID` ASC),
  CONSTRAINT `fk_CLUSTER_CORPUS1`
    FOREIGN KEY (`CORPID`)
    REFERENCES `snadb`.`CORPUS` (`CORPID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `snadb`.`ENTITYNORMALIZED`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `snadb`.`ENTITYNORMALIZED` (
  `ENTITYNORMID` INT NOT NULL AUTO_INCREMENT,
  `ENTITYNORMNAME` VARCHAR(600) NULL,
  `ENTITYNORMTYPE` CHAR(3) NULL,
  `ENTITYNORMROLE` VARCHAR(45) NULL,
  `CLUSTERID` INT NOT NULL,
  PRIMARY KEY (`ENTITYNORMID`),
  INDEX `fk_ENTITYNORMALIZED_CLUSTER1_idx` (`CLUSTERID` ASC),
  CONSTRAINT `fk_ENTITYNORMALIZED_CLUSTER1`
    FOREIGN KEY (`CLUSTERID`)
    REFERENCES `snadb`.`CLUSTER` (`CLUSTERID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `snadb`.`EDGELIST`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `snadb`.`EDGELIST` (
  `ENTITYNORMID01` INT NOT NULL,
  `ENTITYNORMNAME01` VARCHAR(600) NULL,
  `ENTITYNORMNAME02` VARCHAR(600) NULL,
  `ENTITYNORMID02` INT NOT NULL,
  `CORPUS_CORPID` INT NOT NULL,
  `WEIGHT` INT NULL,
  `SENTENCES` MEDIUMTEXT NULL,
  PRIMARY KEY (`ENTITYNORMID01`, `ENTITYNORMID02`),
  INDEX `fk_ENTITYNORMALIZED_has_ENTITYNORMALIZED_ENTITYNORMALIZED2_idx` (`ENTITYNORMID02` ASC),
  INDEX `fk_ENTITYNORMALIZED_has_ENTITYNORMALIZED_ENTITYNORMALIZED1_idx` (`ENTITYNORMID01` ASC),
  INDEX `fk_ENTITYNORMALIZED_has_ENTITYNORMALIZED_CORPUS1_idx` (`CORPUS_CORPID` ASC),
  CONSTRAINT `fk_ENTITYNORMALIZED_has_ENTITYNORMALIZED_ENTITYNORMALIZED1`
    FOREIGN KEY (`ENTITYNORMID01`)
    REFERENCES `snadb`.`ENTITYNORMALIZED` (`ENTITYNORMID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ENTITYNORMALIZED_has_ENTITYNORMALIZED_ENTITYNORMALIZED2`
    FOREIGN KEY (`ENTITYNORMID02`)
    REFERENCES `snadb`.`ENTITYNORMALIZED` (`ENTITYNORMID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ENTITYNORMALIZED_has_ENTITYNORMALIZED_CORPUS1`
    FOREIGN KEY (`CORPUS_CORPID`)
    REFERENCES `snadb`.`CORPUS` (`CORPID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `snadb`.`SENTENCEENTITYNORMALIZED`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `snadb`.`SENTENCEENTITYNORMALIZED` (
  `SPARE` VARCHAR(45) NULL,
  `ENTITYNORMID` INT NOT NULL,
  `SENTENCEID` INT NOT NULL,
  INDEX `fk_SENTENCEENTITYNORMALIZED_ENTITYNORMALIZED1_idx` (`ENTITYNORMID` ASC),
  INDEX `fk_SENTENCEENTITYNORMALIZED_SENTENCE1_idx` (`SENTENCEID` ASC),
  PRIMARY KEY (`ENTITYNORMID`, `SENTENCEID`),
  CONSTRAINT `fk_SENTENCEENTITYNORMALIZED_ENTITYNORMALIZED1`
    FOREIGN KEY (`ENTITYNORMID`)
    REFERENCES `snadb`.`ENTITYNORMALIZED` (`ENTITYNORMID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_SENTENCEENTITYNORMALIZED_SENTENCE1`
    FOREIGN KEY (`SENTENCEID`)
    REFERENCES `snadb`.`SENTENCE` (`SENTENCEID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `snadb`.`JACCARDDISTANCE`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `snadb`.`JACCARDDISTANCE` (
  `ENTITYID01` INT NOT NULL,
  `ENTITYID02` INT NOT NULL,
  `ENTITYNAME01` VARCHAR(600) NULL,
  `ENTITYNAME02` VARCHAR(600) NULL,
  `JACCARDDISTANCE` FLOAT NULL,
  PRIMARY KEY (`ENTITYID01`, `ENTITYID02`),
  INDEX `fk_ENTITYRAW_has_ENTITYRAW_ENTITYRAW2_idx` (`ENTITYID02` ASC),
  INDEX `fk_ENTITYRAW_has_ENTITYRAW_ENTITYRAW1_idx` (`ENTITYID01` ASC),
  CONSTRAINT `fk_ENTITYRAW_has_ENTITYRAW_ENTITYRAW1`
    FOREIGN KEY (`ENTITYID01`)
    REFERENCES `snadb`.`ENTITYRAW` (`ENTITYID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ENTITYRAW_has_ENTITYRAW_ENTITYRAW2`
    FOREIGN KEY (`ENTITYID02`)
    REFERENCES `snadb`.`ENTITYRAW` (`ENTITYID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `snadb`.`OCTOPARSEIMPORT`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `snadb`.`OCTOPARSEIMPORT` (
  `DATE` VARCHAR(100) NULL,
  `TITLE` TEXT NULL,
  `SUMMARY` MEDIUMTEXT NULL,
  `CONTENT` MEDIUMTEXT NULL,
  `ID` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `snadb`.`ENTITYRAWCLUSTER`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `snadb`.`ENTITYRAWCLUSTER` (
  `CLUSTERID` INT NOT NULL,
  `ENTITYID` INT NOT NULL,
  `SPARE` VARCHAR(45) NULL,
  PRIMARY KEY (`CLUSTERID`, `ENTITYID`),
  INDEX `fk_ENTITYRAWCLUSTER_CLUSTER1_idx` (`CLUSTERID` ASC),
  INDEX `fk_ENTITYRAWCLUSTER_ENTITYRAW1_idx` (`ENTITYID` ASC),
  CONSTRAINT `fk_ENTITYRAWCLUSTER_CLUSTER1`
    FOREIGN KEY (`CLUSTERID`)
    REFERENCES `snadb`.`CLUSTER` (`CLUSTERID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ENTITYRAWCLUSTER_ENTITYRAW1`
    FOREIGN KEY (`ENTITYID`)
    REFERENCES `snadb`.`ENTITYRAW` (`ENTITYID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
