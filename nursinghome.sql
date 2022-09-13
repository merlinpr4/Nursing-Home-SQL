-- SQL code for a nursing home by Merlin Prasad Student Number : 19333557
-- creating DB --
DROP DATABASE IF EXISTS `nursing_home`;
CREATE DATABASE `nursing_home`;
USE `nursing_home`;

-- creating the tables --
CREATE TABLE `ward` (
  `wid` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `phoneno` INT NOT NULL,
  PRIMARY KEY (`wid`));

CREATE TABLE `staff` (
  `PPSN` VARCHAR(9) NOT NULL,
   `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45)  NULL,
  `salary` INT NULL,
  `position` VARCHAR(45) NOT NULL,
  `age` INT NOT NULL,
  `gender` VARCHAR(45) NOT NULL,
  `wid` INT ,
  CHECK (wid >= 1 AND wid <= 5 ),
  PRIMARY KEY (`PPSN`),
  FOREIGN KEY (`wid`) REFERENCES `ward`(`wid`) );
  
CREATE TABLE `qualifications` (
  `PPSN` VARCHAR(9) NOT NULL,
  `qualification` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`PPSN`, `qualification`),
  FOREIGN KEY(`PPSN`) REFERENCES `staff`(`PPSN`));

    
CREATE TABLE `resident` (
  `rid` INT NOT NULL,
  `date_admitted` DATE NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45)  NULL,
  `gender` VARCHAR(45) NOT NULL,
  `wid` INT ,
   CHECK (wid >= 1 AND wid <= 5 ),
  `age` INT ,
  PRIMARY KEY (`rid`),
  FOREIGN KEY (`wid`) REFERENCES `ward`(`wid`) );

CREATE TABLE `medicine` (
  `mid` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `expiry_date` DATE NOT NULL,
  `price` INT NULL,
  PRIMARY KEY (`mid`));

CREATE TABLE `medicine_taken` (
  `rid` INT NOT NULL,
  `mid` INT NOT NULL,
  PRIMARY KEY (`rid`, `mid`),
  FOREIGN KEY(`rid`) REFERENCES `resident`(`rid`) ON DELETE CASCADE,
  FOREIGN KEY(`mid`) REFERENCES `medicine`(`mid`) ON DELETE CASCADE );

CREATE TABLE `recreational_activities` (
  `aid` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `activity_type` VARCHAR(45) NULL,
  `occupancy` INT NULL,
  PRIMARY KEY (`aid`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE);

CREATE TABLE `activities_engaged` (
  `rid` INT NOT NULL,
  `aid` INT NOT NULL,
  PRIMARY KEY (`rid`, `aid`),
  FOREIGN KEY(`rid`) REFERENCES `resident`(`rid`) ON DELETE CASCADE,
  FOREIGN KEY(`aid`) REFERENCES `recreational_activities`(`aid`) ON DELETE CASCADE );

-- table alterations
ALTER TABLE resident
ADD previous_wid  INT NULL
AFTER wid ;



-- triggers
delimiter $$
CREATE TRIGGER resident_age 
BEFORE INSERT
ON resident
FOR EACH ROW
IF NEW.age < 18 THEN
SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Residents must be 18 or older.';
END IF; $$
delimiter ;

delimiter $$
CREATE TRIGGER minimum_salary
BEFORE INSERT
ON staff
FOR EACH ROW
IF NEW.salary < 20685
THEN SET NEW.salary = 20685 ;
END IF; $$
delimiter ;


delimiter $$
CREATE TRIGGER old_wid
BEFORE UPDATE
ON resident
FOR EACH ROW
BEGIN
IF NEW.wid <> OLD.wid THEN
 SET NEW.previous_wid = OLD.wid ;
END IF; 
END $$
delimiter ;

-- functions

DROP FUNCTION IF EXISTS years_since_date;
delimiter $$
CREATE FUNCTION years_since_date(old_date date ) RETURNS INT DETERMINISTIC
BEGIN
	RETURN year(current_date()) - year(old_date);
END $$
delimiter ;

-- all the mediciation taken by a specific resident



-- populate tables --
INSERT INTO `nursing_home`.`ward` (`wid`, `name`, `phoneno`) VALUES ('1', 'Seton', '0124721');
INSERT INTO `nursing_home`.`ward` (`wid`, `name`, `phoneno`) VALUES ('2', 'Nerses', '0124714');
INSERT INTO `nursing_home`.`ward` (`wid`, `name`, `phoneno`) VALUES ('3', 'Jacques', '0124756');
INSERT INTO `nursing_home`.`ward` (`wid`, `name`, `phoneno`) VALUES ('4', 'Vincenz', '0124790');
INSERT INTO `nursing_home`.`ward` (`wid`, `name`, `phoneno`) VALUES ('5', 'Elizabeth', '0124712');
    
    
INSERT INTO `nursing_home`.`staff` (`PPSN`, `first_name`, `last_name`, `Salary`, `Position`, `Age`, `Gender`,`wid`) VALUES ('1457266H', 'Julius' , 'Hibbert', '60900', 'Doctor', '59', 'Male',1);
INSERT INTO `nursing_home`.`staff` (`PPSN`, `first_name`, `last_name`, `Salary`, `Position`, `Age`, `Gender`,`wid`) VALUES ('2578903T', 'Todd' , 'Flanders', '39000', 'Staff Nurse', '23', 'Male',3);
INSERT INTO `nursing_home`.`staff` (`PPSN`, `first_name`, `last_name`, `Salary`, `Position`, `Age`, `Gender`,`wid`) VALUES ('3475606W', 'Patty' ,'Bev', '48736', 'Senior Staff Nurse', '48', 'Female',4);
INSERT INTO `nursing_home`.`staff` (`PPSN`, `first_name`, `last_name`, `Salary`, `Position`, `Age`, `Gender`,`wid`) VALUES ('7890246U', 'Nelson',  'Muntz', '32068', 'Activity Coordinator', '34', 'Male',2);
INSERT INTO `nursing_home`.`staff` (`PPSN`, `first_name`, `last_name`, `Salary`, `Position`, `Age`, `Gender`,`wid`) VALUES ('7903579W', 'Ralph' , 'Wiggum', '34000', 'Carer', '41', 'Male',4);
INSERT INTO `nursing_home`.`staff` (`PPSN`, `first_name`, `last_name`, `Salary`, `Position`, `Age`, `Gender`,`wid`) VALUES ('1453679T', 'Helen' , 'Lovejoy', '55469', 'CNM', '48', 'Female',5);
INSERT INTO `nursing_home`.`staff` (`PPSN`, `first_name`, `last_name`, `Salary`, `Position`, `Age`, `Gender`,`wid`) VALUES ('0896326Y', 'Lisa' ,'Simpson', '68846', 'Director', '33', 'Female',1);
INSERT INTO `nursing_home`.`staff` (`PPSN`, `first_name`, `last_name`, `Salary`, `Position`, `Age`, `Gender`,`wid`) VALUES ('1253579K', 'Nicholas', 'Riviera', '60833', 'Doctor', '46', 'Male',3);
INSERT INTO `nursing_home`.`staff` (`PPSN`, `first_name`, `last_name`, `Salary`, `Position`, `Age`, `Gender`,`wid`) VALUES ('8463149Z', 'Edna' , 'Krabappel', '39000', 'Staff Nurse', '58', 'Female',5);

INSERT INTO `nursing_home`.`qualifications` (`PPSN`, `qualification`) VALUES ('1253579K', 'MD');
INSERT INTO `nursing_home`.`qualifications` (`PPSN`, `qualification`) VALUES ('1253579K', 'MB');
INSERT INTO `nursing_home`.`qualifications` (`PPSN`, `qualification`) VALUES ('1457266H', 'MD');
INSERT INTO `nursing_home`.`qualifications` (`PPSN`, `qualification`) VALUES ('1457266H', 'MB');
INSERT INTO `nursing_home`.`qualifications` (`PPSN`, `qualification`) VALUES ('8463149Z', 'BSN');
INSERT INTO `nursing_home`.`qualifications` (`PPSN`, `qualification`) VALUES ('3475606W', 'BSN');
INSERT INTO `nursing_home`.`qualifications` (`PPSN`, `qualification`) VALUES ('2578903T', 'ASN');
INSERT INTO `nursing_home`.`qualifications` (`PPSN`, `qualification`) VALUES ('1453679T', 'BSN');
INSERT INTO `nursing_home`.`qualifications` (`PPSN`, `qualification`) VALUES ('1453679T', 'MSN');
INSERT INTO `nursing_home`.`qualifications` (`PPSN`, `qualification`) VALUES ('7890246U', 'BA');
INSERT INTO `nursing_home`.`qualifications` (`PPSN`, `qualification`) VALUES ('7903579W', 'QQI Lvl 5');
INSERT INTO `nursing_home`.`qualifications` (`PPSN`, `qualification`) VALUES ('0896326Y', 'MS');
INSERT INTO `nursing_home`.`qualifications` (`PPSN`, `qualification`) VALUES ('0896326Y', 'BS');


INSERT INTO `nursing_home`.`resident` (`rid`, `date_admitted`,  `first_name`, `last_name`, `gender`, `wid`, `age`) VALUES ('7', '2019/07/04',  'Charles', 'Burns', 'Male', '3', '80');
INSERT INTO `nursing_home`.`resident` (`rid`, `date_admitted`, `first_name`, `last_name`, `gender`, `wid`, `age`) VALUES ('5', '2018/10/19',  'Hans', 'Moleman', 'Male', '3', '65');
INSERT INTO `nursing_home`.`resident` (`rid`, `date_admitted`,`first_name`, `last_name`, `gender`, `wid`, `age`) VALUES ('9', '2021/02/05', 'Abraham', 'Simpson', 'Male', '4', '73');
INSERT INTO `nursing_home`.`resident` (`rid`, `date_admitted`,  `first_name`, `last_name`, `gender`, `wid`, `age`) VALUES ('6', '2019/07/04',  'Jacqueline', 'Bouvier', 'Female', '1', '70');
INSERT INTO `nursing_home`.`resident` (`rid`, `date_admitted`, `first_name`, `last_name`, `gender`, `wid`, `age`) VALUES ('4', '2018/04/17', 'Jasper', 'Beardly', 'Male', '5', '90');
INSERT INTO `nursing_home`.`resident` (`rid`, `date_admitted`,  `first_name`, `last_name`, `gender`,  `wid`, `age`) VALUES ('8', '2020/06/16',  'Agnes', 'Skinner', 'Female',  '2', '87');
INSERT INTO `nursing_home`.`resident` (`rid`, `date_admitted`,  `first_name`, `last_name`, `gender`,  `wid`, `age`) VALUES ('1', '2016/12/21', 'Philip', 'Fry', 'Male', '2', '87');
INSERT INTO `nursing_home`.`resident` (`rid`, `date_admitted`,  `first_name`, `last_name`, `gender`, `wid`, `age`) VALUES ('3', '2017/07/30',  'Hubert', 'Farnsworth', 'Male', '4', '92');
INSERT INTO `nursing_home`.`resident` (`rid`, `date_admitted`,  `first_name`, `last_name`, `gender`, `wid`, `age`) VALUES ('10', '2022/01/02',  'Carol', 'Miller', 'Female', '5', '76');
INSERT INTO `nursing_home`.`resident` (`rid`, `date_admitted`,  `first_name`, `last_name`, `gender`, `wid`, `age`) VALUES ('2', '2017/07/30',  'Murel', 'Bagge', 'Female', '1', '76');
INSERT INTO `nursing_home`.`resident` (`rid`, `date_admitted`,  `first_name`, `last_name`, `gender`, `wid`, `age`) VALUES ('11', '2022/01/13',  'Eleanor', 'Abernathy', 'Female', '5', '66');

UPDATE resident SET wid = 2 WHERE rid = 1 ;
UPDATE resident SET wid = 1 WHERE rid = 5 ;
UPDATE resident SET wid = 5 WHERE rid = 2 ;
UPDATE resident SET wid = 3 WHERE rid = 7 ;

INSERT INTO `nursing_home`.`medicine` (`mid`, `name`, `expiry_date`, `price`) VALUES ('51', 'sulfonylureas', '2022/12/09', '150');
INSERT INTO `nursing_home`.`medicine` (`mid`, `name`, `expiry_date`, `price`) VALUES ('61', 'plendil', '2024/10/5', '70');
INSERT INTO `nursing_home`.`medicine` (`mid`, `name`, `expiry_date`, `price`) VALUES ('11', 'hydrocodone', '2024/10/3', '44');
INSERT INTO `nursing_home`.`medicine` (`mid`, `name`, `expiry_date`, `price`) VALUES ('21', 'simvastatin', '2023/1/3', '32');
INSERT INTO `nursing_home`.`medicine` (`mid`, `name`, `expiry_date`, `price`) VALUES ('31', 'azithromycin', '2025/6/7', '121');
INSERT INTO `nursing_home`.`medicine` (`mid`, `name`, `expiry_date`, `price`) VALUES ('41', 'paracetomol', '2023/5/5', '11');
INSERT INTO `nursing_home`.`medicine` (`mid`, `name`, `expiry_date`, `price`) VALUES ('71', 'piriton', '2022/3/5', '14');

INSERT INTO `nursing_home`.`medicine_taken` (`rid`, `mid`) VALUES ('1', '51');
INSERT INTO `nursing_home`.`medicine_taken` (`rid`, `mid`) VALUES ('1', '31');
INSERT INTO `nursing_home`.`medicine_taken` (`rid`, `mid`) VALUES ('3', '11');
INSERT INTO `nursing_home`.`medicine_taken` (`rid`, `mid`) VALUES ('5', '31');
INSERT INTO `nursing_home`.`medicine_taken` (`rid`, `mid`) VALUES ('5', '71');
INSERT INTO `nursing_home`.`medicine_taken` (`rid`, `mid`) VALUES ('8', '51');
INSERT INTO `nursing_home`.`medicine_taken` (`rid`, `mid`) VALUES ('8', '41');
INSERT INTO `nursing_home`.`medicine_taken` (`rid`, `mid`) VALUES ('8', '21');
INSERT INTO `nursing_home`.`medicine_taken` (`rid`, `mid`) VALUES ('6', '11');

INSERT INTO `nursing_home`.`recreational_activities` (`aid`, `name`, `activity_type`, `occupancy`) VALUES ('1', 'bingo', 'social', '9');
INSERT INTO `nursing_home`.`recreational_activities` (`aid`, `name`, `activity_type`, `occupancy`) VALUES ('2', 'bowling', 'physical', '5');
INSERT INTO `nursing_home`.`recreational_activities` (`aid`, `name`, `activity_type`, `occupancy`) VALUES ('3', 'movies', 'social', '6');
INSERT INTO `nursing_home`.`recreational_activities` (`aid`, `name`, `activity_type`, `occupancy`) VALUES ('4', 'newspaper', 'leisure', '7');
INSERT INTO `nursing_home`.`recreational_activities` (`aid`, `name`, `activity_type`, `occupancy`) VALUES ('5', 'mass', 'religious', '5');
INSERT INTO `nursing_home`.`recreational_activities` (`aid`, `name`, `activity_type`, `occupancy`) VALUES ('6', 'gardening', 'physical', '6');
INSERT INTO `nursing_home`.`recreational_activities` (`aid`, `name`, `activity_type`, `occupancy`) VALUES ('7', 'music', 'leisure', '5');
INSERT INTO `nursing_home`.`recreational_activities` (`aid`, `name`, `activity_type`, `occupancy`) VALUES ('8', 'knitting', 'leisure', '11');
INSERT INTO `nursing_home`.`recreational_activities` (`aid`, `name`, `activity_type`, `occupancy`) VALUES ('9', 'meditation', 'leisure', '10');

INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('1', '3');
INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('2', '5');
INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('3', '8');
INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('4', '8');
INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('5', '2');
INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('6', '1');
INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('7', '4');
INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('8', '5');
INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('9', '7');
INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('10', '1');
INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('1', '6');
INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('3', '2');
INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('7', '8');
INSERT INTO `nursing_home`.`activities_engaged` (`rid`, `aid`) VALUES ('8', '9');

-- views
CREATE VIEW nurses_employed AS
 SELECT ward.wid AS "ward id", ward.name AS "ward name",  staff.last_name,age, staff.position 
 FROM ward
 JOIN staff
 ON ward.wid = staff.wid
 WHERE position LIKE "%Nurse%";

CREATE VIEW ward_occupancy AS
SELECT ward.wid as "ward id", ward.name AS "ward name", COUNT(resident.rid) "no of residents"
FROM resident
JOIN ward ON ward.wid = resident.wid
GROUP BY ward.wid;

CREATE VIEW resident1_meds AS
SELECT medicine.name, medicine.mid, medicine.expiry_date, price
FROM medicine
JOIN medicine_taken ON medicine_taken.mid = medicine.mid
JOIN resident ON medicine_taken.rid = resident.rid
WHERE medicine_taken.rid =
	(SELECT medicine_taken.rid 
	 WHERE resident.rid = "1") ; 

-- queries
 --  find the staff that are being paid more than the average staff salary
SELECT *
FROM staff
WHERE salary >
	(SELECT AVG(salary)
	 FROM staff );

-- find all the residents that are taking part in activity 8
SELECT resident.first_name, resident.last_name, resident.rid
FROM resident
JOIN activities_engaged ON activities_engaged.rid = resident.rid
JOIN recreational_activities ON activities_engaged.aid = recreational_activities.aid
WHERE activities_engaged.aid =
	(SELECT activities_engaged.aid
	 WHERE recreational_activities.aid = "8") ;  
                    
 -- union of old and new residents 
 SELECT rid,date_admitted,years_since_date(date_admitted) AS "years at nursing home" , last_name,  "New" AS status	     
 FROM resident
 WHERE date_admitted >= "2022-01-01"
 UNION
 SELECT rid,date_admitted,years_since_date(date_admitted) AS "years at nursing home" ,last_name, "Old" AS status	     
 FROM resident
 WHERE date_admitted <= "2022-01-01";

SELECT wid,rid,last_name,age, rank()
OVER (partition by wid order by age DESC )
AS "seniority in ward" FROM resident ;

-- security commands roles and permissions
DROP ROLE IF EXISTS hr_dir ;
CREATE ROLE hr_dir;

DROP ROLE IF EXISTS hr_mgr ;
CREATE ROLE hr_mgr;

GRANT CREATE,INSERT,UPDATE,SELECT 
ON staff
TO hr_dir 
WITH GRANT OPTION;

-- create a restircted view of staff without ppsn or salary information for security
CREATE VIEW staff_restricted AS
SELECT first_name,age,position,wid
FROM staff ;

GRANT SELECT,UPDATE,DELETE 
ON staff_restricted
TO hr_mgr ;

-- procedure call
-- stored procedures parameterised
delimiter $$
DROP PROCEDURE IF EXISTS get_residents_ages;
CREATE PROCEDURE get_residents_ages(IN resident_age INT )
BEGIN
	SELECT rid,last_name,age
		FROM resident 
		WHERE age >= resident_age
		ORDER BY age , last_name ; 
END $$
delimiter ;
CALL get_residents_ages("90");


