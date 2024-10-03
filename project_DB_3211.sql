DROP TABLE Employee CASCADE CONSTRAINTS;
CREATE TABLE Employee (
SSN char(9),
Frist_Name varchar2(12),
Middle_Name varchar2(12),
Last_Name varchar2(12),
salary number(6,2),
date_of_birth date,
CONSTRAINT ssn_PK PRIMARY KEY (SSN)
);

DROP TABLE Fuel_dispenser CASCADE CONSTRAINTS;
CREATE TABLE Fuel_dispenser (
dispenserNo char(4),
fuel_type varchar2(10) CHECK(fuel_type IN('Green 91','Red 95')),
unit_price number(5,2),
CONSTRAINT diNO_PK PRIMARY KEY (dispenserNo)
);

DROP TABLE payment CASCADE CONSTRAINTS ;
CREATE TABLE payment (
Payment_id char(3),
dispenserNo char(4),
Payment_method varchar2(14) CHECK(Payment_method IN('Cash','Credit_card')),
CONSTRAINT Payment_PK PRIMARY KEY (Payment_id),
CONSTRAINT disNo_FK FOREIGN KEY (dispenserNo) REFERENCES Fuel_dispenser(dispenserNo)
);

DROP TABLE Driver CASCADE CONSTRAINTS;
CREATE TABLE Driver(
licenseNo NUMBER(5),
Payment_id CHAR(3),
dispenserNo CHAR(4),
Driver_name VARCHAR2(12),
CONSTRAINT DRIVER_PK PRIMARY KEY (licenseNo),
CONSTRAINT pay_FK1 FOREIGN KEY(payment_id)  REFERENCES Payment(payment_id),
CONSTRAINT disN_FK2 FOREIGN KEY (dispenserNo) REFERENCES Fuel_dispenser(dispenserNo)
);

DROP TABLE Driver_phoneNo CASCADE CONSTRAINTS;
CREATE TABLE Driver_phoneNo(
licenseNo NUMBER(5),
PhoneNo NUMBER(10),
CONSTRAINT Lph_PK PRIMARY KEY(PhoneNo, licenseNo),
CONSTRAINT DP_FK FOREIGN KEY(licenseNo) REFERENCES Driver(licenseNo)
);

DROP TABLE Car CASCADE CONSTRAINTS;
CREATE TABLE Car(
car_plate varchar2(5),
licenseNo number(5),
tanke_size number(2),
car_model varchar2(30),
CONSTRAINT car_PK PRIMARY KEY(car_plate),
CONSTRAINT Driv_FK FOREIGN KEY(licenseNo) REFERENCES Driver(licenseNo)
);

DROP TABLE car_color CASCADE CONSTRAINTS;
CREATE TABLE car_color(
color varchar2(10),
car_plate varchar2(5),
CONSTRAINT col_PK PRIMARY KEY(color),
CONSTRAINT car_Fk FOREIGN KEY(car_plate) REFERENCES Car(car_plate)
);


DROP TABLE fill cascade constraints;
CREATE TABLE fill(
SSN Char(9),
dispenserNo Char(4),
car_plate Varchar2(5),
quantity NUMBER(3) NOT NULL,
constraint fill_PK PRIMARY KEY (SSN , dispenserNo , car_plate),
constraint fill_FK1 FOREIGN KEY (SSN) REFERENCES Employee(SSN),
constraint fill_FK2 FOREIGN KEY (dispenserNo) REFERENCES Fuel_dispenser(dispenserNo),
constraint fill_FK3 FOREIGN KEY (car_plate) REFERENCES Car(car_plate)
);


INSERT INTO Employee VALUES ('052684007','Peter','Ross','Bing',5000.90,'12-DEC-1980');
INSERT INTO Employee VALUES ('385190462','Mike','Tom','Green',6000.90,'20-MAY- 1976');
INSERT INTO Employee VALUES ('500348276','John','Smith','Presley',4000.57,'01-AUG-2000');
INSERT INTO Employee VALUES ('404879368','Tony','Jerry','Geller',7000.30,'09-AUG-1998');

INSERT INTO Fuel_dispenser VALUES ('2010','Green 91',100.51);
INSERT INTO Fuel_dispenser VALUES ('3010','Green 91',100.95);
INSERT INTO Fuel_dispenser VALUES ('4002','Red 95',250.68);
INSERT INTO Fuel_dispenser VALUES ('6004','Red 95',150.95);

