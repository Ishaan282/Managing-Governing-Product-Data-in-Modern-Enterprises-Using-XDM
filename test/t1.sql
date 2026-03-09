-- Active: 1767956782913@@127.0.0.1@5432@semarchy_db
DO $$
DECLARE
    v_load_id int;
BEGIN
    v_load_id := public.get_new_loadid (
        'case'                
        ,'manual_etl_script'   
        ,'basic_entity_test'   
        ,'studyauth'           
    );
    RAISE NOTICE 'Your Load ID is: %', v_load_id;
END;
$$;

DO $$
DECLARE
  v_batch_id int;
BEGIN
  v_batch_id := public.submit_load (
             125                  -- Load ID from Step 1
            ,'INTEGRATE_BASIC'    -- Your Job Name
            ,'studyauth'          
  );
  RAISE NOTICE 'Integration Batch started. Batch ID: %', v_batch_id;
END;
$$;


DO $$
BEGIN
    PERFORM public.cancel_load(
        124,          -- The Load ID
        'studyauth'   -- This MUST match the "User" parameter from get_new_loadid
    );
    RAISE NOTICE 'Load 124 has been cancelled.';
END;
$$;