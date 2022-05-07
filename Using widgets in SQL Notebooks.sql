-- Databricks notebook source
-- MAGIC %md #### Create text widget with the name "country" with a default value of USA

-- COMMAND ----------

CREATE WIDGET TEXT country DEFAULT 'USA'

-- COMMAND ----------

-- MAGIC %md #### Remove 'country' widgets

-- COMMAND ----------

REMOVE WIDGET country

-- COMMAND ----------

-- MAGIC %md #### Create Dropdown widget with the name "countries" with a default value of "USA" and multiple values to select from

-- COMMAND ----------

CREATE WIDGET DROPDOWN countries DEFAULT 'USA' CHOICES SELECT country FROM (SELECT 'USA' AS country UNION ALL SELECT 'Canada' AS country) as dat

-- COMMAND ----------

-- MAGIC %md #### Remove 'countries' widgets

-- COMMAND ----------

REMOVE WIDGET countries

-- COMMAND ----------

-- MAGIC %md #### Passing widget values to a SQL query. <br/><br/> We have 2 Options :- 1. getArgument 2. $parameter
-- MAGIC <br/>To use the widget values as parameters I am going to create a dataframe. On top of the Dataframe we will create a temporary view. < br/> AS part of the last step, we will pass the widget value to the Temporary view and ifilter down the resoults. 
-- MAGIC <br/>Creation of Data frame and temporary view will be done in python. The filtering of the temporary view will be done in SQL

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dataframe_data = [("China","1410539758"),("Nigeria","225082083"),("India","1389637446"),("Brazil","217240060"),("United States","332838183"),("Bangladesh","165650475"),("Indonesia","277329163"),("Russia","142021981"),("Pakistan","242923845"),("Mexico","129150971")]
-- MAGIC dataframe_columns = ['country', 'population']
-- MAGIC dfPopulation = spark.createDataFrame(dataframe_data, dataframe_columns)
-- MAGIC display(dfPopulation)

-- COMMAND ----------

-- MAGIC %python
-- MAGIC dfPopulation.createOrReplaceTempView('vw_population')

-- COMMAND ----------

SELECT * FROM vw_population

-- COMMAND ----------

-- MAGIC %md #### Create a Dropdown widget 'country' by using values from the vw_population view

-- COMMAND ----------

CREATE WIDGET DROPDOWN country DEFAULT 'United States' CHOICES SELECT DISTINCT country FROM vw_population

-- COMMAND ----------

SELECT population, getArgument("country") as country FROM vw_population WHERE country = getArgument("country")

-- COMMAND ----------

SELECT population, '$country' as country FROM vw_population WHERE country = '$country'

-- COMMAND ----------

-- MAGIC %md #### Remove 'country' widgets

-- COMMAND ----------

REMOVE WIDGET country
