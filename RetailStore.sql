
-- Short description of your scenario: In my scenario I simulated retail store database model that has several needed entities for a retail store. 
-- Each customer makes order and all orders have order detail. All products have a category and they are come from supplier via shipper companies.
-- Employee's informations who prepared order for customer is kept in Employee table. There is Management table which keeps information about people who rules the company and also
-- there is also Staff table to show which manager is responsible for which employee.



CREATE SCHEMA RETAIL_STORE;
USE RETAIL_STORE;
-- 1. Definitions:


-- Customer table keeps informations related with customer. Each customer has unique ID and user name. Address is
-- for shipping location, user name is information of customer's username on the application (example: oguzhan123) 
-- and contact name is name to use when communicating with the customer (example: Mr. Oguzhan)
CREATE TABLE Customer(
customer_id INT,
adress varchar(100) NOT NULL,
user_name varchar(12) NOT NULL,
contact_name varchar(50) NOT NULL,
customer_password varchar(16) NOT NULL,
credit_card_number varchar(16) NOT NULL,
credit_card_expire_date date NOT NULL,
city varchar(12) NOT NULL, 
zip_code varchar(10),
state_province_county varchar(15) NOT NULL,
country varchar(15) NOT NULL,
phone_number varchar(11) NOT NULL,
email varchar(50) NOT NULL,
UNIQUE (email),
UNIQUE (user_name),
CONSTRAINT customer_pk PRIMARY KEY (customer_id)
);


-- Employee table is for listing active employees. Each employee has unique ID. Salary, day off and shift hours depend
-- on his/her title
CREATE TABLE Employee(
employee_id INT,
first_name varchar(13) NOT NULL,
last_name varchar(13) NOT NULL,
title varchar(15) NOT NULL,
birth_date date NOT NULL,
hire_date date NOT NULL, 
adress varchar(100) NOT NULL,
email varchar(50) NOT NULL,
phone_number varchar(11) NOT NULL,
day_off varchar(10),
work_start_time time NOT NULL,
work_finish_time time NOT NULL,
salary int,
CONSTRAINT employee_pk PRIMARY KEY (employee_id)
);

-- Shipper table keeps informations about delivery companies of orders. payments value shows how much dollar payment has been done so far.
-- delivered_orders value is for indicating how many order has been delivered so far.
CREATE TABLE Shipper(
shipper_name varchar(30),
phone_number int NOT NULL,
payments int,
delivered_orders int,
CONSTRAINT shipper_pk PRIMARY KEY (shipper_name)
);

-- Category table is for finding required product easily. Each catogory has their own ID.
CREATE TABLE Category (
category_id INT,
category_name varchar(10),
description varchar(300),
CONSTRAINT category_pk PRIMARY KEY (category_id)
);

-- Supplier table is to make business process faster and to see the amount of payments more clearly. Each supplier has
-- their own ID
CREATE TABLE Supplier(
supplier_name varchar(30),
shipper_name varchar(30) ,
address varchar(100) NOT NULL,
city varchar(12) NOT NULL,
region varchar(12) NOT NULL,
zip_code int,
country varchar(15) NOT NULL,
phone_number varchar(11) NOT NULL,
payments int,
trade_quantity int,
CONSTRAINT supplier_pk PRIMARY KEY (supplier_name),
CONSTRAINT shipper_fk FOREIGN KEY (shipper_name) REFERENCES Shipper(shipper_name),
UNIQUE (phone_number)
);


-- In the product table, each product has their own ID. Products can be tracked via their supplier company’s ID. If the
-- product is out of stock, users who gave order will have an information about it. If defective products of a supplier are
-- too high, agreement may be revised.
CREATE TABLE Product (
product_id INT,
product_name varchar(20) NOT NULL,
supplier_compay_name varchar(30),
category_id INT,
unit_price INT NOT NULL,
units_in_stock int,
units_on_order int,
sales_rate float,
defective_product_quantity int,
CONSTRAINT product_pk PRIMARY KEY (product_id),
CONSTRAINT supplier_fk FOREIGN KEY(supplier_compay_name) REFERENCES SUPPLIER(supplier_name),
CONSTRAINT category_pk FOREIGN KEY(category_id) REFERENCES category(category_id)
);

