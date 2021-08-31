# WORKSHOP OUTLINE
1. Setup - 10 minutes
2. NoSQL - 20 minutes
3. Execute and Review Code Functions - 20 minutes

## LAB1 - Setup - 2 minutes

### Step 1. Create a compartment 
Go to OCI console -> Identity & Security -> Compartments.

Click on Create Compartment. This opens up a new window.

Choose **demonosql** as compartment name, choose a description and add it.

### Step 2. Cloud Shell Configuration - clone github, execute shell data.sh and setup the fn env.

Open the Cloud Shell (click in the icon > ) in the top right menu

````
git clone https://github.com/dario-vega/demo-lab-nosql
sh ~/demo-lab-nosql/data.sh
````


## LAB2 NoSQL - 20 minutes

### Step 1. NoSQL Tables Deployment -- Always Free

Open the Cloud Shell (click in the icon > ) in the top right menu. Use the following instructions


Creating NoSQL tables using oci-cli - DDL for create tables in this [directory](./objects) (e.g demo.nosql)
```
cd ~/demo-lab-nosql/objects
CMP_ID=`oci iam compartment list --name  demonosql | jq -r '."data"[].id'`
COMP_ID=${CMP_ID-$OCI_TENANCY}
echo $COMP_ID
DDL_TABLE=$(cat demo.nosql)
echo $DDL_TABLE

oci nosql table create --compartment-id "$COMP_ID"   \
--name demo --ddl-statement "$DDL_TABLE" \
--table-limits="{\"maxReadUnits\": 50,  \"maxStorageInGBs\": 25,  \"maxWriteUnits\": 50 }" \
--is-auto-reclaimable true \
--wait-for-state SUCCEEDED

DDL_TABLE=$(cat demoKeyVal.nosql)
echo $DDL_TABLE

oci nosql table create --compartment-id "$COMP_ID"   \
--name demoKeyVal  --ddl-statement "$DDL_TABLE" \
--table-limits="{\"maxReadUnits\": 50,  \"maxStorageInGBs\": 25,  \"maxWriteUnits\": 50 }" \
--is-auto-reclaimable true \
--wait-for-state SUCCEEDED

```

This section is for information purpose only: How to create a NoSQL tables Using Terraform.

```
## This configuration was generated by terraform-provider-oci

resource oci_nosql_table export_demoKeyVal {
  compartment_id = var.compartment_ocid
  ddl_statement  = "CREATE TABLE IF NOT EXISTS demoKeyVal ( key INTEGER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1 NO CYCLE ), value JSON, PRIMARY KEY (key))"
  defined_tags = {
  }
  freeform_tags = {
  }
  is_auto_reclaimable = "true"
  name                = "demoKeyVal"
  table_limits {
    max_read_units     = "10"
    max_storage_in_gbs = "1"
    max_write_units    = "10"
  }
}


resource oci_nosql_table export_demo {
  compartment_id = var.compartment_ocid
  ddl_statement  = "CREATE TABLE if not exists demo(\n  fullName     STRING,\n  contactPhone STRING,\n  ticketNo     STRING,\n  confNo       STRING,\n  gender       STRING,\n  bagInfo      JSON,\n PRIMARY KEY ( ticketNo )\n )"
  defined_tags = {
  }
  freeform_tags = {
  }
  is_auto_reclaimable = "true"
  name                = "demo"
  table_limits {
    max_read_units     = "10"
    max_storage_in_gbs = "1"
    max_write_units    = "10"
  }
}

```

Minimize Shell Cloud Console

### Step 2. Adding Data to the NoSQL table from the OCI Console 

Go to OCI console -> Databases -> Oracle NoSQL Database - Tables

On the left List Scope - Compartment - choose demonosql compartment

Click on demo table

Click on Insert Row. This opens up a new window. Choose Advanced Json Input 

Copy/Paste the json Baggage document in JSON input text box

Click on Insert ROw

### Step 3.  Show data from the Console

On the left Click on Table Rows

In the textbox Query, keep the text SELECT * FROM demo

Click on Run query 

###  Show queries - Working in progress

```
cd ~/demo-lab-baggage/objects
cat queries.sql

```

## LAB3  Execute and Review Code Node.js express  - 20 minutes


