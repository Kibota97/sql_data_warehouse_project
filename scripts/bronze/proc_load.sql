USE data_warehouse;
GO

/*=====================================================
  AUDIT TABLE
  Purpose:
      Store execution metadata for Bronze layer loads.

  Captures:
      - Table loaded
      - Start time
      - End time
      - Duration
      - Row count
      - Status
      - Error details
=====================================================*/

IF OBJECT_ID('bronze_layer.etl_audit_log', 'U') IS NULL
BEGIN
    CREATE TABLE bronze_layer.etl_audit_log
    (
        audit_id INT IDENTITY(1,1) PRIMARY KEY,
        table_name VARCHAR(100),
        load_start_time DATETIME,
        load_end_time DATETIME,
        duration_seconds INT,
        rows_loaded INT,
        load_status VARCHAR(20),
        error_message VARCHAR(2000),
        batch_start_time DATETIME,
        batch_end_time DATETIME,
        created_at DATETIME DEFAULT GETDATE()
    );
END;
GO


/*=====================================================
  STORED PROCEDURE: bronze_layer.load_bronze

  Purpose:
      Load raw CRM and ERP source files into the Bronze
      layer using BULK INSERT.

  Load Strategy:
      Full Refresh (TRUNCATE + RELOAD)

  Source Systems:
      - CRM
      - ERP

  Notes:
      - No transformations
      - No business rules
      - No deduplication
      - Raw data preservation
=====================================================*/

CREATE OR ALTER PROCEDURE bronze_layer.load_bronze
AS
BEGIN

    SET NOCOUNT ON;

    DECLARE
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME,
        @rows_loaded INT;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '==========================================';
        PRINT 'STARTING BRONZE LAYER LOAD';
        PRINT '==========================================';

        /*=================================================
          CRM CUSTOMERS
        =================================================*/

        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze_layer.crm_customers;

        BULK INSERT bronze_layer.crm_customers
        FROM 'C:\Users\Kibota\Desktop\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SELECT @rows_loaded = COUNT(*)
        FROM bronze_layer.crm_customers;

        SET @end_time = GETDATE();

        INSERT INTO bronze_layer.etl_audit_log
        (
            table_name,
            load_start_time,
            load_end_time,
            duration_seconds,
            rows_loaded,
            load_status,
            batch_start_time
        )
        VALUES
        (
            'crm_customers',
            @start_time,
            @end_time,
            DATEDIFF(SECOND, @start_time, @end_time),
            @rows_loaded,
            'SUCCESS',
            @batch_start_time
        );

        /*=================================================
          CRM PRODUCTS
        =================================================*/

        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze_layer.crm_products;

        BULK INSERT bronze_layer.crm_products
        FROM 'C:\Users\Kibota\Desktop\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SELECT @rows_loaded = COUNT(*)
        FROM bronze_layer.crm_products;

        SET @end_time = GETDATE();

        INSERT INTO bronze_layer.etl_audit_log
        (
            table_name,
            load_start_time,
            load_end_time,
            duration_seconds,
            rows_loaded,
            load_status,
            batch_start_time
        )
        VALUES
        (
            'crm_products',
            @start_time,
            @end_time,
            DATEDIFF(SECOND, @start_time, @end_time),
            @rows_loaded,
            'SUCCESS',
            @batch_start_time
        );

        /*=================================================
          CRM SALES
        =================================================*/

        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze_layer.crm_sales;

        BULK INSERT bronze_layer.crm_sales
        FROM 'C:\Users\Kibota\Desktop\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SELECT @rows_loaded = COUNT(*)
        FROM bronze_layer.crm_sales;

        SET @end_time = GETDATE();

        INSERT INTO bronze_layer.etl_audit_log
        (
            table_name,
            load_start_time,
            load_end_time,
            duration_seconds,
            rows_loaded,
            load_status,
            batch_start_time
        )
        VALUES
        (
            'crm_sales',
            @start_time,
            @end_time,
            DATEDIFF(SECOND, @start_time, @end_time),
            @rows_loaded,
            'SUCCESS',
            @batch_start_time
        );

        /*=================================================
          ERP CUSTOMER DEMOGRAPHICS
        =================================================*/

        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze_layer.erp_customer_demo;

        BULK INSERT bronze_layer.erp_customer_demo
        FROM 'C:\Users\Kibota\Desktop\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SELECT @rows_loaded = COUNT(*)
        FROM bronze_layer.erp_customer_demo;

        SET @end_time = GETDATE();

        INSERT INTO bronze_layer.etl_audit_log
        (
            table_name,
            load_start_time,
            load_end_time,
            duration_seconds,
            rows_loaded,
            load_status,
            batch_start_time
        )
        VALUES
        (
            'erp_customer_demo',
            @start_time,
            @end_time,
            DATEDIFF(SECOND, @start_time, @end_time),
            @rows_loaded,
            'SUCCESS',
            @batch_start_time
        );

        /*=================================================
          ERP LOCATION
        =================================================*/

        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze_layer.erp_location;

        BULK INSERT bronze_layer.erp_location
        FROM 'C:\Users\Kibota\Desktop\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SELECT @rows_loaded = COUNT(*)
        FROM bronze_layer.erp_location;

        SET @end_time = GETDATE();

        INSERT INTO bronze_layer.etl_audit_log
        (
            table_name,
            load_start_time,
            load_end_time,
            duration_seconds,
            rows_loaded,
            load_status,
            batch_start_time
        )
        VALUES
        (
            'erp_location',
            @start_time,
            @end_time,
            DATEDIFF(SECOND, @start_time, @end_time),
            @rows_loaded,
            'SUCCESS',
            @batch_start_time
        );

        /*=================================================
          ERP PRODUCT CATEGORY
        =================================================*/

        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze_layer.erp_product_cat;

        BULK INSERT bronze_layer.erp_product_cat
        FROM 'C:\Users\Kibota\Desktop\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SELECT @rows_loaded = COUNT(*)
        FROM bronze_layer.erp_product_cat;

        SET @end_time = GETDATE();

        INSERT INTO bronze_layer.etl_audit_log
        (
            table_name,
            load_start_time,
            load_end_time,
            duration_seconds,
            rows_loaded,
            load_status,
            batch_start_time
        )
        VALUES
        (
            'erp_product_cat',
            @start_time,
            @end_time,
            DATEDIFF(SECOND, @start_time, @end_time),
            @rows_loaded,
            'SUCCESS',
            @batch_start_time
        );

        SET @batch_end_time = GETDATE();

        PRINT '==========================================';
        PRINT 'BRONZE LOAD COMPLETED SUCCESSFULLY';
        PRINT 'TOTAL DURATION (SECONDS): '
            + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS VARCHAR(20));
        PRINT '==========================================';

    END TRY

    BEGIN CATCH

        SET @batch_end_time = GETDATE();

        INSERT INTO bronze_layer.etl_audit_log
        (
            table_name,
            load_status,
            error_message,
            batch_start_time,
            batch_end_time
        )
        VALUES
        (
            'LOAD_BRONZE',
            'FAILED',
            ERROR_MESSAGE(),
            @batch_start_time,
            @batch_end_time
        );

        PRINT '==========================================';
        PRINT 'BRONZE LOAD FAILED';
        PRINT ERROR_MESSAGE();
        PRINT '==========================================';

        THROW;

    END CATCH

END;
GO
