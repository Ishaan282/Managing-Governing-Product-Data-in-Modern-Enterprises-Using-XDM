-- Active: 1767956782913@@127.0.0.1@5432@semarchy_data
DO $$
DECLARE
   v_load_id int := 133;
   v_user varchar := 'studyauth'; 
BEGIN
   ---------------------------------------------------------
   -- FUZZY ENTITIES (SD_ Tables) with Deduplication
   ---------------------------------------------------------

   -- Address
   INSERT INTO casestudy.sd_address  (b_loadid, b_classname, b_pubid, b_sourceid, address_line1, city, state, country, postal_code)
   SELECT DISTINCT ON (Address_ID, Publisher) 
          v_load_id, 'Address', Publisher, Address_ID, Address_Line1, City, State, Country , Postal_Code
   FROM p_cleansedData.address
   ORDER BY Address_ID, Publisher
   LIMIT 3000;

   -- Customer
   INSERT INTO casestudy.sd_customer (b_loadid, b_classname, b_pubid, b_sourceid, customer_name, customer_type, mobile, email)
   SELECT DISTINCT ON (Customer_ID, Publisher) 
          v_load_id, 'Customer', Publisher, Customer_ID, Customer_Name, Customer_Type, Mobile, Email
   FROM p_cleansedData.customer
   ORDER BY Customer_ID, Publisher
   LIMIT 3000;

   -- Product
   INSERT INTO casestudy.sd_product (b_loadid, b_classname, b_pubid, b_sourceid, category, sub_category, brand, product_name, status, hazard_class)
   SELECT DISTINCT ON (Product_ID, Publisher) 
          v_load_id, 'Product', Publisher, Product_ID, Category, Sub_Category, Brand, Product_Name, Status, Hazard_Class
   FROM p_cleansedData.product
   ORDER BY Product_ID, Publisher
   LIMIT 3000;

   -- Supplier
   INSERT INTO casestudy.sd_supplier (b_loadid, b_classname, b_pubid, b_sourceid, supplier_name, city, state, country)
   SELECT DISTINCT ON (Supplier_ID, Publisher) 
          v_load_id, 'Supplier', Publisher, Supplier_ID, Supplier_Name, City , State, Country
   FROM p_cleansedData.supplier
   ORDER BY Supplier_ID, Publisher
   LIMIT 3000;

   -- Warehouse 
   INSERT INTO casestudy.sd_warehouse (b_loadid, b_classname, b_pubid, b_sourceid, warehouse_name, city, state, country)
   SELECT DISTINCT ON (Warehouse_ID, Publisher) 
          v_load_id, 'Warehouse', Publisher, Warehouse_ID, Warehouse_Name, City, State, Country
   FROM p_cleansedData.warehouse
   ORDER BY Warehouse_ID, Publisher
   LIMIT 3000;

   ---------------------------------------------------------
   -- BASIC ENTITIES & BRIDGES (SA_ Tables)
   ---------------------------------------------------------

   -- Supplier_Product Bridge 
   INSERT INTO casestudy.sa_supplier_product (b_loadid, b_classname, id, fs_supplier_id, fs_product_id, fp_supplier_id, fp_product_id)
   SELECT
          v_load_id, 'SupplierProduct', ID, Supplier_ID, Product_ID, Supplier_PUB, Supplier_PUB
   FROM p_cleansedData.supplier_product
   ORDER BY product_id
   LIMIT 3000;
   

   -- Customer_Address Bridge 
   INSERT INTO casestudy.sa_customer_address (b_loadid, b_classname, id, fs_address_id, fs_customer_id, fp_address_id, fp_customer_id)
   SELECT
          v_load_id, 'CustomerAddress', ID, Address_ID, Customer_ID , 'CRM', Customer_PUB
   FROM p_cleansedData.customer_address
   ORDER BY customer_id
   LIMIT 3000;

   RAISE NOTICE 'All inserts completed successfully for Load ID: %.', v_load_id;

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'An error occurred: %. Transaction rolled back.', SQLERRM;
END $$;

