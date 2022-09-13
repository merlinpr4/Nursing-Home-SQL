SELECT first_name, dob FROM resident;

SELECT *
FROM resident 
WHERE age >= "80" 
ORDER BY dob DESC, last_name, first_name ; -- ordered by dob and last name hierarcy in descending order

SELECT *
FROM resident 
WHERE age >= "76" AND gender = "Female"
ORDER BY dob DESC, last_name, first_name ; -- ordered by dob and last name hierarcy in descending order

SELECT *
FROM resident 
WHERE wid = "2" AND age > 70
ORDER BY dob DESC, last_name, first_name ; -- ordered by dob and last name hierarcy in descending order

SELECT *
FROM  staff
WHERE gender = "Female" OR salary < 40000
ORDER BY salary DESC ;

SELECT *
FROM  staff
WHERE NOT position = "Staff Nurse"	
ORDER BY salary DESC ;

SELECT *
FROM staff
WHERE salary BETWEEN "40000" AND "60000";

SELECT *
FROM staff
WHERE position LIKE "%Nurse%" ; -- matches similar expressions 

SELECT wid AS "ward id", first_name,last_name,age -- to rename column names on display
FROM staff
WHERE age > 40 ; -- matches similar expressions 

SELECT PPSN,AVG(salary)
FROM staff
group by PPSN ;

SELECT position,COUNT(*)
FROM staff
GROUP BY position;

-- nested query to find the staff that are being paid more than the average staff salary
SELECT *
FROM staff
WHERE salary >
	(SELECT AVG(salary)
	 FROM staff );
     
 -- join
  -- join
 SELECT *
 FROM ward
 JOIN staff
 ON ward.wid = staff.wid
 WHERE position LIKE "%Nurse%" ; -- matches similar expressions 

          
 SELECT ward.name,staff.first_name, ward.wid
 FROM ward
 JOIN staff
 ON ward.wid = staff.wid ;
 
SELECT ward.name,ward.wid,COUNT(staff.PPSN)
FROM ward
JOIN staff
 ON ward.wid = staff.wid
GROUP BY ward.wid;  




 SELECT ward.wid AS "ward id", ward.name AS "ward name",  staff.last_name,age, staff.position -- to rename column names on display
 FROM ward
 JOIN staff
 ON ward.wid = staff.wid
 WHERE position LIKE "%Nurse%" ; -- matches similar expressions 
          
-- select all the residents that a specifc doctor of a ward takes care of

-- Get all particpants in classes taught by Niamh Murphy
SELECT participant.first_name, participant.last_name
FROM participant
JOIN takes_course ON takes_course.participant_id = participant.participant_id 
JOIN course ON takes_course.course_id = course.course_id
WHERE takes_course.course_id = 
    (SELECT takes_course.course_id 
    WHERE course.teacher = 6);

-- find all the residents that are taking part in activity 8
SELECT resident.first_name, resident.last_name, resident.rid
FROM resident
JOIN activities_engaged ON activities_engaged.rid = resident.rid
JOIN recreational_activities ON activities_engaged.aid = recreational_activities.aid
WHERE activities_engaged.aid =
	(SELECT activities_engaged.aid
	 WHERE recreational_activities.aid = "8") ;  
                    

-- all the mediciation taken by a specific resident
SELECT medicine.name, medicine.mid, medicine.expiry_date, price
FROM medicine
JOIN medicine_taken ON medicine_taken.mid = medicine.mid
JOIN resident ON medicine_taken.rid = resident.rid
WHERE medicine_taken.rid =
	(SELECT medicine_taken.rid 
	 WHERE resident.rid = "1") ; 
   
-- find all the residents that are taking part in activity with id 8
SELECT resident.first_name, resident.last_name, resident.rid
FROM resident
JOIN activities_engaged ON activities_engaged.rid = resident.rid
JOIN recreational_activities ON activities_engaged.aid = recreational_activities.aid
WHERE activities_engaged.aid =
	(SELECT activities_engaged.aid
	 WHERE recreational_activities.aid = "8") ;

 -- union of old and new residents (additional feature)  
 SELECT rid,date_admitted,last_name, "New" AS status	     
 FROM resident
 WHERE date_admitted >= "2022-01-01"
 UNION
 SELECT rid,date_admitted,last_name, "Old" AS status	     
 FROM resident
 WHERE date_admitted <= "2019-01-01";


SELECT position,COUNT(staff.PPSN)
FROM staff
GROUP BY position;   


              
