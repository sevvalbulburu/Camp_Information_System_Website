from flask import Flask, request, render_template
from app.core import *
from app.db_models import *
import psycopg2
from datetime import datetime, date
# from werkzeug.datastructures import ImmutableMultiDict
# from werkzeug import exceptions
from pdb import set_trace

app = Flask(__name__)
conn = 0
cur = 0


@app.route("/", methods=["GET", "POST"])
def entry():
    global cur
    global conn
    # Connect to the database
    conn = psycopg2.connect(
        host="localhost",
        user="postgres",
        password="1234",
        dbname="Camp_db",
        port=5432
    )
    cur = conn.cursor()
    return render_template("entry.html")


@app.route("/employee/", methods=["GET", "POST"])
def employee():
    msg=""
    table_columns = []
    results = []
    takeEmployeeInfo = 0
    accomodations = []
    if request.method == "POST":
        actions = {
            "Addding" : "Add Actiivity",
            "Camp": "Show Table Camp",
            "Accomodation": "Show Table Accomodation",
            "Person": "Show Table Person",
            "Employee": "Show Table Employee",
            "Customer": "Show Table Customer",
            "Services": "Show Table Services",
            "Reservation": "Show Table Reservation",
            "Activity": "Show Table Activity",
            "Food": "Show Table Food",
            "Salary Filter": "Salary Filter",
            "Saalary": "Salary Increase",
            "Take CaampId" : "Take CaampId",
            "capacity" : "Add Acccomodation",
            "salary" : "Add Employee"
        }
        for key, value in actions.items():
            if key in str(request.form):
                msg += value
                break
        # Give action
        set_trace()
        if "Show Table" in msg:
            table_name = msg.split()[-1].upper()
            cur.execute("SELECT * FROM SHOW_{};".format(table_name))
            table_columns += [col.name for col in cur.description]
            results += cur.fetchall()
            msg += " FUNCTION"
        elif msg == 'Salary Filter':
            try:
                minSalary = 0
                maxSalary = 999999
                if request.form['Max Salary'] != '':
                    maxSalary -= maxSalary
                    maxSalary += int(request.form['Max Salary'])
                if request.form['Min Salary'] != '':
                    minSalary += int(request.form['Min Salary'])
                msg = "Salary Filter FUNCTION in range : " + str(minSalary) + " - " + str(maxSalary)

                cur.execute("SELECT * FROM employee WHERE salary BETWEEN {} AND {};".format(minSalary, maxSalary))
                table_columns += [col.name for col in cur.description]
                results += cur.fetchall()
            except ValueError:
                msg = "Enter only integers to filter"
        elif msg == 'Take CaampId':
            msg = request.form['Take CaampId']
            takeEmployeeInfo += 1
            cur.execute("SELECT FIND_ACCOMODATION('{}');".format(request.form['Take CaampId']))
            accomodations_temp = cur.fetchall()
            accomodations += ["".join([x for x in accomodations_temp[0][0].split(',')[i].split(',')[0]  if x.isdigit()]) for i in range(len(accomodations_temp[0][0].split(','))) if i%2==0]
            print(accomodations)
        elif msg == "Add Actiivity":
            cur.execute("INSERT INTO activity VALUES('{}', '{}', '{}', {}, {}, {});".format(
                request.form['servicesId'],	request.form['actiivityName'],	request.form['category'],	int(request.form['ageLimit']),	int(request.form['maximumAttendents']),	int(request.form['currentAttendents'])))
            for i in conn.notices:
                msg += "\n"
                msg += i
        elif msg == 'Add Acccomodation':
            cur.execute("INSERT INTO accomodation VALUES('{}', nextval('accId'), NULL, '{}', '{}', {});".format(
                request.form['campId'], request.form['accomodation type'], request.form['accomodation location'], request.form['capacity']))
            for i in conn.notices:
                msg += "\n"
                msg += i
            conn.commit()
        elif msg == 'Salary Increase':
            cur.execute("SELECT UPDATE_SALARY({}, {})".format(request.form['min_salary'], request.form['increase_percentage']))
            conn.commit()
        elif msg == 'Add Employee':
            msg = "Add Employee FUNCTION"
            
            temp = request.form['accomodation']
            if temp == "no accomodation":
                temp = "000"
            QUERY="SELECT INSERT_EMPLOYEE('{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}', {}, '{}')".format(
                request.form['campId'], request.form['firstName'], request.form['lastName'], request.form['personalId'], request.form['gender'],
                    request.form['phoneNumber'], request.form['birthDate'], temp, request.form['salary'], request.form['shift'])
            cur.execute(QUERY)
            conn.commit()
            for i in conn.notices:
                msg += "\n"
                msg += i

    return render_template("employee.html", column_names=table_columns, table=results, message=msg, takeEmployeeInfo=takeEmployeeInfo, accomodations=accomodations)


