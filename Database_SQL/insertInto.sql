--		SEQUENCES:
CREATE SEQUENCE accId
MINVALUE 500
MAXVALUE 599
INCREMENT BY 1;

CREATE SEQUENCE actId
MINVALUE 700
MAXVALUE 799
INCREMENT BY 1;

CREATE SEQUENCE foodId
MINVALUE 600
MAXVALUE 699
INCREMENT BY 1;

CREATE SEQUENCE cmpId
MINVALUE 100
MAXVALUE 199
INCREMENT BY 1;

-- customer id seq
CREATE SEQUENCE cusId
MINVALUE 200
MAXVALUE 299
INCREMENT BY 1;

-- employee id seq
CREATE SEQUENCE empId
MINVALUE 300
MAXVALUE 399
INCREMENT BY 1;

--		TRIGGERS:
-- ACCOMODATION EKLEME:
CREATE TRIGGER ADD_ACCO
AFTER INSERT
ON ACCOMODATION
FOR EACH ROW EXECUTE PROCEDURE INSERT_ACCOMODATION();
-- ACCOMODATION EKLENDIGINDE KAPASITE VE ACCOMODATION NUMBER ARTISI:
CREATE TRIGGER ADD_ACCO2
AFTER INSERT
ON ACCOMODATION
FOR EACH ROW EXECUTE PROCEDURE UPDATE_CAPPACITY_ACCONUM();

INSERT INTO camp VALUES
 	(nextval('cmpId'), 'Peace Camp', 'Edirne', 'Camping Co.', 0, 0, 2, 150),
    (nextval('cmpId'), 'Paradise Camp', 'Balikesir', 'Camping Co.', 0, 0, 2, 200),
    (nextval('cmpId'), 'Miracle Camp', 'Canakkale', 'Surfers Co.', 0, 0, 2, 300),
    (nextval('cmpId'), 'Music Festival', 'Kesan', 'Vodafone', 0, 0, 2, 500),
    (nextval('cmpId'), 'Heaven Camp', 'Dikili', 'Camping Co.', 0, 0, 2, 700),
    (nextval('cmpId'), 'Miracle Camp', 'Antalya', 'Mint Co.', 0, 0, 2, 600),
    (nextval('cmpId'), 'Drone Festival', 'Mugla', 'Uslu Co.', 0, 0, 2, 400),
    (nextval('cmpId'), 'Film Festival', 'Sile', 'Paribu',0, 0, 2, 400),
    (nextval('cmpId'), 'Marschmellow Camp', 'Aydin', 'Marschmellow Co.', 0, 0, 2, 200),
    (nextval('cmpId'), 'Wind Surf Camp', 'Alacati', 'Surfers Co.', 0, 0, 2, 800),
    (nextval('cmpId'), 'Orange Fest', 'Adana', 'Orange Co.', 0, 0, 2, 200);
    
	