-- Order table keeps informations about specific order that has been given by a customer.
-- order_date value is the date when order was given by customer. required_date value is an approximative date when customer will receive his/her order and shipped_date is exact date when order is received.
CREATE TABLE _Order(
order_id INT,
customer_id INT,
employee_id INT,
product_id INT,
shipping_company_name varchar(30),
order_date date NOT NULL,
required_date date NOT NULL,
shipped_date date NOT NULL,
ship_via varchar(30),
ship_adress varchar(30) NOT NULL,
ship_city varchar(12) NOT NULL,
ship_region varchar(12),
transportation_fee decimal(5,2) NOT NULL,
CONSTRAINT order_pk PRIMARY KEY (order_id),
CONSTRAINT customer_fk FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
CONSTRAINT employee_fk FOREIGN KEY (employee_id) REFERENCES Employee(employee_id),
CONSTRAINT product_fk FOREIGN KEY (product_id) REFERENCES Product(product_id),
CONSTRAINT shipper_f FOREIGN KEY (shipping_company_name) REFERENCES Shipper(shipper_name)
);

-- In Order Details table, there are more specific informations those are not exist in Order table. Unit price indicates the price of each item that is ordered.
-- Quantity shows how many item was ordered. And discount column shows how much dollar discount has been given.
CREATE TABLE OrderDetails(
order_id INT NOT NULL,
unit_price INT NOT NULL,
quantity int NOT NULL,
discount INT,
PRIMARY KEY (order_id),
FOREIGN KEY(order_id) REFERENCES _Order(order_id)
);

-- Management table shows the information of the people who manage the company. Each member has their own ID. Whereas managers have all the authorization about company, assistant has not.
CREATE TABLE Management(
management_staff_id INT,
management_staff_name varchar(13) NOT NULL,
management_staff_surname varchar(13) NOT NULL,
titles varchar(13) NOT NULL,
authorization varchar(13),
salary INT NOT NULL,
CONSTRAINT maganement_pk PRIMARY KEY(management_staff_id)
);


-- Staff table shows which management member is whose manager of employee. All manager members those have been matched with employees are responsible for the wages and working hours of the workers shown in the table.
CREATE TABLE STAFF(
management_staff_id INT,
employee_id INT,
CONSTRAINT management_fk FOREIGN KEY (management_staff_id) REFERENCES Management(management_staff_id),
CONSTRAINT employee_f FOREIGN KEY (employee_id) REFERENCES Employee(employee_id)
);

-- 2. Insertions(Data manipulation):


INSERT INTO Customer (customer_id,adress,user_name,contact_name,customer_password,credit_card_number,credit_card_expire_date,city,zip_code,state_province_county,country,phone_number,email) 
VALUES
(1,"3313 Bridle Path","vrnca1994","Veronica","gameofthrones63","376363921604102",'2024-07-16',"Austin","78703","Texas","USA","4323359398","veronica_danovan@gmail.com"),
(2,"743 Al Gahriya St","kwoo4424","Shaik","shaikalwadi12321","180004904000258",'2022-05-22',"Doha","25303","Ar-Rayyan","Qatar","9744885622","shaik-alwadi1@yahoo.com"),
(3,"St Anthony Rd, Siddharath Nagar, Vakola","nabir.uiginn","Rasheed","XgK7ezggoH9Gs","964985445114985",'2024-09-14',"Mumbai","95416","Maharashtra","India","9055573636","rasheed_IN@gmail.com"),
(4,"10 Smith St, Wentworthville","davidJrose","David","kangaroojump3","4916896022223636",'2022-07-30',"Sydney","2145","NSW","Australia","455-5990-62","david.rose456@outlook.com"),
(5,"7 UCD Merville Residences 2348","mathew98","Mathew","ilovejesus1","4716374226921019",'2024-02-21',"Dublin","21450","Belfield","Ireland","855-5909-12","mathew_blakee@outlook.com");

