/* 
=====================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
=====================================================
Script Purpose:
       This stored procedure loads data into the 'bronze'schema from external CSV files.
       It perfomss the following actions:
       - Truncates the bronze tables before loading data.
       -Uses the 'BULK INSERT' command to load data from csv Files to bronze tables.

Parameters:
    None.
  This stored procedure does not accept any parameters or return any values.

Usage Example:
      EXEC bronze.load_bronze;
===========================================================
*/

USE data_warehouse;
GO
EXEC bronze.load_bronze

CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;
    BEGIN TRY
         SET @batch_start_time = GETDATE();

         PRINT '================================';
         PRINT 'Loading Bronze Layer';
         PRINT '================================';

         PRINT '--------------------------------';
         PRINT 'Loading CRM Tables';
         PRINT '--------------------------------';  

         PRINT '>> Truncating Table: bronze.crm_cust_info';
         TRUNCATE TABLE bronze.crm_cust_info;

         PRINT '>> Inserting Data Into: bronze.crm_cust_info';
    
        SET @start_time = GETDATE();
        -------------------------------------------------
        -- CRM CUSTOMER INFO
        -------------------------------------------------

        TRUNCATE TABLE bronze.crm_cust_info;

        BULK INSERT bronze.crm_cust_info
        FROM 'C:\Users\Kibota\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
    

        SELECT COUNT(*) FROM bronze.crm_cust_info;
    
        SET @end_time = GETDATE();
        PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
        PRINT'--------------------'; 

        
        SET @start_time = GETDATE();
        -------------------------------------------------
        -- CRM PRODUCT INFO
        -------------------------------------------------

        TRUNCATE TABLE bronze.crm_prd_info;

        BULK INSERT bronze.crm_prd_info
        FROM 'C:\Users\Kibota\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
    

        SELECT COUNT(*) FROM bronze.crm_prd_info;

        SET @end_time = GETDATE();
        PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
        PRINT'--------------------'; 
        
        
        SET @start_time = GETDATE();
        -------------------------------------------------
        -- CRM SALES DETAILS
        -------------------------------------------------

        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM 'C:\Users\Kibota\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
    

        SELECT COUNT(*) FROM bronze.crm_sales_details;

        SET @end_time = GETDATE();
        PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
        PRINT'--------------------'; 
    
        SET @start_time = GETDATE();
        -------------------------------------------------
        -- ERP CUSTOMER
        -------------------------------------------------

        TRUNCATE TABLE bronze.erp_cust_az12;

        BULK INSERT bronze.erp_cust_az12
        FROM 'C:\Users\Kibota\Desktop\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
    

        SELECT COUNT(*) FROM bronze.erp_cust_az12;

        SET @end_time = GETDATE();
        PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
        PRINT'--------------------';
    
        PRINT '--------------------------------';
        PRINT 'Loading ERP Tables';
        PRINT '--------------------------------';


        SET @end_time = GETDATE();
        -------------------------------------------------
        -- ERP LOCATION
        -------------------------------------------------

        TRUNCATE TABLE bronze.erp_loc_a101;

        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\Users\Kibota\Desktop\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );
    

        SELECT COUNT(*) FROM bronze.erp_loc_a101;

        SET @end_time = GETDATE();
        PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
        PRINT'--------------------';

        
        SET @end_time = GETDATE();
        -------------------------------------------------
        -- ERP PRODUCT CATEGORY
        -------------------------------------------------

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\Users\Kibota\Desktop\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );


        SELECT COUNT(*) FROM bronze.erp_px_cat_g1v2;
        
        SET @batch_end_time = GETDATE();
        PRINT' -   Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
        PRINT'--------------------';

        SET @end_time = GETDATE();
        PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
        PRINT'--------------------';



    END TRY 
    BEGIN CATCH
        PRINT '==================================';
        PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message'+ ERROR_MESSAGE();
        PRINT 'Error Message'+ CAST (ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error Message'+ CAST (ERROR_STATE() AS NVARCHAR);
        PRINT '==================================';

    END CATCH
END;
GO