INSERT INTO accomodation VALUES
    ('101', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('101', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('101', nextval('accId'), NULL, 'C', 'Forest', 2),
    ('101', nextval('accId'), NULL, 'C', 'Forest', 5),
    ('102', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('102', nextval('accId'), NULL, 'C', 'Sea',    2),
    ('102', nextval('accId'), NULL, 'C', 'Sea',    3),
    ('102', nextval('accId'), NULL, 'C', 'Sea',    2),
    ('103', nextval('accId'), NULL, 'C', 'Forest', 3),
    ('103', nextval('accId'), NULL, 'C', 'Sea',    3),
    ('103', nextval('accId'), NULL, 'C', 'Forest', 2),
    ('103', nextval('accId'), NULL, 'C', 'Forest', 3),
    ('103', nextval('accId'), NULL, 'C', 'Forest', 5),
    ('104', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('104', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('104', nextval('accId'), NULL, 'C', 'Forest', 2),
    ('104', nextval('accId'), NULL, 'C', 'Forest', 5),
    ('105', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('105', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('105', nextval('accId'), NULL, 'C', 'Forest', 2),
    ('105', nextval('accId'), NULL, 'C', 'Forest', 5),
    ('106', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('106', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('106', nextval('accId'), NULL, 'C', 'Forest', 2),
    ('106', nextval('accId'), NULL, 'C', 'Forest', 5),
    ('107', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('107', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('107', nextval('accId'), NULL, 'C', 'Forest', 2),
    ('107', nextval('accId'), NULL, 'C', 'Forest', 5),
    ('108', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('108', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('108', nextval('accId'), NULL, 'C', 'Forest', 2),
    ('108', nextval('accId'), NULL, 'C', 'Forest', 5),
    ('109', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('109', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('109', nextval('accId'), NULL, 'C', 'Forest', 2),
    ('109', nextval('accId'), NULL, 'C', 'Forest', 5),
    ('110', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('110', nextval('accId'), NULL, 'T', 'Forest', 3),
    ('110', nextval('accId'), NULL, 'C', 'Forest', 2),
    ('110', nextval('accId'), NULL, 'C', 'Forest', 5);

INSERT INTO services VALUES
    ('101', nextVal('foodId'), 30),
    ('102', nextVal('foodId'), 20),
    ('103', nextVal('foodId'), 30),
    ('101', nextVal('foodId'), 0),
    ('102', nextVal('foodId'), 30),
    ('103', nextVal('foodId'), 20),
    ('104', nextVal('foodId'), 30),
    ('105', nextVal('foodId'), 0),
    ('106', nextVal('foodId'), 30),
    ('107', nextVal('foodId'), 20),
    ('101', nextVal('actId'), 5),
    ('102', nextVal('actId'), 10),
    ('102', nextVal('actId'), 10),
    ('103', nextVal('actId'), 0),
    ('103', nextVal('actId'), 20),
    ('103', nextVal('actId'), 5),
    ('104', nextVal('actId'), 5),
    ('105', nextVal('actId'), 20),
    ('106', nextVal('actId'), 5),
    ('107', nextVal('actId'), 5);
	
INSERT INTO food VALUES
    ('600', 'Marschmellow', 'Snack', 100),
    ('601', 'Water', 'Soft Drink', 100),
    ('602', 'Egg', 'Breakfast', 100),
    ('603', 'Chocolate', 'Snack', 100),
    ('604', 'Mineral Water', 'Soft Drink', 100),
    ('605', 'Beer', 'Alcohol', 100),
    ('606', 'Cheese', 'Breakfast', 100),
    ('607', 'Tomatoes', 'Breakfast', 100),
    ('608', 'Cucamber', 'Breakfast', 100),
    ('609', 'Chicken Sandwich', 'Lunch', 100);


INSERT INTO activity VALUES
    ('700', 'Marschmellow By Campfire', 'Group Activity', 3, 50, 50),
    ('701', 'Tracking', 'Group Activity', 0, 50, 20),
    ('702', 'Grilling', 'Group Activity', 13, 24, 18),
    ('703', 'Horror Story By Campfire', 'Group Activity', 15, 15, 10),
    ('704', 'Diving', 'Group Activity', 3, 10, 10),
    ('705', 'Beach Volleyball', 'Team Activity', 13, 30, 20),
    ('706', 'Surfing', 'Group Activity', 10, 12, 12),
    ('707', 'Singing With Guitar', 'Group Activity', 3, 10, 10),
    ('708', 'scouting', 'Team Activity', 13, 30, 20),
    ('709', 'Food Gathering', 'Group Activity', 10, 12, 12);

INSERT INTO person VALUES
    ('101', nextval('cusId'), 'Jason', 'Kidd', '12345678201', 'M', '05555555201', NULL, '1993-09-10'),
    ('101', nextval('cusId'), 'Stephen', 'Jackson', '12345678202', 'M', '05555555202', NULL, '2003-07-13'),
    ('101', nextval('cusId'), 'Marrie', 'Currie', '12345678203', 'F', '05555555203', NULL, '1983-01-02'),
    ('102', nextval('cusId'), 'Courtney', 'Cox', '12345678204', 'F', '05555555204', NULL, '1993-07-19'),
    ('102', nextval('cusId'), 'Barack', 'Obama', '12345678205', 'M', '05555555205', NULL, '1993-08-08'),
    ('102', nextval('cusId'), 'Aziz', 'Nesin', '12345678206', 'M', '05555555206', NULL, '1993-09-14'),
    ('101', nextval('empId'), 'Marschal', 'Mathers', '12345678300', 'M', '05555555300', NULL, '1993-07-11'),
    ('101', nextval('empId'), 'Sebnem', 'Ferah', '12345678301', 'F', '05555555301', NULL, '2003-12-12'),
    ('101', nextval('empId'), 'Will', 'Smith', '12345678302', 'M', '05555555302', NULL, '1983-10-27'),
    ('102', nextval('empId'), 'Stephen', 'King', '12345678303', 'M', '05555555303', NULL, '1993-04-25'),
    ('102', nextval('empId'), 'Donald', 'Trump', '12345678304', 'M', '05555555304', NULL, '1993-02-17'),
    ('103', nextval('empId'), 'Jennifer', 'Aniston', '12345678305', 'F', '05555555305', NULL, '1993-05-10'),
    ('103', nextval('empId'), 'Eve', 'Cole', '12345678306', 'F', '05555555306', NULL, '1998-07-07'),
    ('104', nextval('empId'), 'Math', 'Jackson', '12345678307', 'M', '05555555307', NULL, '1987-06-12'),
    ('105', nextval('empId'), 'Annabeth', 'Chase', '12345678308', 'F', '05555555308', NULL, '1981-01-10'),
	('104', nextval('empId'), 'Anny', 'Chase', '12345678708', 'F', '05555545308', NULL, '1991-02-10'),
    ('102', nextval('cusId'), 'Tom', 'Holland', '12345678207', 'M', '05555555207', NULL, '1991-04-18'),
    ('102', nextval('cusId'), 'David', 'Jackson', '12345678208', 'M', '05555555208', NULL, '1993-05-10'),
	('103', nextval('cusId'), 'David', 'John', '12345678218', 'M', '05555555208', NULL, '1996-05-10'),
	('104', nextval('cusId'), 'Dave', 'John', '12345778218', 'M', '05555575208', NULL, '1996-05-17'),
    ('103', nextval('cusId'), 'Suzan', 'Collins', '12345678309', 'F', '05555555309', NULL, '2000-05-10'),
	('103', nextval('cusId'), 'Sarah', 'Jackson', '12395678218', 'F', '05555555208', NULL, '2006-05-10'),
	('103', nextval('cusId'), 'Jerry', 'Morty', '12345779818', 'M', '05555575208', NULL, '1996-07-17'),
	('104', nextval('cusId'), 'Beth', 'Morty', '11345779818', 'F', '05555575208', NULL, '1988-06-27'),
	('106', nextval('empId'), 'Luke', 'Chase', '12341278308', 'M', '05555755308', NULL, '1991-01-17'),
	('107', nextval('empId'), 'Cara', 'Devigne', '12356678308', 'F', '05555555308', NULL, '1989-08-10'),
	('108', nextval('empId'), 'David', 'Sea', '12345677708', 'M', '05555555308', NULL, '1999-04-10'),
	('109', nextval('empId'), 'Allie', 'Chuck', '10045678308', 'F', '05555555308', NULL, '1998-07-11'),
	('110', nextval('empId'), 'Ann', 'Luck', '12349878308', 'F', '05555555308', NULL, '1971-02-20'),
	('101', nextval('cusId'), 'Bethie', 'Johanson', '11245779800', 'M', '05555575208', NULL, '1997-06-23');

INSERT INTO customer VALUES
    ('200', '500', '2023-05-08', '2023-05-20',  3350.4),
    ('201', '501', '2023-05-05', '2023-05-15',  1396.0),
    ('202', '501', '2023-05-05', '2023-05-15',  1396.0),
    ('203', '506', '2023-05-03', '2023-05-10',  1503.6),
    ('204', '506', '2023-05-03', '2023-05-10',  1503.6),
    ('205', '504', '2023-06-03', '2023-06-10',  2931.6),
    ('206', '507', '2023-06-07', '2023-06-12',   996.0),
    ('207', '507', '2023-06-07', '2023-06-12',   996.0),
    ('208', '508', '2023-01-01', '2023-01-06',  3490.0),
    ('209', '513', '2023-03-01', '2023-03-06',  4886.0),
    ('210', '509', '2023-01-01', '2023-01-17', 11456.0),
    ('211', '510', '2023-01-01', '2023-01-18',  4886.0),
    ('212', '510', '2023-01-01', '2023-01-18',  5372.0),
    ('213', '515', '2023-07-01', '2023-07-20', 16811.2),
    ('214', '501', '2023-08-08', '2023-08-16',  2233.6);
	
INSERT INTO employee VALUES
    ('300', '503', 9000, 'D'),
    ('301', '503', 9500, 'D'),
    ('302', '503', 9900, 'N'),
    ('303', NULL, 8000, 'N'),
    ('304', NULL, 9700, 'D'),
    ('305', NULL, 7800, 'N'),
    ('306', '512', 9600, 'N'),
    ('307', '512', 8550, 'D'),
    ('308', '512', 9800, 'N'),
	('309', NULL , 9600, 'N'),
	('310', NULL , 7900, 'N'),
	('311', NULL , 6900, 'N'),
	('312', NULL , 9870, 'N'),
	('313', NULL , 8600, 'N'),
	('314', '540' , 8850, 'N');
	
INSERT INTO reservation VALUES
	('500', '2023-05-08', '2023-05-20'),
	('501', '2023-05-05', '2023-05-15'),
	('506', '2023-05-03', '2023-05-10'),
	('504', '2023-06-03', '2023-06-10'),
	('507', '2023-06-07', '2023-06-12'),
	('508', '2023-01-01', '2023-01-06'),
	('509', '2023-01-01', '2023-01-17'),
	('513', '2023-03-01', '2023-03-06'),
	('510', '2023-01-01', '2023-01-18'),
	('515', '2023-07-01', '2023-07-20'),
	('503', '2023-01-01', '2024-01-01'),
	('540', '2023-01-01', '2024-01-01'),
	('512', '2023-01-01', '2024-01-01'),
	('501', '2023-08-08', '2023-08-16');
	
--		VIEWS:
-- SHOW VIEWS:
CREATE OR REPLACE VIEW SHOW_CAMP AS
	SELECT * FROM camp;
	
CREATE OR REPLACE VIEW SHOW_PERSON AS
	SELECT * FROM PERSON;
	
CREATE OR REPLACE VIEW SHOW_PERSON AS
	SELECT * FROM PERSON;
	
CREATE OR REPLACE VIEW SHOW_CUSTOMER AS
	SELECT * FROM CUSTOMER;
	
CREATE OR REPLACE VIEW SHOW_EMPLOYEE AS
	SELECT * FROM EMPLOYEE;
	
CREATE OR REPLACE VIEW SHOW_ACCOMODATION AS
	SELECT * FROM ACCOMODATION;
	
CREATE OR REPLACE VIEW SHOW_SERVICES AS
	SELECT * FROM SERVICES;
	
CREATE OR REPLACE VIEW SHOW_RESERVATION AS
	SELECT * FROM RESERVATION;
	
CREATE OR REPLACE VIEW SHOW_ACTIVITY AS
	SELECT * FROM ACTIVITY;
	
CREATE OR REPLACE VIEW SHOW_FOOD AS
	SELECT * FROM FOOD;
	
-- UNRESERVATED ACCOMODATIONS
CREATE OR REPLACE VIEW UNRESERVATED AS
	SELECT ac.accomodationId, ac.capacity
	FROM accomodation AS ac
	WHERE ac.accomodationId NOT IN (SELECT r.accomodationId FROM reservation AS r);
	
-- RESERVATED ACCOMODATIONS 
CREATE OR REPLACE VIEW RESERVATED AS 
	SELECT DISTINCT accomodationId
	FROM reservation;

 --FIND_NULL_AGE_PERSONIDS
CREATE OR REPLACE VIEW FIND_NULL_AGE_PERSONIDS AS
	SELECT personid
	FROM person
	EXCEPT
	SELECT personid
	FROM person
	WHERE age>0;

-- CALCULATE AGES AND UPDATE 
UPDATE person
SET age=CAST(extract(YEAR FROM age(birthDate)) AS smallint)
WHERE personid IN (select * from FIND_NULL_AGE_PERSONIDS);
	
	

