-- INSERT EMPLOYEE
CREATE OR REPLACE FUNCTION INSERT_EMPLOYEE(campId CHAR(3), 
										firstName varchar(15),
										lastName varchar(15),
										personalId char(11),
										gender char(1),
										phoneNumber char(11),
										birthDate date, 
										accomodationId char(3),
										salary numeric(6,2),
										shift char(1))
RETURNS VOID AS $$
DECLARE
ages smallint;
perId char(3);
curYear DATE;
nextYear DATE;
BEGIN
	ages := CAST(extract(YEAR FROM age(birthDate)) AS smallint);
	
	IF ages < 18 THEN
		RAISE NOTICE '18 YASINDAN KUCUKLER ISE ALINAMAZ';
	ELSE
		perId = nextval('empId');
		INSERT INTO person VALUES(campId, perId, firstName, lastName, personalId, gender, phoneNumber, ages, birthDate);
		IF accomodationId = '000' THEN
			INSERT INTO employee VALUES(perId, NULL, salary, shift);
		ELSE
			INSERT INTO employee VALUES(perId, accomodationId, salary, shift);
			IF(IS_RESERVATED(accomodationId) = 0) THEN
				SELECT current_date INTO curYear;
				SELECT curYear + INTERVAL '1 year' INTO nextYear;
				INSERT INTO reservation VALUES(accomodationId, curYear, nextYear);
			END IF;
		END IF;
	END IF;
END;
$$ LANGUAGE PLPGSQL;
--ORN: SELECT INSERT_EMPLOYEE('109', 'Jason', 'Kent', '12345678810', 'M', '05555555210', '1993-09-10', '535', 9400.00, 'D')

-- EMPLOYEE ICIN KALACAK YER BULMA
--DROP TYPE ACCOMODATIONS;
--DROP FUNCTION FIND_ACCOMODATION(CHAR(3));
CREATE TYPE ACCOMODATIONS AS(accomodationId CHAR(3), capacity SMALLINT);

CREATE OR REPLACE FUNCTION FIND_ACCOMODATION(cmpId CHAR(3))
RETURNS ACCOMODATIONS[] AS $$
DECLARE

CUR CURSOR	FOR SELECT accomodationId, COUNT(*)
				FROM employee
				WHERE accomodationId >= '500'
				GROUP BY accomodationId;
				
CUR_TEMP CURSOR	FOR SELECT ur.accomodationId, ur.capacity
					FROM UNRESERVATED AS ur
					WHERE cmpId = (SELECT campId FROM accomodation AS ac WHERE ur.accomodationId = ac.accomodationId);
acmID CHAR(3);
tmpCampId CHAR(3);
CAP SMALLINT;
RES ACCOMODATIONS[];
J INTEGER;
L INTEGER;				
BEGIN
	J = 1;
	FOR I IN CUR LOOP
		RAISE NOTICE '% % ', I.ACCOMODATIONID, I.COUNT;
		acmID = I.ACCOMODATIONID;
		SELECT campId INTO tmpCampId FROM accomodation WHERE acmID = accomodationId;
		IF tmpCampId = cmpId THEN
			SELECT CAPACITY INTO CAP
			FROM ACCOMODATION
			WHERE acmID = accomodationId;

			IF CAP > I.COUNT THEN
				RES[J] = I;
				J = J + 1;
			END IF;
		END IF;
	END LOOP;
	IF J = 1 THEN
		L = 1;
		FOR X IN CUR_TEMP LOOP
			RES[L] = X;
			L = L + 1;
		END LOOP;	
	END IF;
	RETURN RES;
END;
$$ LANGUAGE PLPGSQL;

--ORN: SELECT FIND_ACCOMODATION('103');

-- RESERVATED VIEW'I KULLANILARAK ISTENEN ACCOMODATION RESERVATION TABLOSUNDA OLUP OLMADIGINI BULAN FONKSIYON:
CREATE OR REPLACE FUNCTION IS_RESERVATED(accoId CHAR(3))
RETURNS INTEGER AS $$
DECLARE
res INTEGER;
BEGIN
	SELECT COUNT(*) INTO res
	FROM reservated
	WHERE accoId = accomodationId;
	RETURN res;
