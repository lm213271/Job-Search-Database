
drop table school CASCADE CONSTRAINTS;
drop table school_location;
drop table degree_type CASCADE CONSTRAINTS;
drop table person_ CASCADE CONSTRAINTS;
drop table connectTo;
drop table education;
drop table employer CASCADE CONSTRAINTS;
drop table industry;
drop table workAt;
drop table branch CASCADE CONSTRAINTS;

CREATE TABLE school
(school_id CHAR(5), 
school_name CHAR(50),
public_private CHAR(50),
school_type CHAR(50),
PRIMARY KEY(school_id));

INSERT INTO school(school_id, school_name, public_private, school_type) 
VALUES('01025', 'George Mason', 'public', 'University');
INSERT INTO school(school_id, school_name, public_private, school_type)
VALUES('22045', 'Stafford', 'public', 'High School');

CREATE TABLE school_location
(school_id CHAR(5),
city CHAR(50),
school_state CHAR(5),
FOREIGN KEY(school_id) REFERENCES school(school_id));

INSERT INTO school_location(school_id, city, school_state)
VALUES('01025', 'Fairfax', 'VA');
INSERT INTO school_location(school_id, city, school_state)
VALUES('22045', 'Stafford', 'VA');

CREATE TABLE degree_type
(major CHAR(50),
degree_name CHAR(50),
school_id CHAR(5),
UNIQUE(degree_name, major),
FOREIGN KEY(school_id) REFERENCES school(school_id));

INSERT INTO degree_type(major, degree_name, school_id)
VALUES('CS','Bachelor','01025');
INSERT INTO degree_type(major, degree_name, school_id)
VALUES('N/A', 'High School Diploma', '22045');

CREATE TABLE person_
(PID CHAR(5), 
P_name CHAR(50), 
birth_year INTEGER,
gender CHAR(50),
PRIMARY KEY(PID));

INSERT INTO person_(PID, P_name, birth_year, gender)
VALUES('10001', 'Laila Mashel', 1997, 'Female');
INSERT INTO person_(PID, P_name, birth_year, gender)
VALUES('54678', 'Hajer Afshar', 2004, 'Female');
INSERT INTO person_(PID, P_name, birth_year, gender)
VALUES('48235', 'Laura Gonzalez', 1990, 'Female');
INSERT INTO person_(PID, P_name, birth_year, gender)
VALUES('63967', 'Brian Smith', 1994, 'Male');

CREATE TABLE connectTo
(PID1 CHAR(5), 
PID2 CHAR(5),
relationship CHAR(50),
FOREIGN KEY(PID1) REFERENCES person_(PID),
FOREIGN KEY(PID2) REFERENCES person_(PID));

INSERT INTO connectTo(PID1, PID2, relationship)
VALUES('10001', '54678', 'Friend');
INSERT INTO connectTo(PID1, PID2, relationship)
VALUES('48235', '63967', 'Classmates');

CREATE TABLE education
(PID CHAR(5), 
major CHAR(50), 
degree_name CHAR(50),
year_graduate INTEGER,
FOREIGN KEY(PID) REFERENCES person_(PID),
FOREIGN KEY(major, degree_name) REFERENCES degree_type(major, degree_name));

INSERT INTO education(PID, major, degree_name, year_graduate)
VALUES('10001', 'CS', 'Bachelor', 2017);
INSERT INTO education(PID, major, degree_name, year_graduate)
VALUES('54678', 'N/A', 'High School Diploma', 2018);

CREATE TABLE employer
(EID CHAR(5), 
employer_name CHAR(50),
Primary KEY (EID));

INSERT INTO employer(EID, employer_name)
VALUES('28509', 'Google');
INSERT INTO employer(EID, employer_name)
VALUES('95620', 'Verizon');

CREATE TABLE industry
(EID CHAR(5),
industry CHAR(50),
FOREIGN KEY (EID) REFERENCES employer(EID));