select * from customer;


INSERT INTO Employee (employee_id ,first_name,last_name,title,birth_date ,hire_date ,adress ,email,phone_number ,day_off ,work_start_time ,work_finish_time ,salary)
VALUES
(10,"Steve","Jefferson","Salesperson",'1980-03-17','2019-05-09',"5005 3rd Ave S, Seattle, WA 98134","steve-jefferson@gmail.com","2067623311","Sunday",'08:00:00','16:00:00',1700),
(20,"Jonathan","Light","Salesperson",'1992-12-15','2020-06-18',"4786 1st Ave S, Seattle, WA 98134,","light_jonathan@gmail.com","734-6552264","Saturday",'08:00:00','16:00:00',1700),
(30,"Kelly","Marshall","Salesperson",'1990-04-18','2018-06-18',"1681 4th Ave S, Seattle, WA 98134,","kelly.marshall@gmail.com","65432864703","Sunday",'16:00:00','00:00:00',1700),
(40,"Walter","Blake","Salesperson",'1986-07-04','2017-01-24',"9044 3rd Ave S, Seattle, WA 98134,","walter.blake@gmail.com","9453180640","Saturday",'16:00:00','00:00:00',1900),
(50,"Karen","Gibson","Supervisor",'1970-01-18','2015-06-18',"4563 2nd Ave S, Seattle, WA 98134,","karen.gibson@gmail.com","6594056704","Sunday",'09:00:00','15:00:00',2500);

select*from employee;


INSERT INTO Category(category_id, category_name,description) 
VALUES
(1, "Sports","Includes outdoor recreation and sports equipments."),
(2, "Cosmetic","Includes beauty supplies and cosmetic product tools."),
(3, "Clothing","Includes suitable clothing for people of all ages and genders"),
(4, "Electronic","Includes large variation of electronic devices for all needs.");

select*from category;

INSERT INTO Shipper (shipper_name ,phone_number,payments,delivered_orders) 
VALUES 
("UPS",4360938,5000,1500),
("FedEX",4440868,3000,1000),
("Borderlinx",4440868,2700,850),
("DHL Express",4951101,900,300);

select * from shipper;

INSERT INTO Supplier (supplier_name, shipper_name, address , city, region , zip_code , country , phone_number , payments , trade_quantity) 
VALUES 
("Adidas","UPS","Olympiaring 3. Straße","Herzogenrach","Bayern",91074,"Germany","91329024384",1000000,20000),
("New Balance","UPS","173 Market St, Brighton","Boston","MA",20135,"USA","6177837165",50000,1000),
("L'Oreal","FedEX","41 Rue Martre","Paris","Île-deFrance",92117,"France","47567000",50000,1000),
("Dior","UPS","261 Rue Saint-Honoré","Paris","Île-deFrance",75001,"France","55251120",30000,750),
("H&M","Borderlinx","Drottninggatan 56, 111 21","Stockholm","Centrum",15315,"Sweden","1648521682",35000,500),
("Sony","DHL Express","1 Chome-6-27 Konan","Tokyo","Minato City",10875,"Japan","108007564",350000,500);

select * from supplier;

INSERT INTO Product(product_id ,product_name ,supplier_compay_name , category_id , unit_price , units_in_stock , units_on_order , sales_rate , defective_product_quantity) 
VALUES
(1,"Golf Equipments","Adidas",1,200,50,100,0.03,10),
(2,"Sneakers","New Balance",1,100,500,300,0.3,3),
(3,"Make-up Kit","L'Oreal",2,70,450,200,0.1,7),
(4,"Perfume", "Dior",2,150,400,300,0.1,null),
(5,"Sweater", "H&M",3,40,400,300,0.15,4),
(6,"Head Phone", "Sony",4,200,100,300,0.2,5),
(7,"Camera", "Sony",4,1600,50,100,0.12,1);