END;
$$ LANGUAGE PLPGSQL;

--ORN: SELECT IS_RESERVATED('520');

-- DELETE CUSTOMER
CREATE OR REPLACE FUNCTION DELETE_CUSTOMER(prsnalId CHAR(11)) 
RETURNS INTEGER AS $$
DECLARE
custId CHAR(3);
tdate date;
acm char(3);
datedif INTEGER;

BEGIN
    SELECT personId INTO custId FROM person WHERE personalId =prsnalId;
    SELECT terminationDate, accomodationId INTO tdate, acm
    FROM customer
    WHERE custId = personId;
    RAISE NOTICE 'TERMINATION DATE: % CURRENT : %', tdate, CURRENT_TIMESTAMP;

    datedif = DATE_PART('day',  CURRENT_TIMESTAMP - tdate);
     IF datedif = 0 THEN
        DELETE FROM reservation WHERE acm = accomodationId AND endDate = tdate ;
        DELETE FROM customer WHERE custId = personId;
        DELETE FROM person WHERE custId = personId;
        RAISE NOTICE 'Customers accomodation time has ended and deleted';
        RETURN 1;
    END IF;
    RAISE NOTICE 'Customer still has % days until reservation termination.Cant delete. Try to cancel reservation', datedif;
    RETURN 0;
END;
$$ LANGUAGE PLPGSQL;

--ORN: SELECT DELETE_CUSTOMER('12345678309');

-- ACCOMODATION EKLEME:
CREATE OR REPLACE FUNCTION INSERT_ACCOMODATION()
RETURNS TRIGGER AS $$
DECLARE 
cmpId CHAR(3);
minCost NUMERIC;
cap NUMERIC;
sea NUMERIC(2,1) := 1.2;
forest NUMERIC(2,1) := 1.1;
tent NUMERIC(2,1) := 1.2;
caravan NUMERIC(2,1) := 1.2;

BEGIN
	cmpId = NEW.campId;
	cap = NEW.capacity;
	NEW.dailyCost = 0;
	SELECT minAccomodationCost INTO minCost 
	FROM camp
	WHERE cmpId = campId;
	IF NEW.accomodationLocation = 'Sea' AND NEW.accomodationType = 'T' THEN
		NEW.dailyCost  = minCost + (minCost * sea * tent * (cap / 10));
	ELSIF NEW.accomodationLocation = 'Sea' AND NEW.accomodationType = 'C' THEN
		NEW.dailyCost = minCost +  (minCost * sea * caravan * (cap / 10));
	ELSIF NEW.accomodationLocation = 'Forest' AND NEW.accomodationType = 'T' THEN
		NEW.dailyCost = minCost +  (minCost * forest * tent * (cap / 10));
	ELSIF NEW.accomodationLocation = 'Forest' AND NEW.accomodationType = 'C' THEN
		NEW.dailyCost = minCost +  (minCost * forest * caravan * (cap / 10));
	END IF;
	UPDATE accomodation SET dailyCost = new.dailyCost WHERE accomodationId = NEW.accomodationId;

	RAISE NOTICE 'Trigger calculated daily cost as % before insertion', NEW.dailyCost;
	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

-- ORN: INSERT INTO accomodation VALUES ('103', '527', 'E', NULL, 'T', 'Sea', 3, NULL, NULL);
--SELECT * FROM ACCOMODATION;

-- ACCOMODATION EKLENDIGINDE KAPASITE VE ACCOMODATION NUMBER ARTISI:
CREATE OR REPLACE FUNCTION UPDATE_CAPPACITY_ACCONUM()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE camp
	SET capacity = capacity + NEW.capacity
	WHERE campId = NEW.campId;
	
	UPDATE camp
	SET accomodationNumber = accomodationNumber + 1
	WHERE campId = NEW.campId;
	RAISE NOTICE 'Capacity and accomodation number is increased';
	RETURN NEW;
