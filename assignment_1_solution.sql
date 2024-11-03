-- EX1
-- Table: driver
CREATE TABLE driver
  (
     driverid INT PRIMARY KEY,
     NAME     VARCHAR(50),
     address  VARCHAR(100)
  );

-- Table: logisticsCompany
CREATE TABLE logisticscompany
  (
     companyname VARCHAR(50) PRIMARY KEY,
     phonenumber VARCHAR(20),
     address     VARCHAR(100)
  );

-- Table: vehicle
CREATE TABLE vehicle
  (
     licenseplatenumber VARCHAR(20) PRIMARY KEY,
     companyname        VARCHAR(50),
     FOREIGN KEY (companyname) REFERENCES logisticscompany(companyname)
  );

-- Table: transport
CREATE TABLE transport
  (
     transportid INT PRIMARY KEY,
     departure   DATE,
     arrival     DATE
  );

-- Table: responsibleFor (relation between driver and transport)
CREATE TABLE responsiblefor
  (
     driverid    INT,
     transportid INT,
     PRIMARY KEY (driverid, transportid),
     FOREIGN KEY (driverid) REFERENCES driver(driverid),
     FOREIGN KEY (transportid) REFERENCES transport(transportid)
  );

-- Table: involvedIn (relation between transport and vehicle)
CREATE TABLE involvedin
  (
     transportid        INT,
     licenseplatenumber VARCHAR(20),
     PRIMARY KEY (transportid, licenseplatenumber),
     FOREIGN KEY (transportid) REFERENCES transport(transportid),
     FOREIGN KEY (licenseplatenumber) REFERENCES vehicle(licenseplatenumber)
  );

-- Table: worksFor (many-to-many relation between driver and logisticsCompany)
CREATE TABLE worksfor
  (
     driverid    INT,
     companyname VARCHAR(50),
     salary      DECIMAL(10, 2),
     PRIMARY KEY (driverid, companyname),
     FOREIGN KEY (driverid) REFERENCES driver(driverid),
     FOREIGN KEY (companyname) REFERENCES logisticscompany(companyname)
  );

-- Table: partner (self-relation for drivers)
CREATE TABLE partner
  (
     driverid1 INT,
     driverid2 INT,
     PRIMARY KEY (driverid1, driverid2),
     FOREIGN KEY (driverid1) REFERENCES driver(driverid),
     FOREIGN KEY (driverid2) REFERENCES driver(driverid),
     CHECK (driverid1 < driverid2)
  -- Prevents duplicate records
  );

-- Ex3
-- Table: student
CREATE TABLE student
  (
     sid       INT PRIMARY KEY,
     firstname VARCHAR(50),
     lastname  VARCHAR(50),
     semester  INT,
     birthdate DATE
  );

-- Table: tutor
CREATE TABLE tutor
  (
     tid       INT PRIMARY KEY,
     firstname VARCHAR(50),
     lastname  VARCHAR(50),
     issenior  BOOLEAN
  );

-- Table: studygroup
CREATE TABLE studygroup
  (
     gid       INT PRIMARY KEY,
     tid       INT,
     weekday   VARCHAR(10),
     room      VARCHAR(20),
     starttime DATE,
     FOREIGN KEY (tid) REFERENCES tutor(tid)
  );

-- Table: exercisesheet
CREATE TABLE exercisesheet
  (
     eid       INT PRIMARY KEY,
     maxpoints INT
  );

-- Table: handsin (relation between student and exercisesheet)
CREATE TABLE handsin
  (
     sid            INT,
     eid            INT,
     achievedpoints INT,
     PRIMARY KEY (sid, eid),
     FOREIGN KEY (sid) REFERENCES student(sid),
     FOREIGN KEY (eid) REFERENCES exercisesheet(eid)
  );

-- Table: member (relation between student and studygroup)
CREATE TABLE member
  (
     sid INT,
     gid INT,
     PRIMARY KEY (sid, gid),
     FOREIGN KEY (sid) REFERENCES student(sid),
     FOREIGN KEY (gid) REFERENCES studygroup(gid)
  );

-- Ex4
-- Query 1: IDs of all students achieved at least 10 points eid = 1
SELECT sid
FROM   handsin
WHERE  eid = 1
       AND achievedpoints >= 10;

-- Query 2: ID and last name studygroup meets on Mondays
SELECT student.sid,
       student.lastname
FROM   student
       JOIN member
         ON student.sid = member.sid
       JOIN studygroup
         ON member.gid = studygroup.gid
WHERE  studygroup.weekday = 'Monday';

-- Query 3: For each exercise sheet, determine its ID and the average achieved number of points
SELECT eid,
       Avg(achievedpoints) AS avg_points
FROM   handsin
GROUP  BY eid;

-- Query 4:IDs of all students achieved between 1 and 5 points for at least 3 exercise sheets
SELECT sid
FROM   handsin
WHERE  achievedpoints BETWEEN 1 AND 5
GROUP  BY sid
HAVING Count(DISTINCT eid) >= 3;