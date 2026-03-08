-- Active: 1767956782913@@127.0.0.1@5432@semarchy_db
DO $$
DECLARE
  v_load_id int;
BEGIN
  v_load_id := public.get_new_loadid (
       'case'                /* Data Location name from your list */
      ,'manual_etl_script'   /* Informational program name */
      ,'address_load_test'   /* Description of this specific load */
      ,'studyauth'           /* User initializing the load */
  );
  RAISE NOTICE 'Your Load ID is: %', v_load_id;
END;
$$;


DO $$
DECLARE
  v_batch_id int;
BEGIN
  v_batch_id := public.submit_load (
             121                 /* Load ID from Step 1 */
            ,'INTEGRATE_ADDRESS'   /* Job name from your image */
            ,'studyauth'           /* User who initialized the load */
  );
  RAISE NOTICE 'Integration Batch started. Batch ID: %', v_batch_id;
END;
$$;