INSERT INTO payment VALUES ('132','2010','Credit_card');
INSERT INTO payment VALUES ('133','3010','Credit_card');
INSERT INTO payment VALUES ('134','4002','Cash');
INSERT INTO payment VALUES ('135','6004','Cash');

INSERT INTO Driver VALUES(11375,'132','2010','Mohammed');
INSERT INTO Driver VALUES(12285,'133','3010','Ahmed');
INSERT INTO Driver VALUES(13376,'134','4002','Sara');
INSERT INTO Driver VALUES(10465,'135','6004','Norah');
INSERT INTO Driver_phoneNo VALUES (11375,0540007890);
INSERT INTO Driver_phoneNo VALUES (11375,0540008899);
INSERT INTO Driver_phoneNo VALUES (11375,0549990008);
INSERT INTO Driver_phoneNo VALUES (12285,0541001234);
INSERT INTO Driver_phoneNo VALUES (12285,0543395007);
INSERT INTO Driver_phoneNo VALUES (10465,0549988004);

INSERT INTO Car VALUES('QW234',11375,75,'Cadillac Coupe');
INSERT INTO Car VALUES('MU578',12285,50,'Porsche 911');
INSERT INTO Car VALUES('FT023',13376,69,'Chevrolet Task-Force');
INSERT INTO Car VALUES('GT822',10465,40,'Hudson Hornet');
INSERT INTO car_color VALUES('red','QW234');
INSERT INTO car_color VALUES('black','QW234');
INSERT INTO car_color VALUES('grey','MU578');
INSERT INTO car_color VALUES('white','MU578');
INSERT INTO car_color VALUES('blue','FT023');
INSERT INTO car_color VALUES('green','GT822');

INSERT INTO fill VALUES ('052684007','2010','QW234',45);
INSERT INTO fill VALUES ('385190462','3010','MU578',50);
INSERT INTO fill VALUES ('500348276','4002','FT023',60);
INSERT INTO fill VALUES ('404879368','6004','GT822',30);

--Employee------------------------
--1 Counting the number of employees close to retirement year
SELECT COUNT(*)
from Employee
WHERE date_of_birth <'01-jan-1990';
SELECT *
FROM Employee
ORDER BY date_of_birth;


--Fuel_dispenser-------------------
-- 1- to calculate the total price after adding %15 tax
UPDATE Fuel_dispenser
SET unit_price= unit_price+(unit_price*0.15);
-- 2- Get a 10% discount if the order price is more than 250
UPDATE Fuel_dispenser
SET unit_price=unit_price-(unit_price*0.10)
WHERE unit_price>250.00;
SELECT *
FROM Fuel_dispenser;
-- 3- Count the number of times used for each type of fule
-- and calculate the average price
SELECT fuel_type,COUNT(*),avg(unit_price) 
FROM Fuel_dispenser
GROUP BY fuel_type 
ORDER BY fuel_type;
  
  
--payment---------------------------
Select *
From payment;
-- 1- to bring the payment terminal at
-- specified fuel dispencer if Payment_method ='Credit_card'
Select dispenserNo,Payment_method
From payment
Where Payment_method ='Credit_card';


--Driver----------------------------
SELECT *
FROM Driver;
--Driver_phoneNo--------------------
SELECT *
FROM Driver_phoneNo;
-- 1- display all the drivers that have more than 1 phone number.
select LicenseNo,count(*) 
from Driver_phoneNo 
group by LicenseNo
HAVING COUNT(*)>1 ;


--Car--------------------------------
SELECT *
FROM Car;
-- 1- Searches for a specific car plate number in case
-- the car has any precedents in the records
SELECT *
FROM Car
WHERE car_plate='QW234';
--car_color---------------------------
SELECT *
FROM car_color;


--fill---------------------------------
-- 1- To know the max quantity, for each employee
-- at the gas station has filled
SELECT SSN,MAX(quantity)
FROM fill
GROUP BY SSN;
-- 2- The query will update the dispenser number to 3010 if the filled
-- quantity is more than or equal to 50(where the vehicle will fill
-- more than half of the quantity and is intended for big cars)
UPDATE fill
set dispenserNo='3010'
WHERE quantity>=50;
SELECT*
FROM fill
ORDER BY quantity desc;
   


