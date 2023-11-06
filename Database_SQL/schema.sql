
DROP TABLE IF EXISTS food CASCADE;
DROP TABLE IF EXISTS activity CASCADE;
DROP TABLE IF EXISTS services CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS accomodation CASCADE;
DROP table IF EXISTS camp CASCADE;
DROP TABLE IF EXISTS reservation CASCADE;
DROP SEQUENCE IF EXISTS accId CASCADE;
DROP SEQUENCE IF EXISTS actId CASCADE;
DROP SEQUENCE IF EXISTS foodId CASCADE;
DROP SEQUENCE IF EXISTS cmpId CASCADE;
DROP SEQUENCE IF EXISTS cusId CASCADE;
DROP SEQUENCE IF EXISTS empId CASCADE;


-- camp table
--DROP table camp;
CREATE TABLE camp (
	campId char(3),
	campName varchar(30) not null,
	campLocation varchar(50) not null,
	campOwnerName varchar(30),
	capacity smallint,
	accomodationNumber smallint,
	serviceNumber smallint,
	minAccomodationCost numeric,
	primary key (campId),
	unique(campLocation,campName)
);

-- accomodation table
--DROP TABLE accomodation;
CREATE TABLE accomodation(
	campId char(3) not null,
	accomodationId char(3),
	dailyCost numeric(7,1),
	accomodationType char(1),
	accomodationLocation varchar(20) not null,
	capacity smallint not null,
	primary key(accomodationId),
	foreign key(campId) references camp(campId)
);

-- person table
--DROP TABLE person;
CREATE TABLE person(
	campId char(3) not null,
	personId char(3),
	firstName varchar(15) not null,
	lastName varchar(15) not null,
	personalId char(11) not null,
	gender char(1) not null,
	phoneNumber char(11),
	age smallint,
	birthDate date not null,
	primary key(personId),
	foreign key(campId) references camp(campId),
	unique(personalId)
);

-- employee table
--DROP TABLE employee;
CREATE TABLE employee(
	personId char(3) not null,
	accomodationId char(3),
	salary numeric(7,1) not null,
	shift char(1) not null,
	primary key(personId),
	foreign key(personId) references person(personId),
	foreign key(accomodationId) references accomodation(accomodationId)
);

-- customer table
-- DROP TABLE customer;
CREATE TABLE customer(
	personId char(3) not null,
	accomodationId char(3) not null,
	arrivalDate date not null,
	terminationDate date not null,
	payment numeric(7,1),
	primary key(personId),
	foreign key(personId) references person(personId),
	foreign key(accomodationId) references accomodation(accomodationId)
);


-- services table
-- DROP TABLE services;
CREATE TABLE services(
	campId char(3) not null,
	servicesId char(3),
	serviceCost int,
	primary key(servicesId),
	foreign key(campId) references camp(campId)
);

-- activity table
-- DROP TABLE activity
CREATE TABLE activity(
	servicesId char(3),
	activityName varchar(50),
	category varchar(50),
	ageLimit smallint,
	maximumAttendents smallint,
	currentAttendents smallint,
	primary key(activityName),
	CONSTRAINT FK_activity FOREIGN KEY (servicesId) REFERENCES services(servicesId) ON DELETE CASCADE,
	CONSTRAINT ageLimit_CK CHECK (ageLimit<18)
);

-- food table
-- DROP TABLE food;
CREATE TABLE food(
	servicesId char(3) not null,
	foodName varchar(50) not null,
	category varchar(50) not null,
	foodNumber int,
	primary key(foodName),
	CONSTRAINT FK_food FOREIGN KEY (servicesId) REFERENCES services (servicesId) ON DELETE CASCADE
);

--rezervation table
-- DROP TABLE reservation;
CREATE TABLE reservation(
	accomodationId char(3),
	startingDate date,
	endDate date,
	foreign key(accomodationId) references accomodation(accomodationId)
);

