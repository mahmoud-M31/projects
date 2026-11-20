CREATE DATABASE CENTRAL;
USE CENTRAL;
GO
CREATE TABLE customers2(
    Newcustomer_id INT IDENTITY(1,1) PRIMARY KEY,
    Oldcustomer_id VARCHAR(50),
    customer_name VARCHAR(100),
    segment VARCHAR(50)
);
GO

CREATE TABLE geography2 (
    geo_id INT IDENTITY(1,1) PRIMARY KEY,
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postalCode VARCHAR(20),
    region VARCHAR(50)
);
GO

CREATE TABLE products2(
    Newproduct_id INT IDENTITY(1,1) PRIMARY KEY,
    Oldproduct_id VARCHAR(50),
    product_name VARCHAR(500),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);
GO

CREATE TABLE shipmode2(
    ship_id INT IDENTITY(1,1) PRIMARY KEY,
    ship_mode VARCHAR(50)
);
GO

CREATE TABLE orders2(
    Neworder_id INT IDENTITY(1,1) PRIMARY KEY,
    Oldorder_id VARCHAR(50),
    order_date DATE,
    ship_date DATE,
    ship_id INT FOREIGN KEY REFERENCES shipmode2(ship_id),
    Newcustomer_id INT FOREIGN KEY REFERENCES customers2(Newcustomer_id),
    geo_id INT FOREIGN KEY REFERENCES geography2(geo_id),
    Newproduct_id INT FOREIGN KEY REFERENCES products2(Newproduct_id),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(10,2),
    profit DECIMAL(10,2)
);
GO


INSERT INTO customers2 (Oldcustomer_id, customer_name, segment)
SELECT DISTINCT 
    TRIM(customer_id), 
    LOWER(TRIM(customer_name)), 
    LOWER(TRIM(segment))  
FROM FACT;
GO

INSERT INTO geography2(country, city, state, region, postalCode)
SELECT DISTINCT 
    LOWER(TRIM(country)), 
    LOWER(TRIM(city)), 
    LOWER(TRIM(state)), 
    LOWER(TRIM(region)), 
    ISNULL(postal_code, '')
FROM FACT;
GO

INSERT INTO products2(Oldproduct_id, product_name, category, sub_category)
SELECT DISTINCT 
    TRIM(product_id), 
    LOWER(TRIM(product_name)), 
    LOWER(TRIM(category)), 
    LOWER(TRIM(sub_category)) 
FROM FACT;
GO

INSERT INTO shipmode2(ship_mode)
SELECT DISTINCT 
    LOWER(TRIM(ship_mode))  
FROM FACT;
GO


INSERT INTO orders2 (
    Oldorder_id, order_date, ship_date, ship_id,
    Newcustomer_id, geo_id, Newproduct_id,
    sales, quantity, discount, profit
)
SELECT 
    TRIM(f.order_id) AS order_id,
    f.order_date,
    f.ship_date,
    s.ship_id,
    c.Newcustomer_id,
    g.geo_id,
    p.Newproduct_id,
    f.sales,
    f.quantity,
    f.discount,
    f.profit
FROM FACT AS f

LEFT JOIN customers2 AS c 
    ON TRIM(f.customer_id) = c.Oldcustomer_id 
   AND LOWER(TRIM(f.customer_name)) = c.customer_name

LEFT JOIN geography2 AS g 
    ON LOWER(TRIM(f.country)) = g.country
   AND LOWER(TRIM(f.city)) = g.city
   AND LOWER(TRIM(f.state)) = g.state
   AND LOWER(TRIM(f.region)) = g.region
   AND ISNULL(f.postal_code, '') = g.postalCode

LEFT JOIN products2 AS p 
    ON TRIM(f.product_id) = p.Oldproduct_id 
   AND LOWER(TRIM(f.product_name)) = p.product_name

LEFT JOIN shipmode2 AS s 
    ON LOWER(TRIM(f.ship_mode)) = s.ship_mode;
GO

WITH customer_behavior AS(
SELECT c.customer_name,
CASE WHEN SUM(O.sales)>6000 THEN 'HIGH LOYAL'
     WHEN SUM(O.SALES)BETWEEN 2000 AND 6000 THEN 'LOYAL'
     ELSE 'NORMAL' END AS behaviour 
FROM customers2 C
JOIN orders2 O
ON O.Newcustomer_id=C.Newcustomer_id
group by c.customer_name
)
select * from customer_behavior

GO

WITH Top_Segment_profit AS(
SELECT C.segment,SUM(O.PROFIT)AS TOTAL_PROFIT
FROM customers2 C
JOIN orders2 O
ON O.Newcustomer_id=C.Newcustomer_id
group by C.segment
)
select * from Top_Segment_profit
GO

CREATE VIEW Sales_Trend AS 
SELECT YEAR(O.order_date) AS YEAR,MONTH(O.order_date) AS MONTH ,SUM(SALES)AS SALES
FROM  orders2 AS O
GROUP BY YEAR(O.order_date) ,MONTH(O.order_date)

SELECT * FROM Sales_Trend
ORDER BY YEAR, MONTH

GO

CREATE VIEW TOP_CATEGORY_AND_SubCATEGORY_PROFIT AS
SELECT P.category,P.product_name,SUM(O.PROFIT)AS TOTAL_PROFIT
FROM products2 AS P
JOIN orders2 AS O
ON O.Newproduct_id=P.Newproduct_id
GROUP BY P.category,P.product_name
SELECT  FROM TOP_CATEGORY_AND_SubCATEGORY_PROFIT
ORDER BY TOTAL_PROFIT DESC

GO 
CREATE PROCEDURE PROFITByCITY
@STATE VARCHAR(50)
AS 
BEGIN
SELECT G.city,SUM(O.PROFIT) AS TOTAL_PROFIT
FROM geography2 AS G
JOIN orders2 AS O
ON O.geo_id=G.geo_id
WHERE G.state=@STATE
GROUP BY  G.city
ORDER BY TOTAL_PROFIT DESC
END
EXEC PROFITBySTATE @STATE='TEXAS'