END;
$$ LANGUAGE PLPGSQL;

-- EMPLOYEE MAAS ARTISI
--DROP FUNCTION UPDATE_SALARY(numeric, numeric);
CREATE OR REPLACE FUNCTION UPDATE_SALARY(minSalary numeric, raiseSal numeric)
RETURNS VOID AS $$
BEGIN
	UPDATE employee 
	SET salary = CAST(salary + salary * (raiseSal / 100) AS NUMERIC)
	WHERE personId IN (SELECT e1.personId FROM employee as e1 GROUP BY e1.personId HAVING MIN(salary) <= minSalary);
END;
$$ LANGUAGE PLPGSQL;

--ORN: SELECT UPDATE_SALARY(9500, 10);

-- AKTIVITELERE KISI EKLEME
--DROP FUNCTION ADD_CUSTOMER_TO_ACTIVITY(CHAR(3),CHAR(3));
CREATE OR REPLACE FUNCTION ADD_CUSTOMER_TO_ACTIVITY(prsnalId CHAR(3), servId CHAR(3))
RETURNS VOID AS $$
DECLARE 
cusId CHAR(3);
accost SMALLINT;
BEGIN
		SELECT personId INTO cusId FROM person WHERE personalId = prsnalId;
		SELECT serviceCost INTO accost FROM services WHERE servId = servicesId;
        UPDATE activity SET currentAttendents = currentAttendents + 1 WHERE servId = servicesId;
		UPDATE customer SET payment = payment + accost WHERE cusId = personId; 
        RAISE NOTICE 'EKLEME YAPILDI';
END;
$$ LANGUAGE PLPGSQL;

--ORN: SELECT ADD_CUSTOMER_TO_ACTIVITY('200','700');

-- RANDEVU IPTALI
--DROP TYPE CANCELED_CUSTOMERS
CREATE TYPE CANCELED_CUSTOMERS AS (personId CHAR(3), xarrivalDate DATE, xterminationDate DATE, accomodationId CHAR(3));

CREATE OR REPLACE FUNCTION CANCELATION(prsnalId CHAR(11))
RETURNS INTEGER AS $$
DECLARE
cancelCur CURSOR FOR SELECT personId, arrivalDate, terminationDate, accomodationId FROM customer;
canceledCus CANCELED_CUSTOMERS[];
perId CHAR(3);
cusId CHAR(3);
cusAge SMALLINT;
arr DATE;
ter DATE;
accId CHAR(3);
datediff INTEGER;
J INTEGER;

BEGIN
	SELECT personId INTO perId FROM person WHERE personalId = prsnalId;
	SELECT age INTO cusAge FROM person WHERE perId = personId;
	
	IF cusAge < 18 THEN
		RAISE NOTICE'18 yasından kucuk bir kisi randevu iptal edemez.';
		RETURN 0;
	END IF;
	
	SELECT arrivalDate, terminationDate , accomodationId INTO arr, ter, accId
	FROM customer
	WHERE perId = personId;
	
	IF DATE_PART('day', arr - CURRENT_TIMESTAMP) >= 3 THEN
		J = 1;
		FOR I IN cancelCur LOOP
			IF I.accomodationId = accId AND I.arrivalDate = arr AND I.terminationDate = ter THEN
				canceledCus[J] = I;
				J = J + 1;
			END IF;
		END LOOP;
		J = J - 1;
		DELETE FROM reservation WHERE accId = accomodationId AND startingDate = arr AND endDate = ter;
		FOR I IN 1..J LOOP
			cusId = canceledCus[I].personId;
			DELETE FROM customer WHERE cusId = personId;
			DELETE FROM person WHERE cusId = personId;
		END LOOP;

		RAISE NOTICE'REZERVASYON IPTAL EDILDI.';
		RETURN 1;
	ELSE 
		RAISE NOTICE'EN AZ UC GUN KALA REZERVASYON IPTALI YAPILABILIR.';
		RETURN 0;
	END IF;
END;
$$ LANGUAGE PLPGSQL;

--ORN: SELECT CANCELATION('11245779800')

