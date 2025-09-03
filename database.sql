create database Company;
use Company
CREATE TABLE Department (
    Dnum INT PRIMARY KEY,
    Dname VARCHAR(50),
    Loc VARCHAR(50),
    ManagerSSN INT,
    HireDate DATE,
);
CREATE TABLE Employee (
    SSN INT PRIMARY KEY,
    Name VARCHAR(50),
    BD DATE,
    Gender CHAR(1),
    SupervisorSSN INT,
    Dnum INT,
    FOREIGN KEY (SupervisorSSN) REFERENCES Employee(SSN),
    FOREIGN KEY (Dnum) REFERENCES Department(Dnum)
);
ALTER TABLE Department
ADD CONSTRAINT fk_manager FOREIGN KEY (ManagerSSN) REFERENCES Employee(SSN);
CREATE TABLE Project (
    Pnum INT PRIMARY KEY,
    Pname VARCHAR(50),
    Loc VARCHAR(50),m
    City VARCHAR(50),
    Dnum INT,
    FOREIGN KEY (Dnum) REFERENCES Department(Dnum)
);
CREATE TABLE Dependent (
    DepID INT PRIMARY KEY IDENTITY(1,1),
    SSN INT,
    Dname VARCHAR(50),
    BD DATE,
    Gender CHAR(1),
    FOREIGN KEY (SSN) REFERENCES Employee(SSN)
);
CREATE TABLE Work_in (
    SSN INT,
    Pnum INT,
    Hours INT,
    PRIMARY KEY (SSN, Pnum),
    FOREIGN KEY (SSN) REFERENCES Employee(SSN),
    FOREIGN KEY (Pnum) REFERENCES Project(Pnum)
);
-- Departments
INSERT INTO Department VALUES (1, 'IT', 'Cairo', NULL, '2015-01-01');
INSERT INTO Department VALUES (2, 'HR', 'Alex', NULL, '2016-05-10');
INSERT INTO Department VALUES (3, 'Finance', 'Giza', NULL, '2017-03-15');

-- Employees
INSERT INTO Employee VALUES (1001, 'Ahmed Ali', '1990-02-15', 'M', NULL, 1);
INSERT INTO Employee VALUES (1002, 'Mona Hassan', '1988-07-20', 'F', 1001, 1);
INSERT INTO Employee VALUES (1003, 'Sara Adel', '1992-10-05', 'F', 1001, 2);
INSERT INTO Employee VALUES (1004, 'Omar Khaled', '1995-12-01', 'M', 1003, 2);
INSERT INTO Employee VALUES (1005, 'Hany Ibrahim', '1985-04-10', 'M', 1001, 3);
INSERT INTO Employee VALUES (1006, 'Nourhan Mohamed', '1993-09-09', 'F', 1005, 3);
INSERT INTO Employee VALUES (1007, 'Khaled Samir', '1991-06-17', 'M', 1002, 1);
INSERT INTO Employee VALUES (1008, 'Layla Tarek', '1994-08-22', 'F', 1004, 2);

-- Update Managers
UPDATE Department SET ManagerSSN = 1001 WHERE Dnum = 1;
UPDATE Department SET ManagerSSN = 1003 WHERE Dnum = 2;
UPDATE Department SET ManagerSSN = 1005 WHERE Dnum = 3;

-- Projects
INSERT INTO Project VALUES (2001, 'ERP System', 'Cairo', 'Cairo', 1);
INSERT INTO Project VALUES (2002, 'Recruitment Portal', 'Alex', 'Alex', 2);
INSERT INTO Project VALUES (2003, 'Accounting App', 'Giza', 'Giza', 3);
INSERT INTO Project VALUES (2004, 'Mobile Banking', 'Cairo', 'Cairo', 3);
INSERT INTO Project VALUES (2005, 'E-learning Platform', 'Cairo', 'Cairo', 1);

-- Work_in
INSERT INTO Work_in VALUES (1001, 2001, 40);
INSERT INTO Work_in VALUES (1002, 2001, 35);
INSERT INTO Work_in VALUES (1002, 2005, 20);
INSERT INTO Work_in VALUES (1003, 2002, 30);
INSERT INTO Work_in VALUES (1004, 2002, 25);
INSERT INTO Work_in VALUES (1005, 2003, 40);
INSERT INTO Work_in VALUES (1006, 2003, 20);
INSERT INTO Work_in VALUES (1006, 2004, 25);
INSERT INTO Work_in VALUES (1007, 2005, 30);
INSERT INTO Work_in VALUES (1008, 2002, 20);

-- Dependents
INSERT INTO Dependent (SSN, Dname, BD, Gender) VALUES (1001, 'Omar', '2015-06-10', 'M');
INSERT INTO Dependent (SSN, Dname, BD, Gender) VALUES (1001, 'Salma', '2018-03-12', 'F');
INSERT INTO Dependent (SSN, Dname, BD, Gender) VALUES (1002, 'Nada', '2016-07-22', 'F');
INSERT INTO Dependent (SSN, Dname, BD, Gender) VALUES (1005, 'Youssef', '2014-05-18', 'M');
INSERT INTO Dependent (SSN, Dname, BD, Gender) VALUES (1006, 'Malak', '2019-09-25', 'F');
-----------------------------------------------------------------------------------------
/*شوية استعلامات ممكن تنفذها
1- علشان تعرض كل اللي في الجدول 
select  (*\name of coulmn) from (name of table)
2- لو عايز مثلا تعرض بيانات من جدول وجدول اخر فكده لازم نستخدم 
joins statements

select e.Name ,D.Dname
from Employee e inner join Department D
on e.Dnum=d.Dnum --> كده هعيرض اسم الموظف بالقسم اللي هيشتغل فيه
3- عايز مثلا تشوف عدد الموظفين في كل قسم
select Department.Dname, count(Dname)as total_employees-->اسم مستعار لا يؤثر على قاعدة البيانات
from Employee inner join Department on Employee.Dnum=Department.Dnum
group by Department.Dname
4-لو عايز تجيب تاني اكبر واحد في كل قسم
select q.dname,q.name
from
(select d.Dname,e.Name,ROW_NUMBER()over (partition  by dname order by e.BD desc ) as birth_date
from Employee e inner join Department d
on e.Dnum=d.Dnum) as q
where q.birth_date=2

5- لو عايز مثلا الشخص وتاريخ ميلاده والقسم اللي شغال فيه 
وكمان الشخص اللي قبليه مباشرة وكمان القسم وتاريخ ميلاده
select *from
(select name as current_name,BD as current_birth_date,  d.Dname as current_department,lag(name)over (order by BD)as prevname,lag(BD)over (order by BD)as prevBD,lag(dname)over (order by BD)as prevdepart
from Employee e inner join Department d
on e.Dnum=d.Dnum
)q
where q.current_birth_date<='1993-09-09'
--------------------------------------------------
في كثير عندك 
ابحث واستمتع
*/