@app.route("/customer/", methods=["GET", "POST"])
def customer():
    msg = ""
    table_columns = []
    results = []
    if request.method == "POST":
        actions = {
            "Activities Search": "Activities Search",
            "Add Person to Activity": "Add Person to Activity",
            "delete cuustomer" : "delete cuustomer",
            "Cancel Reservation": "Cancel Reservation"
        }
        for key, value in actions.items():
            if key in str(request.form):
                msg += value
                break

        # Give action
        if msg == 'Activities Search':
            print(type(request.form['personalID']))
            print(request.form['personalID'])
            q = "CREATE OR REPLACE VIEW getAge AS SELECT age FROM person WHERE personalid='{}';".format(request.form['personalID'])
            cur.execute(q)
            conn.commit()
            cur.execute("SELECT A.* FROM activity A, getAge WHERE A.agelimit<age AND A.currentattendents<A.maximumattendents \
                        INTERSECT \
                        SELECT A.* FROM activity A, person P, services S WHERE P.personalid='{}' AND P.campid=S.campid AND S.servicesid=A.servicesid".format(request.form['personalID']))
            table_columns = [col.name for col in cur.description]
            results = cur.fetchall()
            return render_template("customer.html", column_names=table_columns, table=results, message=msg)
        elif msg == "Cancel Reservation":
            msg = "{} person and roommates are deleted, reservation canceled".format(request.form['personalID'])
            cur.execute("SELECT CANCELATION('{}');".format(request.form['personalID']))
            conn.commit()
            msg+=conn.notices[0]
        elif msg == "delete cuustomer":
            cur.execute("SELECT DELETE_CUSTOMER('{}')".format(request.form['delete cuustomer']))
            conn.commit()
            for i in conn.notices:
                msg += "\n"
                msg += i
        elif msg == "Add Person to Activity":
            cur.execute("SELECT ADD_CUSTOMER_TO_ACTIVITY('{}','{}');".format(request.form['personalID'], request.form['activityID']))
            msg=conn.notices[0]
            msg += "\n{} person is added to activity {}".format(request.form['personalID'], request.form['activityID'])

    return render_template("customer.html", column_names=[], table=[], message=msg)

