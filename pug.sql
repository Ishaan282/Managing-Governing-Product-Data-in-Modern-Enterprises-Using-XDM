--! customer table
CREATE TABLE customer (
    Customer_ID     VARCHAR(50),
    Customer_Name   VARCHAR(255),
    Customer_Type   VARCHAR(50),
    Mobile          VARCHAR(20),
    Email           VARCHAR(255),
    Address_ID      VARCHAR(50),
    Publisher       VARCHAR(100)
);
SELECT * FROM customer

--! Product table 
CREATE TABLE product (
    Product_ID       VARCHAR(126),
    Category         VARCHAR(126),
    Sub_Category     VARCHAR(126),
    Brand            VARCHAR(126),
    Product_Name     VARCHAR(255),
    Supplier_ID      VARCHAR(126),
    Status           VARCHAR(126),
    Hazard_Class     VARCHAR(126),
    Publisher        VARCHAR(100)
);
SELECT *
FROM product
WHERE Product_ID IN (
    SELECT Product_ID
    FROM product
    GROUP BY Product_ID
    HAVING COUNT(*) > 1
)
ORDER BY Product_ID;


SELECT
    Product_ID,
    Category,
    Sub_Category,
    Brand,
    Product_Name,
    Supplier_ID,
    Status,
    Hazard_Class,
    Publisher
FROM product
WHERE Product_Name IS NULL
   OR TRIM(Product_Name) = '';