INSERT INTO industry(EID, industry)
VALUES('28509', 'Technology');
INSERT INTO industry(EID, industry)
VALUES('95620', 'Telecommunication');

CREATE TABLE branch
(city CHAR(50), 
branch_state CHAR(50),
branch_num INTEGER,
EID CHAR(5),
PRIMARY KEY(branch_num),
FOREIGN KEY(EID) REFERENCES employer(EID));

INSERT INTO branch(city, branch_state, branch_num, EID)
VALUES('Arlington', 'VA', 100115, '28509');
INSERT INTO branch(city, branch_state, branch_num, EID)
VALUES('Alexandria', 'VA', 100045, '95620');

CREATE TABLE workAt
(PID CHAR(5),
start_date CHAR(50),
end_date CHAR (50),
title CHAR(50),
status CHAR(50),
branch_num INTEGER,
FOREIGN KEY(PID) REFERENCES person_(PID),
FOREIGN KEY(branch_num) REFERENCES branch(branch_num));

INSERT INTO workAt(PID, start_date, end_date, title, status, 
branch_num)
VALUES('10001', '08/15/2017', '01/15/2017', 'Software Developer Intern', 'Full Time', 100115);
INSERT INTO workAt(PID, start_date, end_date, title, status, 
branch_num)
VALUES('54678', '03/04/2018', '06/05/2019', 'Manager', 'Full Time', 100045);

select * from school;
select * from school_location;
select * from degree_type;
select * from person_;
select * from connectTo;
select * from education;
select * from employer;
select * from employer;
select * from industry;
select * from branch;
select * from workAt;

--1.Print the names of all alumni of George Mason University (school_ID = ‘GMU’) 
--who graduated in or before 2012, along with their degrees/majors/years. 
select P.first_name, P.last_name, E.degree_name, E.major, E.graduation_year
from Person P, Education E
where P.PID=E.PID AND E.school_ID='GMU' AND E.graduation_year<=2012;

--2.Print the names (first name, last name) of all dsmith’s connections
select DISTINCT P.first_name, P.last_name
from Person P, Connection C 
where C.Friend_PID='dsmith' AND P.PID=C.PID;


--3.Print the names of users who have no connection in the network.
select DISTINCT P.first_name, P.last_name
from Person P
MINUS
select DISTINCT P.first_name, P.last_name
from Person P, Connection C
where P.PID=C.PID;

--4.Print the names of users who studied different subjects for their BS and MS 
-- 1st method using != 

select P.first_name, P.last_name
from Person P, Education E1, Education E2
where P.PID=E1.PID AND E1.PID=E2.PID AND 
E1.degree_name='BS' AND E2.degree_name='MS'
MINUS
select P.first_name, P.last_name
from Person P, Education E1, Education E2
where P.PID=E1.PID AND E1.PID=E2.PID AND 
E1.degree_name='BS' AND E2.degree_name='MS'
AND E1.major=E2.major;

--5.Print the ID of schools that no user in the network has attended.
select school_ID from School
MINUS
select S.school_ID
from School S, Education E
where S.school_ID=E.school_ID;

--6.Find the names of dsmith’s friends who graduated from the same 
--  college that he got his BS degree from.

select DISTINCT P.first_name, P.last_name
from Person P, Connection C, Education E1, Education E2
where P.PID=C.Friend_PID AND C.PID='dsmith'
AND E1.PID=C.Friend_PID AND E2.PID='dsmith'
AND E1.degree_name='BS' AND E1.school_ID=E2.school_ID;

--7.Print the PID of GMU alumni (school_code = ‘GMU’) who have worked or 
--currently work for Microsoft (company_name = ‘Microsoft’). Use  
--Intersection for this query.

select DISTINCT P.PID
from Person P, Education E, WorksAt W, Company C
where P.PID=W.PID AND C.company_name='Microsoft' 
AND C.company_ID=W.company_ID
intersect
select P.PID
from Person P, Education E, WorksAt W, Company C
where P.PID=E.PID AND E.school_ID='GMU';