@app.route("/rent/", methods=["GET", "POST"])
def rent():
    msg = ""
    table_columns = []
    results = []
    count = 0
    # get locations from camp table
    cur.execute("SELECT camplocation FROM camp;")
    locations = cur.fetchall()
    locations = [location[0] for location in locations]
    if request.method == "GET" and "Location=" in str(request):
        location = str(request).split("Location=")[1].split("'")[0]     # can be improved
        side = str(request).split("Camp+Side=")[1].split("&")[0]     # can be improved

        cur.execute("SELECT A.*, R.startingdate, R.enddate FROM ACCOMODATION A LEFT JOIN RESERVATION R ON A.accomodationid=R.accomodationId WHERE A.accomodationlocation='{}' \
                    INTERSECT \
                    SELECT A.*, R.startingdate, R.enddate FROM ACCOMODATION A LEFT JOIN RESERVATION R ON A.accomodationid=R.accomodationId WHERE A.campid=(SELECT C.campid FROM \
                        CAMP C WHERE C.camplocation='{}');".format(side, location))
        table_columns = [col.name for col in cur.description]
        resultsT = cur.fetchall()
        results = sorted(resultsT, key=lambda x:x[1])

        msg = location+' '+side
        return render_template("rent.html", column_names=table_columns, table=results, message=msg, locations=locations, count=range(count))

    elif request.method == "POST":
        actions = {
            "customer_count" : "Customer Count Entry",
            "salary" : "Add Customer and Accomodation"
        }
        for key, value in actions.items():
            if key in str(request.form):
                msg += value
                break

        # Give action
        if msg == "Customer Count Entry":
            try:
                count += int(request.form["customer_count"])
                msg = "{} People".format(count)
            except ValueError:
                msg = "Enter only integers"
        elif msg == "Add Customer and Accomodation":
            if any(value=='' for key, value in request.form.items()):
                msg = "There is empty value in the form"
            else:
                count += int((len(request.form)-3)/7)
                # accomodationdan dailyCost, campidyi ve kontenjan cek
                cur.execute("SELECT dailycost, campid, capacity FROM accomodation WHERE accomodationId='{}'".format(request.form['accomodationid']))
                result = cur.fetchall()
                dailycost = result[0][0]
                campid = result[0][1]
                capacity = result[0][2]
                
                sd = datetime.strptime(request.form['startingdate'], '%Y-%m-%d').date()
                ed = datetime.strptime(request.form['enddate'], '%Y-%m-%d').date()
                dayCount = (ed-sd).days
                age_list = []
                count_under_18 = 0
                for i in range(count):
                    bd = datetime.strptime(request.form['birthDate{}'.format(i+1)], '%Y-%m-%d').date()
                    age_list.append(date.today().year - bd.year - ((date.today().month, date.today().day) < (bd.month, bd.day)))
                    if 18 > age_list[-1]:
                        count_under_18 += 1
                print(dailycost, campid, capacity, count_under_18)

                # hepsi 18den kucukse ekleyemeyiz
                if count_under_18 == count:
                    msg = "Everyone can't be under 18 age"

                # accomodation kontenjan kiyasla count ile
                elif capacity < count:
                    msg = "Selected accomodation capacity is not enough for {} people. {} people can be seperated to different accomodations".format(count, count)

                # tablolara eklemeler ve duzenlemeler
                if msg == "Add Customer and Accomodation":
                    # reservation'a reservasyon ekle accomodationid + startdate + enddate
                    QUERY = "INSERT INTO reservation VALUES('{}', '{}', '{}');".format(request.form['accomodationid'], str(request.form['startingdate']), str(request.form['enddate']))
                    # persona ekle campid, nextval('cusId'), 'Jason', 'Kidd', '12345678201', 'M', '05555555201', age_hesapla!!!!!, '1993-09-10'
                    QUERY += "INSERT INTO person VALUES"
                    for i in range(count):
                        QUERY += "('{}', nextval('cusId'), '{}', '{}', '{}', '{}', '{}', '{}', '{}'),".format(campid, request.form['firstName{}'.format(i+1)], request.form['lastName{}'.format(i+1)], 
                        request.form['personalId{}'.format(i+1)], request.form['gender{}'.format(i+1)], request.form['phoneNumber{}'.format(i+1)], age_list[i], str(request.form['birthDate{}'.format(i+1)]))
                    QUERY = QUERY[:-1] + ';'
                    # customera ekle (nextVal('cusId'), accomodationid, startdate + enddate, dailyCost/count),
                    print(QUERY)
                    cur.execute(QUERY)
                    conn.commit()
                    QUERY = "INSERT INTO customer VALUES"
                    for i in range(count):
                        
                        cur.execute("SELECT personid FROM person WHERE personalid='{}'".format(request.form["personalId{}".format(i+1)]))
                        result = cur.fetchall()
                        cusid = result[0][0]
                        QUERY+="('{}', '{}', '{}', '{}', '{}'),".format(cusid, request.form['accomodationid'], str(request.form['startingdate']), str(request.form['enddate']), str((int(dailycost)/count)*dayCount))
                    QUERY = QUERY[:-1] + ';'
                    print(QUERY)
                    cur.execute(QUERY)
                    conn.commit()
                    msg += "\n {} of total payment is payed when reserving.".format(str(int((int(dailycost)*dayCount)/2)))
                
    return render_template("rent.html", column_names=[], table=[], message=msg, locations=locations, count=range(count))

@app.route("/goodbye/", methods=["GET", "POST"])
def goodbye():
    global cur
    global conn
    cur.close()
    conn.close()
    return render_template("goodbye.html")