select * from product;

INSERT INTO _Order(order_id ,customer_id , employee_id , product_id , shipping_company_name , order_date , required_date , shipped_date , ship_via , ship_adress , ship_city , ship_region , transportation_fee) 
Values
(1,1,30,3,"FedEX",'2019-03-15','2019-03-30','2019-03-25',"Highway","3313 Bridle Path","Austin","Texas",20),
(2,1,30,4,"UPS",'2019-03-15','2019-03-30','2019-03-25',"Highway","3313 Bridle Path","Austin","Texas",10),
(3,2,20,5,"Borderlinx",'2019-05-04','2021-06-05','2021-06-01',"Seaway","743 Al Gahriya St","Doha","Ar-Rayyan",90),
(4,3,10,7,"DHL Express",'2019-06-02','2019-06-15','2019-06-15',"Airway","St Anthony Rd,Siddharath Nagar","Mumbai","Maharashtra",120),
(5,4,40,1,"UPS",'2019-06-02','2019-06-15','2019-06-15',"Seaway","10 Smith St, Wentworthville","Sydey","NSW",110),
(6,5,50,2,"UPS",'2019-09-10','2019-09-26','2019-06-25',"Airway","7 UCD Merville Residences 2348","Dublin","Belfield",40),
(7,5,50,6,"DHL Express",'2019-09-10','2019-09-26','2019-06-25',"Airway","7 UCD Merville Residences 2348","Dublin","Belfield",40);

select* from _Order;


INSERT INTO OrderDetails(order_id, unit_price,quantity,discount)
VALUES
(1,200,2,40),
(2,70,1,20),
(3,40,5,50),
(4,1600,1,200),
(5,200,1,40),
(6,100,3,40),
(7,200,1,20);

select * from orderdetails;



INSERT INTO Management(management_staff_id,management_staff_name,management_staff_surname,titles,authorization,salary)
VALUES
(123,"Oğuzhan","Akgün","Manager","All","20000"),
(456,"Doğukan","Akgün","Manager","All","20000"),
(789,"Jeff","Anderson","Assistant","Limited","10000");

select* from management;

Insert INTO STAFF(management_staff_id, employee_id)
VALUES
(123,50),
(123,40),
(456,10),
(456,30),
(789,20);

select*from staff;
-- 3. Queries:

-- Write 5 queries with explanations 
-- Write 5 queries. Your queries should do a task that is meaningful in your selected context (project topic). 
-- At least one that joins two or more tables
-- At least one that include group functions
-- At least one with one or more sub-query(es)
-- At least one update
-- At least one delete
-- At least one include arithmetic functions
-- At least one uses alias

-- This query gathers order id, contact name of customer and shipped date of order by using join and alias.
SELECT _Order.order_id as "Order ID", Customer.contact_name as "Customer Name", _Order.shipped_date as "Delivery Date"
FROM _Order
INNER JOIN Customer ON _Order.customer_id=Customer.customer_id;


-- This query returns first name, title and salary of the employee whose salary is more than the ones who have day off on saturday and less than the one whose title is Supervisor.
select first_name as "Employee Name" ,title as "Position", salary as "Salary" from Employee 
where salary > all(select avg(salary) from employee where day_off = "Saturday") 
AND salary < (select salary from employee where title = "Supervisor") ;


-- This query updates workers' off days which are from Sunday, to Monday.
update Employee set day_off = "Monday" where day_off = "Sunday" ;


-- This query deletes order details whose discounts are less than 40.
delete from OrderDetails where discount < 40;


-- This query returns employee's first name and square root of salary - 100 whose salary is less than the employee whose surname is Blake.
select first_name, sqrt(salary-100) from employee where salary < (select salary from employee where last_name = "Blake");