/*1. Print the names of users who have no connection in the network.*/
SELECT P.first_name,P.last_name 
FROM  Person P 
WHERE P.PID NOT IN( Select C.PID
                    From Connection C);

                
/*2.Find the names of users who are 2nd degree connections of dsmith.*/
SELECT P.first_name, P.last_name 
FROM Person P 
WHERE P.PID   IN ((SELECT C.PID 
                FROM Connection C
                WHERE C.Friend_PID  IN  (SELECT C.PID
                                        FROM Connection C
                                        WHERE C.Friend_PID='dsmith') AND P.PID!='dsmith')
                                        minus
                                        SELECT C.PID
                                        FROM Connection C
                                        WHERE C.Friend_PID='dsmith');
                                                            
        
/*3.	Print the name of the oldest user.*/
SELECT P.first_name,P.last_name
FROM Person P
WHERE P.age = ( SELECT MAX(P2.age)
                FROM Person  P2 );
                

 /*4.Find the names of users who have worked at all branches of company �ABC Software.� 
*/                                                           
SELECT P.first_name, P.last_name
FROM Person P,(SELECT C.company_ID FROM Company C WHERE C.company_name='ABC Software') Temp
WHERE NOT EXISTS((SELECT B.company_ID,B.branch_num
                   FROM Branch B
                   WHERE B.company_ID = Temp.company_ID )
                   MINUS
                   (SELECT W.company_ID,W.branch_num
                   FROM WorksAt W
                   WHERE P.PID=W.PID 
                   AND  W.company_ID=Temp.company_ID  ));     
                   
                  
                   
/*5.For each user in the network, print all his/her work experience(s) (including company name(s) and branch number(s)). 
If a user does not have any work experience, print null.*/
SELECT P.first_name, P.last_name, C.company_name, W.branch_num 
FROM Person P LEFT JOIN ( Company C NATURAL JOIN WorksAt W) 
                        on P.PID=W.PID;


/*6.For users who have at least 3 connections in the network,
print their PIDs, names, and the numbers of connections they have.*/
SELECT *
FROM (SELECT P.PID,P.first_name,P.last_name 
      FROM person p) NATURAL JOIN (
                        SELECT P.PID, COUNT(*) AS "Number of Connections"
                        FROM Person P INNER JOIN Connection C ON c.PID = p.PID
                        GROUP BY P.PID
                        HAVING COUNT(C.PID) > 2 ) ;

/*7.	Write a trigger �employeeCount� that keeps track of the number of employees for each company branch.
The trigger should update the appropriate num_employee attribute value in the Branch table
whenever a WorksAt tuple is inserted or updated.*/

CREATE OR REPLACE TRIGGER employeeCount
  FOR INSERT OR UPDATE OR DELETE ON WorksAt
    COMPOUND TRIGGER
  -- Global declaration.
    newCID VARCHAR2(10);
    newBN INTEGER;
    OldCID VARCHAR2(10);
    OldBN INTEGER;
  
  AFTER EACH ROW IS
  BEGIN 
      newCID:=:new.company_ID;
      newBN:=:new.branch_num;
      oldCID:=:old.company_ID;
      oldBN:=:old.branch_num;
  END after EACH ROW;
  
  AFTER STATEMENT IS
  BEGIN   
        if inserting then
            UPDATE Branch B SET (num_employee)=num_employee+1  WHERE B.company_ID=newCID AND B.branch_num=newBN;
        end if;    
        if updating then 
            UPDATE Branch B SET (num_employee)=num_employee+1  WHERE B.company_ID=newCID AND B.branch_num=newBN;
            UPDATE Branch B SET (num_employee)=num_employee-1  WHERE B.company_ID=oldCID AND B.branch_num=oldBN;
        end if;
        if deleting then
            UPDATE Branch B SET (num_employee)=num_employee-1  WHERE B.company_ID=oldCID AND B.branch_num=oldBN;
        end if;
  END AFTER STATEMENT;
  
END employeeCount; 
/


