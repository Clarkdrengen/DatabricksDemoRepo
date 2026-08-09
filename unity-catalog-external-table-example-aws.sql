-- Databricks notebook source
-- MAGIC %md
-- MAGIC # Create an external table in Unity Catalog
-- MAGIC
-- MAGIC This notebook shows how to create an external table in Unity Catalog from a Delta table in the `samples` catalog. The data for an external table is stored in a path in your cloud tenant's storage, outside the default storage location for a metastore. When you drop an external table, its underlying data is not deleted.
-- MAGIC
-- MAGIC This notebook assumes that you've already created a storage credential and external location using the AWS Quickstart template. The external location has the name `example_location`.

-- COMMAND ----------

-- Create an example catalog and schema to contain the new table
CREATE CATALOG IF NOT EXISTS example_catalog;
USE CATALOG example_catalog;
CREATE SCHEMA IF NOT EXISTS example_schema;
USE example_schema;

-- COMMAND ----------

-- Grant access to create tables in the external location
GRANT USE CATALOG
ON de_labs
TO `all users`;

GRANT USE SCHEMA
ON de_labs.example_schema
TO `all users`;

GRANT CREATE EXTERNAL TABLE
ON LOCATION example_location
TO `all users`;

-- COMMAND ----------

-- Create a new external Unity Catalog table from an existing table
-- Replace <bucket_path> with the storage location where the table will be created
CREATE TABLE IF NOT EXISTS trips_external
LOCATION 's3://<bucket_path>'
AS SELECT * from samples.nyctaxi.trips;

-- To use a storage credential directly, add 'WITH (CREDENTIAL <credential_name>)' to the SQL statement.

-- COMMAND ----------

-- Describe the new table
DESCRIBE TABLE EXTENDED trips_external;

-- COMMAND ----------

-- Select from the new table
SELECT * from de_labs.example_schema.trips_external;

-- COMMAND ----------

-- Drop the table. The underlying data files are not removed from cloud storage.
DROP TABLE IF EXISTS trips_external;