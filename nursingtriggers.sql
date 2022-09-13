-- triggers
delimiter $$
CREATE TRIGGER resident_age 
BEFORE INSERT
ON resident
FOR EACH ROW
IF NEW.age <= 18 THEN
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



23:40:50	CREATE TRIGGER resident_age  BEFORE INSERT ON resident FOR EACH ROW IF NEW.age <= 18 THEN SIGNAL SQLSTATE '50001' SET MESSAGE_TEXT = 'Residents must be 18 or older.'; END IF;	0 row(s) affected	0.031 sec



