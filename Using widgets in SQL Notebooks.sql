-- Databricks notebook source
-- MAGIC %md #### Create a text widget "country" with a default value of USA

-- COMMAND ----------

CREATE WIDGET TEXT country DEFAULT 'USA'

-- COMMAND ----------

-- MAGIC %md #### Remove 'country' widget

-- COMMAND ----------

REMOVE WIDGET country

-- COMMAND ----------

-- MAGIC %md #### Create a Dropdown widget "countries" with a default value of "USA" and multiple values to select from

-- COMMAND ----------

CREATE WIDGET DROPDOWN countries DEFAULT 'USA' CHOICES SELECT country FROM (SELECT 'USA' AS country UNION ALL SELECT 'Canada' AS country) as dat

-- COMMAND ----------

-- MAGIC %md #### Remove 'countries' widget

-- COMMAND ----------

REMOVE WIDGET countries

-- COMMAND ----------

-- MAGIC %md #### Now we will look into passing widget values to a SQL query. There are 2 options for getting the widget values <ol><li>getArgument</li><li>$parameter</li></ol> <br />
-- MAGIC To use the widget values as parameters, I am going to create a dataframe. Once the data frame is created we will create a temporary view from the data Frame. As part of the last step, we will pass the widget value to the Temporary view and filter down the results. Creation of data frame and temporary view will be completed in python using the magic command %python. The filtering of the temporary view using the parameter values will be completed in SQL

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

-- MAGIC %md #### Create a Dropdown widget 'country' based on the values from the vw_population view

-- COMMAND ----------

CREATE WIDGET DROPDOWN country DEFAULT 'United States' CHOICES SELECT DISTINCT country FROM vw_population

-- COMMAND ----------

-- MAGIC %md #### Add a where clause to the temporary view based on the value from the the 'country" filter using getArgument

-- COMMAND ----------

SELECT population, getArgument("country") as country FROM vw_population WHERE country = getArgument("country")

-- COMMAND ----------

-- MAGIC %md #### Add a where clause to the temporary view based on the value from the the 'country" filter using $parameter

-- COMMAND ----------

SELECT population, '$country' as country FROM vw_population WHERE country = '$country'

-- COMMAND ----------

-- MAGIC %md #### Remove 'country' widgets

-- COMMAND ----------

REMOVE WIDGET country

-- COMMAND ----------

-- MAGIC %md #### Create a Multi Select widget 'country_multiselect' by using values from the vw_population view

-- COMMAND ----------

CREATE WIDGET MULTISELECT country_multiselect DEFAULT 'United States' CHOICES SELECT DISTINCT country FROM vw_population

-- COMMAND ----------

-- MAGIC %md #### Create a Combo Box widget 'country_combobox' by using values from the vw_population view

-- COMMAND ----------

CREATE WIDGET COMBOBOX country_combobox DEFAULT 'United States' CHOICES SELECT DISTINCT country FROM vw_population

-- COMMAND ----------

-- MAGIC %md #### Get selected value of the Combo Box widget 'country_combobox'

-- COMMAND ----------

SELECT '$country_combobox' As country

-- COMMAND ----------

-- MAGIC %md #### Get selected value of the Multi Select widget 'country_multiselect'

-- COMMAND ----------

SELECT '$country_multiselect' AS countries

-- COMMAND ----------

-- MAGIC %md #### Remove all the widgets

-- COMMAND ----------

REMOVE WIDGET country

-- COMMAND ----------

REMOVE WIDGET country_combobox

-- COMMAND ----------

REMOVE WIDGET country_multiselect
