Skip to content
Search or jump to…

Pull requests
Issues
Marketplace
Explore
 
@nkhlbr 
nkhlbr
/
Delete-Millions-of-Rows-Fast-with-SQL
1
00
Code
Issues
Pull requests
Actions
Projects
Wiki
Security
Insights
Settings
Delete-Millions-of-Rows-Fast-with-SQL/Delete Millions of rows via batch process.txt
@nkhlbr
nkhlbr Add files via upload
Latest commit 8a4ac9f on Sep 3, 2020
 History
 1 contributor
83 lines (60 sloc)  3.48 KB
  
/*
-- *********************************************************************************************
-- Description      : Delete the data selectively in the DW2_Ext_HIST table.
--
-- Arguments        : row_cnts1  - contains no. of records in DW2_Ext_HIST table before deletion 
                    --row_cnts2  - contains no. of records in DW2_Ext_HIST table after deletion
                    --li_Months  - set the limit on of months for archive data
                    --li_DeleteCnt - Total rows deleted
                    --li_MinBatch  - Minimum DW_ETLNUM
                    --li_MaxBatch  - Maximum DW_ETLNUM
                    --li_batch_DW_ETL - No.of counts in a batch
--
-- Modification History
-- Programmer           Date       Description
-- -------------------- ---------- ---------------------------------------------------------------
-- N Barua              04/12/2020 Original Script.
-- N Barua              04/12/2020 Modified the script and added batch variable li_batch_DW_ETL
-- *********************************************************************************************
-- Copyright NB
-- *********************************************************************************************
*/

--Execute the code block in a separate window to increase the lines in DBMS Output

--SET SERVEROUTPUT ON SIZE 250000
--SET LINESIZE 500
--SET TRIMSPOOL ON

DECLARE
row_cnts1    NUMBER := 0;
row_cnts2    NUMBER := 0;
li_Months    NUMBER := 6;
li_DeleteCnt NUMBER := 0;
li_MinBatch  NUMBER := 1;
li_MaxBatch  NUMBER := 90;
li_batch_DW_ETL NUMBER := 7;
 

BEGIN
      
---------------------------------No. of records before deletion----------------------------------------------------------------------------------------------------------

    SELECT COUNT(*) INTO row_cnts1 
      FROM DW2_Ext_HIST;

    DBMS_OUTPUT.PUT_LINE ('Total count of the records before deletion: ' || ' ' ||  row_cnts1);
    
 
---------------------------------Selective Deletion of records----------------------------------------------------------------------------------------------------------

    FOR del_rec IN li_MinBatch..(li_MinBatch + li_batch_DW_ETL)  
    LOOP
  
DELETE  FROM 
            DW2_Ext_HIST DEDH1             
            WHERE DEDH1.DW_ETLDATE <= ADD_MONTHS(SYSDATE, -li_Months)
            AND DEDH1.DW_ETLNUM <= li_MaxBatch;
            --AND ROWNUM < li_RowNum;            
            
            li_MinBatch := li_MinBatch + li_batch_DW_ETL;  --loops per batch of li_batch_DW_ETL records
            
            EXIT WHEN li_MinBatch > li_MaxBatch; 
            
            li_DeleteCnt:=SQL%ROWCOUNT;
            
            DBMS_OUTPUT.PUT_LINE ('Rows Deleted: '|| li_DeleteCnt); --Displays total rows deleted
            
            DBMS_OUTPUT.PUT_LINE ('Iteration Number: ' || del_rec); -- Current Iteration Number
            
            DBMS_OUTPUT.PUT_LINE ('Min Batch Number in a iteration: ' || li_MinBatch); --Minimum record
            
            DBMS_OUTPUT.PUT_LINE ('Counts in a Batch per increment: ' || li_batch_DW_ETL); --Total count in a batch
            
--COMMIT;
    END LOOP;
    
---------------------------------No. of records after deletion----------------------------------------------------------------------------------------------------------
    SELECT COUNT(*) INTO row_cnts2 
      FROM DW2_Ext_HIST;

           DBMS_OUTPUT.PUT_LINE ('Total count of the records after deletion: ' ||  row_cnts2);
          
END;
© 2021 GitHub, Inc.
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
Loading complete