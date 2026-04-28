-- Active: 1767956782913@@127.0.0.1@5432@semarchy_data
DO $$
DECLARE
   v_load_id int := 128;
   v_user varchar := 'studyauth'; 
BEGIN
   ---------------------------------------------------------
   -- FUZZY ENTITIES (SD_ Tables)
   ---------------------------------------------------------

   -- Address
   INSERT INTO casestudy.sd_address (b_loadid, b_classname, b_pubid, b_sourceid, address_line1, city, state, country, postal_code)
   SELECT v_load_id, 'Address', Publisher, Address_ID, Address_Line1, City, State, Country , Postal_Code
   FROM p_cleansedData.address;

   -- Customer
   INSERT INTO casestudy.sd_customer (b_loadid, b_classname, b_pubid, b_sourceid, customer_name, customer_type, mobile, email)
   SELECT v_load_id, 'Customer', Publisher, Customer_ID, Customer_Name, Customer_Type, Mobile, Email
   FROM p_cleansedData.customer;

   -- Product
   INSERT INTO casestudy.sd_product (b_loadid, b_classname, b_pubid, b_sourceid, category, sub_category, brand, product_name, status, hazard_class)
   SELECT v_load_id, 'Product', Publisher, Product_ID, Category, Sub_Category, Brand, Product_Name, Status, Hazard_Class
   FROM p_cleansedData.product;

   -- Supplier
   INSERT INTO casestudy.sd_supplier 
      (b_loadid, b_classname, b_pubid, b_sourceid, supplier_name, city, state, country)
   SELECT v_load_id, 'Supplier', Publisher, Supplier_ID, Supplier_Name, City , State, Country
   FROM p_cleansedData.supplier;

   --wareHouse 
   INSERT INTO casestudy.sd_warehouse(
      b_loadid, b_classname, b_pubid, b_sourceid, warehouse_name, city, state, country
   ) SELECT v_load_id, 'Warehouse', Publisher, Warehouse_ID, Warehouse_Name, City, State, Country;

   ---------------------------------------------------------
   -- BASIC ENTITIES & BRIDGES (SA_ Tables)
   ---------------------------------------------------------

   -- Supplier_Product Bridge
--# Supplier_Product Bridge 
   INSERT INTO casestudy.sa_supplier_product (b_loadid, b_classname, id, fs_supplier_id, fs_product_id
   )
   SELECT v_load_id, 'SupplierProduct', ID, Supplier_ID, Product_ID 
   FROM p_cleansedData.supplier_product;


--# Customer_Address Bridge 
   INSERT INTO casestudy.sa_customer_address (b_loadid, b_classname, id,fs_address_id, fs_customer_id
   )
   SELECT v_load_id, 'CustomerAddress', ID, Address_ID, Customer_ID 
   FROM p_cleansedData.customer_address;

   -- 2. Final Commit to persist the staged data
   COMMIT; 
   
   RAISE NOTICE 'All inserts completed for Load ID: %. You can now verify the SA/SD tables.', v_load_id;

EXCEPTION WHEN OTHERS THEN
   RAISE NOTICE 'An error occurred: %. No data was inserted.', SQLERRM;
END $$;