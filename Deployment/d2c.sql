-- MySQL Script generated by MySQL Workbench
-- Tue 29 Mar 2016 11:17:24 PM NDT
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema d2c
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `d2c` ;

-- -----------------------------------------------------
-- Schema d2c
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `d2c` DEFAULT CHARACTER SET utf8 ;
USE `d2c` ;

-- -----------------------------------------------------
-- Table `d2c`.`account`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `d2c`.`account` ;

CREATE TABLE IF NOT EXISTS `d2c`.`account` (
  `username` VARCHAR(20) NOT NULL,
  `password` VARCHAR(20) NOT NULL,
  `fname` VARCHAR(45) NOT NULL,
  `lname` VARCHAR(45) NOT NULL,
  `create_time` TIMESTAMP NOT NULL,
  `account_id` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`account_id`),
  UNIQUE INDEX `username` (`username` ASC),
  UNIQUE INDEX `account_id` (`account_id` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `d2c`.`course`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `d2c`.`course` ;

CREATE TABLE IF NOT EXISTS `d2c`.`course` (
  `subject` VARCHAR(10) NOT NULL,
  `number` VARCHAR(10) NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `course_id` INT(11) NOT NULL AUTO_INCREMENT,
  UNIQUE INDEX `course_id` (`course_id` ASC),
  PRIMARY KEY (`course_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `d2c`.`course_inst`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `d2c`.`course_inst` ;

CREATE TABLE IF NOT EXISTS `d2c`.`course_inst` (
  `year_offered` CHAR(4) NOT NULL,
  `semester` ENUM('FALL', 'WINTER', 'SPRING') NOT NULL,
  `crn` CHAR(5) NOT NULL,
  `prof_name` VARCHAR(45) NOT NULL,
  `course_id` INT(11) NOT NULL,
  `course_inst_id` INT(11) NOT NULL AUTO_INCREMENT,
  UNIQUE INDEX `course_id` (`course_inst_id` ASC),
  PRIMARY KEY (`course_inst_id`),
  INDEX `fk_course_inst_1_idx` (`course_id` ASC),
  UNIQUE INDEX `crn_UNIQUE` (`crn` ASC),
  CONSTRAINT `fk_course_inst_1`
    FOREIGN KEY (`course_id`)
    REFERENCES `d2c`.`course` (`course_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `d2c`.`assignment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `d2c`.`assignment` ;

CREATE TABLE IF NOT EXISTS `d2c`.`assignment` (
  `number` TINYINT NOT NULL,
  `due_date` DATETIME NOT NULL,
  `course_inst_id` INT(11) NOT NULL,
  `assign_id` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`assign_id`),
  UNIQUE INDEX `assign_id` (`assign_id` ASC),
  INDEX `course_id` (`course_inst_id` ASC),
  CONSTRAINT `fk_assignment_1`
    FOREIGN KEY (`course_inst_id`)
    REFERENCES `d2c`.`course_inst` (`course_inst_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `d2c`.`file`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `d2c`.`file` ;

CREATE TABLE IF NOT EXISTS `d2c`.`file` (
  `name` VARCHAR(45) NOT NULL,
  `type` VARCHAR(20) NOT NULL,
  `contents` LONGTEXT NOT NULL,
  `date_added` TIMESTAMP NOT NULL,
  `account_id` INT(11) NOT NULL,
  `file_id` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`file_id`),
  UNIQUE INDEX `file_id` (`file_id` ASC),
  INDEX `fk_file_1_idx` (`account_id` ASC),
  CONSTRAINT `fk_file_1`
    FOREIGN KEY (`account_id`)
    REFERENCES `d2c`.`account` (`account_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `d2c`.`assignment_file`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `d2c`.`assignment_file` ;

CREATE TABLE IF NOT EXISTS `d2c`.`assignment_file` (
  `assign_id` INT(11) NOT NULL,
  `file_id` INT(11) NOT NULL,
  INDEX `assign_id` (`assign_id` ASC),
  INDEX `file_id` (`file_id` ASC),
  PRIMARY KEY (`assign_id`, `file_id`),
  CONSTRAINT `fk_assignment_file_1`
    FOREIGN KEY (`assign_id`)
    REFERENCES `d2c`.`assignment` (`assign_id`),
  CONSTRAINT `fk_assignment_file_2`
    FOREIGN KEY (`file_id`)
    REFERENCES `d2c`.`file` (`file_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `d2c`.`role`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `d2c`.`role` ;

CREATE TABLE IF NOT EXISTS `d2c`.`role` (
  `type` ENUM('PROFESSOR', 'STUDENT', 'TA', 'ADMIN') NOT NULL,
  `account_id` INT(11) NOT NULL,
  `course_inst_id` INT(11) NOT NULL,
  INDEX `course_id` (`course_inst_id` ASC),
  INDEX `account_id` (`account_id` ASC),
  PRIMARY KEY (`account_id`, `course_inst_id`),
  CONSTRAINT `fk_role_1`
    FOREIGN KEY (`course_inst_id`)
    REFERENCES `d2c`.`course_inst` (`course_inst_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_role_2`
    FOREIGN KEY (`account_id`)
    REFERENCES `d2c`.`account` (`account_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `d2c`.`submission`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `d2c`.`submission` ;

CREATE TABLE IF NOT EXISTS `d2c`.`submission` (
  `grade` REAL NULL DEFAULT NULL,
  `time_submitted` TIMESTAMP NOT NULL,
  `account_id` INT(11) NOT NULL,
  `assign_id` INT(11) NOT NULL,
  `submission_id` INT(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`submission_id`),
  UNIQUE INDEX `submission_id` (`submission_id` ASC),
  INDEX `account_id` (`account_id` ASC),
  INDEX `assign_id` (`assign_id` ASC),
  CONSTRAINT `fk_submission_1`
    FOREIGN KEY (`account_id`)
    REFERENCES `d2c`.`account` (`account_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_submission_2`
    FOREIGN KEY (`assign_id`)
    REFERENCES `d2c`.`assignment` (`assign_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `d2c`.`submission_file`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `d2c`.`submission_file` ;

CREATE TABLE IF NOT EXISTS `d2c`.`submission_file` (
  `submission_id` INT(11) NOT NULL,
  `file_id` INT(11) NOT NULL,
  INDEX `submission_id` (`submission_id` ASC),
  PRIMARY KEY (`submission_id`, `file_id`),
  CONSTRAINT `fk_submission_file_1`
    FOREIGN KEY (`submission_id`)
    REFERENCES `d2c`.`submission` (`submission_id`),
  CONSTRAINT `fk_submission_file_2`
    FOREIGN KEY (`file_id`)
    REFERENCES `d2c`.`file` (`file_id`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- -----------------------------------------------------
-- Data for table `d2c`.`account`
-- -----------------------------------------------------
START TRANSACTION;
USE `d2c`;
INSERT INTO `d2c`.`account` (`username`, `password`, `fname`, `lname`, `create_time`, `account_id`) VALUES ('mnjs51', 'password', 'Mike', 'Singleton', DEFAULT, 1);
INSERT INTO `d2c`.`account` (`username`, `password`, `fname`, `lname`, `create_time`, `account_id`) VALUES ('sy6746', 'password', 'Scott', 'Young', DEFAULT, 2);
INSERT INTO `d2c`.`account` (`username`, `password`, `fname`, `lname`, `create_time`, `account_id`) VALUES ('rmp255', 'password', 'Rebecca', 'Price', DEFAULT, 3);
INSERT INTO `d2c`.`account` (`username`, `password`, `fname`, `lname`, `create_time`, `account_id`) VALUES ('mlc258', 'please', 'Michelle', 'Croke', DEFAULT, 4);
INSERT INTO `d2c`.`account` (`username`, `password`, `fname`, `lname`, `create_time`, `account_id`) VALUES ('tmb063', 'please', 'Tyler', 'Bennett', DEFAULT, 5);

COMMIT;


-- -----------------------------------------------------
-- Data for table `d2c`.`course`
-- -----------------------------------------------------
START TRANSACTION;
USE `d2c`;
INSERT INTO `d2c`.`course` (`subject`, `number`, `name`, `course_id`) VALUES ('COMP', '1710', 'Object-Oriented Programming I', 1);
INSERT INTO `d2c`.`course` (`subject`, `number`, `name`, `course_id`) VALUES ('COMP', '2711', 'Introduction to Algorithms and Data Structures', 2);
INSERT INTO `d2c`.`course` (`subject`, `number`, `name`, `course_id`) VALUES ('COMP', '2510', 'Programming in C/C++', 3);
INSERT INTO `d2c`.`course` (`subject`, `number`, `name`, `course_id`) VALUES ('ENGI', '1020', 'Intro to Programming', 4);

COMMIT;


-- -----------------------------------------------------
-- Data for table `d2c`.`course_inst`
-- -----------------------------------------------------
START TRANSACTION;
USE `d2c`;
INSERT INTO `d2c`.`course_inst` (`year_offered`, `semester`, `crn`, `prof_name`, `course_id`, `course_inst_id`) VALUES ('2016', 'WINTER', '00001', 'Mike and Scott', 1, 1);
INSERT INTO `d2c`.`course_inst` (`year_offered`, `semester`, `crn`, `prof_name`, `course_id`, `course_inst_id`) VALUES ('2016', 'WINTER', '00002', 'Mike', 2, 2);
INSERT INTO `d2c`.`course_inst` (`year_offered`, `semester`, `crn`, `prof_name`, `course_id`, `course_inst_id`) VALUES ('2016', 'SPRING', '00003', 'TBA', 3, 3);
INSERT INTO `d2c`.`course_inst` (`year_offered`, `semester`, `crn`, `prof_name`, `course_id`, `course_inst_id`) VALUES ('2016', 'WINTER', '00004', 'Rebecca', 1, 4);
INSERT INTO `d2c`.`course_inst` (`year_offered`, `semester`, `crn`, `prof_name`, `course_id`, `course_inst_id`) VALUES ('2016', 'SPRING', '00005', 'TBA', 4, 5);

COMMIT;


-- -----------------------------------------------------
-- Data for table `d2c`.`assignment`
-- -----------------------------------------------------
START TRANSACTION;
USE `d2c`;
INSERT INTO `d2c`.`assignment` (`number`, `due_date`, `course_inst_id`, `assign_id`) VALUES (1, '2016-01-14 00:00:00', 2, 1);
INSERT INTO `d2c`.`assignment` (`number`, `due_date`, `course_inst_id`, `assign_id`) VALUES (2, '2016-02-07 00:00:00', 2, 2);
INSERT INTO `d2c`.`assignment` (`number`, `due_date`, `course_inst_id`, `assign_id`) VALUES (3, '3016-01-14 00:00:00', 2, 3);

COMMIT;


-- -----------------------------------------------------
-- Data for table `d2c`.`file`
-- -----------------------------------------------------
START TRANSACTION;
USE `d2c`;
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('HelloWorld', 'java', 'public class HelloWorld{\n    public static void main(String []args){\n        System.out.println(\"Hello World! ~java\");\n    }\n}\n', DEFAULT, 2, 4);
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('hello_world', 'c', '#include<stdio.h>\n\nmain()\n{\n    printf(\"Hello World! ~c\");\n}\n', DEFAULT, 2, 6);
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('1710 ass 1', 'txt', 'a1', DEFAULT, 2, 7);
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('1710 ass 2', 'txt', 'a2.1', DEFAULT, 1, 8);
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('1710 ass 3', 'txt', 'a3', DEFAULT, 1, 9);
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('sub1', 'txt', 'a 1 s 1 4', DEFAULT, 4, 10);
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('a2s1', 'txt', 'a 2 s 1 4', DEFAULT, 4, 11);
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('a2s2', 'txt', 'a 2 s 2 4', DEFAULT, 4, 12);
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('a1s1', 'txt', 'a 1 s 1 5', DEFAULT, 5, 13);
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('a1s2', 'txt', 'a 1 s 2 5', DEFAULT, 5, 14);
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('a2s1', 'txt', 'a 2 s 1 5', DEFAULT, 5, 15);
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('a2s2', 'txt', 'a 2 s 2 5', DEFAULT, 5, 16);
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('a3s1', 'txt', 'a 3 s 1 5', DEFAULT, 5, 17);
INSERT INTO `d2c`.`file` (`name`, `type`, `contents`, `date_added`, `account_id`, `file_id`) VALUES ('a2part2', 'txt', 'a2.2', DEFAULT, 2, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `d2c`.`assignment_file`
-- -----------------------------------------------------
START TRANSACTION;
USE `d2c`;
INSERT INTO `d2c`.`assignment_file` (`assign_id`, `file_id`) VALUES (1, 7);
INSERT INTO `d2c`.`assignment_file` (`assign_id`, `file_id`) VALUES (2, 8);
INSERT INTO `d2c`.`assignment_file` (`assign_id`, `file_id`) VALUES (3, 9);
INSERT INTO `d2c`.`assignment_file` (`assign_id`, `file_id`) VALUES (2, 1);

COMMIT;


-- -----------------------------------------------------
-- Data for table `d2c`.`role`
-- -----------------------------------------------------
START TRANSACTION;
USE `d2c`;
INSERT INTO `d2c`.`role` (`type`, `account_id`, `course_inst_id`) VALUES ('PROFESSOR', 2, 1);
INSERT INTO `d2c`.`role` (`type`, `account_id`, `course_inst_id`) VALUES ('PROFESSOR', 1, 1);
INSERT INTO `d2c`.`role` (`type`, `account_id`, `course_inst_id`) VALUES ('TA', 3, 1);
INSERT INTO `d2c`.`role` (`type`, `account_id`, `course_inst_id`) VALUES ('STUDENT', 4, 1);
INSERT INTO `d2c`.`role` (`type`, `account_id`, `course_inst_id`) VALUES ('STUDENT', 5, 1);
INSERT INTO `d2c`.`role` (`type`, `account_id`, `course_inst_id`) VALUES ('PROFESSOR', 1, 2);
INSERT INTO `d2c`.`role` (`type`, `account_id`, `course_inst_id`) VALUES ('TA', 4, 2);
INSERT INTO `d2c`.`role` (`type`, `account_id`, `course_inst_id`) VALUES ('STUDENT', 2, 2);
INSERT INTO `d2c`.`role` (`type`, `account_id`, `course_inst_id`) VALUES ('STUDENT', 5, 2);
INSERT INTO `d2c`.`role` (`type`, `account_id`, `course_inst_id`) VALUES ('PROFESSOR', 3, 4);
INSERT INTO `d2c`.`role` (`type`, `account_id`, `course_inst_id`) VALUES ('STUDENT', 1, 4);
INSERT INTO `d2c`.`role` (`type`, `account_id`, `course_inst_id`) VALUES ('STUDENT', 5, 4);

COMMIT;


-- -----------------------------------------------------
-- Data for table `d2c`.`submission`
-- -----------------------------------------------------
START TRANSACTION;
USE `d2c`;
INSERT INTO `d2c`.`submission` (`grade`, `time_submitted`, `account_id`, `assign_id`, `submission_id`) VALUES (0, '2016-01-17 00:00:00', 4, 1, 1);
INSERT INTO `d2c`.`submission` (`grade`, `time_submitted`, `account_id`, `assign_id`, `submission_id`) VALUES (NULL, '2016-02-06 00:00:00', 4, 2, 2);
INSERT INTO `d2c`.`submission` (`grade`, `time_submitted`, `account_id`, `assign_id`, `submission_id`) VALUES (30.0, '2016-02-06 11:11:11', 4, 2, 3);
INSERT INTO `d2c`.`submission` (`grade`, `time_submitted`, `account_id`, `assign_id`, `submission_id`) VALUES (NULL, '2016-01-12 00:00:00', 5, 1, 4);
INSERT INTO `d2c`.`submission` (`grade`, `time_submitted`, `account_id`, `assign_id`, `submission_id`) VALUES (74.3723, '2016-01-14 00:11:11', 5, 1, 5);
INSERT INTO `d2c`.`submission` (`grade`, `time_submitted`, `account_id`, `assign_id`, `submission_id`) VALUES (88, '2016-02-05 00:00:00', 5, 2, 6);
INSERT INTO `d2c`.`submission` (`grade`, `time_submitted`, `account_id`, `assign_id`, `submission_id`) VALUES (NULL, '2016-02-23 00:00:00', 5, 3, 7);

COMMIT;


-- -----------------------------------------------------
-- Data for table `d2c`.`submission_file`
-- -----------------------------------------------------
START TRANSACTION;
USE `d2c`;
INSERT INTO `d2c`.`submission_file` (`submission_id`, `file_id`) VALUES (1, 10);
INSERT INTO `d2c`.`submission_file` (`submission_id`, `file_id`) VALUES (2, 11);
INSERT INTO `d2c`.`submission_file` (`submission_id`, `file_id`) VALUES (3, 12);
INSERT INTO `d2c`.`submission_file` (`submission_id`, `file_id`) VALUES (4, 13);
INSERT INTO `d2c`.`submission_file` (`submission_id`, `file_id`) VALUES (5, 14);
INSERT INTO `d2c`.`submission_file` (`submission_id`, `file_id`) VALUES (6, 15);
INSERT INTO `d2c`.`submission_file` (`submission_id`, `file_id`) VALUES (6, 16);
INSERT INTO `d2c`.`submission_file` (`submission_id`, `file_id`) VALUES (7, 17);

COMMIT;
