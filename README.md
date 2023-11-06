# Camp System Website with PostgreSQL and Flask
In order to gain practical experience building web applications from scratch, this project was developed. The task is to develop a web application that simulates a camp database system over large area. Camps, reservations, accomadations, employee and customer, services, activities, foods information is stored and manipulated, accessed via UI.

Collaborated with [Alperen Ölçer](https://github.com/Alperenlcr) and [Barış Bakım](https://github.com/bbakim).

##  🔍 Detailed Project Report
[Check](Detailed_Report.pdf) out for more details.

## 👇 Project Benefits
This project should improves:
- Your ability to translate text into code, and to turn requirements into a finished product.
- Your proficiency in following predefined requirements with attention to detail, ensuring a complete end-to-end execution.
- Your creative approach to tackling vague requirements.
- Your ability to hack, organize, document, test, structure, and write code efficiently.
- Your skill in utilizing existing resources to swiftly develop the application.
- Your relational thinking skills.

## Development Stacks
- Python3
- PostgreSQL
- Flask
- HTML
- Venv(optional)

## How to Run
- Python 3.7.4 is recommended.
1. Install and extract project
2. Create database with PostgreSQL.
3. Run 3 sql codes ,which are in the /Database_SQL folder, in this order: schema.sql, insertInto.sql, functions.sql.
4. Creating a virtual environment (optional)
```
$ cd ./UI_Flask
```
-  macOS/Linux
```
# You may need to run sudo apt-get install python3-venv first
$ python3 -m venv .venv
```
- Windows
```
# You can also use py -3 -m venv .venv
$ python -m venv .venv
```
5. Install dependencies
```
$ pip install -r requirements.txt
```
6. Connect by changing psycopg2.connect() function params from /UI_Flask/app/_\_init__.py
7. Run

## 📍 Project Final Result Screenshots
### Entry Page
![entry](https://user-images.githubusercontent.com/75525649/217833426-ddc5ba57-a01f-4f24-9ab6-aed470f3fee7.png)

### Employee Page
![employee1](https://user-images.githubusercontent.com/75525649/217833434-78d6b741-5238-4f2d-a0ae-e51988bf76fd.png)
![employee2](https://user-images.githubusercontent.com/75525649/217833440-e0b92e28-b7a2-4e25-bf28-762b76573bd3.png)

### Customer Page
![customer](https://user-images.githubusercontent.com/75525649/217833456-5b5315b0-584d-4c8f-82b7-31c2d9f33d57.png)

### Rent Page
![rent](https://user-images.githubusercontent.com/75525649/217833462-0edba555-c5cb-40c0-8b5c-342cf2b5fa02.png)
