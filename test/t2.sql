-- Active: 1767956782913@@127.0.0.1@5432@semarchy_data
-- Use the Load ID from Step 1 (e.g., 122)
INSERT INTO casestudy.sa_test (
   b_loadid,       -- System field
   b_classname,    -- 'test' (Entity name)
--    id,             -- Your "Source" ID (e.g., '1')
    test_id,
    hei             -- Your attribute
)
VALUES 
   (125, 'test',1, 'Hello Semarchy!');

COMMIT; -- Crucial so the integration job can "see" the row