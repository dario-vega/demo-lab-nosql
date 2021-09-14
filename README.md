# WORKSHOP OUTLINE
1. Setup - 2 minutes
2. NoSQL - 20 minutes
3. Execute and Review Code Node.js - express - 20 minutes

## LAB1 - Setup - 2 minutes

### Step 1. Create a compartment 
Go to OCI console -> Identity & Security -> Compartments.

Click on Create Compartment. This opens up a new window.

Choose **demonosql** as compartment name, choose a description and add it.

### Step 2. Create an API Key

Click on your Profile -> User Settings. Copy your OCID


Open the Cloud Shell (click in the icon > ) in the top right menu

Note: need to be executed in the HOME region


Replace < yourUserOCID > before to execute the following commands

````
openssl genrsa -out NoSQLLabPrivateKey.pem  4096        
openssl rsa -pubout -in NoSQLLabPrivateKey.pem -out NoSQLLabPublicKey.pem
oci iam user api-key upload --user-id <yourUserOCID> --key-file NoSQLLabPublicKey.pem > info.json

````

### Step 3. Cloud Shell Configuration - clone github, execute shell data.sh and setup the fn env.

Open the Cloud Shell (click in the icon > ) in the top right menu

Note: need to be executed in the PHOENIX region
  

````
git clone https://github.com/dario-vega/demo-lab-nosql
sh ~/demo-lab-nosql/data.sh
cp ~/NoSQLLabPrivateKey.pem  ~/demo-lab-nosql/express-nosql
cp ~/info.json ~/demo-lab-nosql/express-nosql
 
````


## LAB2 NoSQL - 20 minutes

### Step 1. NoSQL Tables Deployment -- Always Free

Open the Cloud Shell (click in the icon > ) in the top right menu. Use the following instructions

Note: need to be executed in the PHOENIX region


Creating NoSQL tables using oci-cli - DDL for create tables in this [directory](./objects) (e.g demo.nosql)
```
source ~/demo-lab-nosql/env.sh
cd ~/demo-lab-nosql/objects/
````

````
DDL_TABLE=$(cat demo.nosql)
echo $DDL_TABLE
````

````
oci nosql table create --compartment-id "$COMP_ID"   \
--name demo --ddl-statement "$DDL_TABLE" \
--table-limits="{\"maxReadUnits\": 50,  \"maxStorageInGBs\": 25,  \"maxWriteUnits\": 50 }" \
--is-auto-reclaimable true \
--wait-for-state SUCCEEDED
````

````
DDL_TABLE=$(cat demoKeyVal.nosql)
echo $DDL_TABLE
````

````
oci nosql table create --compartment-id "$COMP_ID"   \
--name demoKeyVal  --ddl-statement "$DDL_TABLE" \
--table-limits="{\"maxReadUnits\": 50,  \"maxStorageInGBs\": 25,  \"maxWriteUnits\": 50 }" \
--is-auto-reclaimable true \
--wait-for-state SUCCEEDED
````

Minimize Shell Cloud Console

### Step 2. Adding Data to the NoSQL table from the OCI Console 

Go to OCI console -> Databases -> Oracle NoSQL Database - Tables

On the left List Scope - Compartment - choose demonosql compartment

Click on demo table

Click on Insert Row. This opens up a new window. Choose Advanced Json Input 

Copy/Paste the json Baggage document in JSON input text box

Click on Insert ROw

````
{
  "fullName" : "Abram Falls",
  "contactPhone" : "921-284-5378",
  "ticketNo" : "176233524485",
  "confNo" : "HP1D4H",
  "gender" : "F",
  "bagInfo" : [ {
    "id" : "79039899127071",
    "tagNum" : "17657806285185",
    "routing" : "SYD/SIN/LHR",
    "lastActionCode" : "OFFLOAD",
    "lastActionDesc" : "OFFLOAD",
    "lastSeenStation" : "LHR",
    "flightLegs" : [ {
      "flightNo" : "BM254",
      "flightDate" : "2019.02.28 at 22:00:00 AEDT",
      "fltRouteSrc" : "SYD",
      "fltRouteDest" : "SIN",
      "estimatedArrival" : "2019.03.01 at 03:00:00 SGT",
      "actions" : [ {
        "actionAt" : "SYD",
        "actionCode" : "ONLOAD to SIN",
        "actionTime" : "2019.02.28 at 22:09:00 AEDT"
      }, {
        "actionAt" : "SYD",
        "actionCode" : "BagTag Scan at SYD",
        "actionTime" : "2019.02.28 at 21:51:00 AEDT"
      }, {
        "actionAt" : "SYD",
        "actionCode" : "Checkin at SYD",
        "actionTime" : "2019.02.28 at 20:06:00 AEDT"
      } ]
    }, {
      "flightNo" : "BM272",
      "flightDate" : "2019.02.28 at 19:09:00 SGT",
      "fltRouteSrc" : "SIN",
      "fltRouteDest" : "LHR",
      "estimatedArrival" : "2019.03.01 at 03:10:00 GMT",
      "actions" : [ {
        "actionAt" : "LHR",
        "actionCode" : "Offload to Carousel at LHR",
        "actionTime" : "2019.03.01 at 03:01:00 GMT"
      }, {
        "actionAt" : "SIN",
        "actionCode" : "ONLOAD to LHR",
        "actionTime" : "2019.03.01 at 11:20:00 SGT"
      }, {
        "actionAt" : "SIN",
        "actionCode" : "OFFLOAD from SIN",
        "actionTime" : "2019.03.01 at 11:10:00 SGT"
      } ]
    } ],
    "lastSeenTimeGmt" : "2019.03.01 at 03:06:00 GMT",
    "bagArrivalDate" : "2019.03.01 at 03:06:00 GMT"
  } ]
}
````

### Step 3.  Show data from the Console

On the left Click on Table Rows

In the textbox Query, keep the text SELECT * FROM demo

Click on Run query 

## LAB3  Read and Load data using a Python CLI application

````
source ~/demo-lab-nosql/env.sh
cd ~/demo-lab-nosql/
pip3 install borneo
pip3 install cmd2
python3 nosql.py -s cloud -t $OCI_TENANCY -u $NOSQL_USER_ID -f $NOSQL_FINGERPRINT -k ~/NoSQLLabPrivateKey.pem -e https://nosql.${OCI_REGION}.oci.oraclecloud.com

````
You can also load data using the following command

````
load ../BaggageData/load_multi_line.json demo
````


## LAB4  Execute and Review Code Node.js express  - 20 minutes

````
source ~/demo-lab-nosql/env.sh
````

Run the express_oracle_nosql application

````
cd ~/demo-lab-nosql/express-nosql
npm install
node express_oracle_nosql.js &
````

Execute the API request

Insert Data in demo table

````
FILE_NAME=`ls -1 ~/BaggageData/baggage_data_file99.json`
echo $FILE_NAME
curl -X POST -H "Content-Type: application/json" -d @$FILE_NAME http://localhost:3000
````

Insert Data in demoKeyVal table

````
curl -X POST -H "Content-Type: application/json" -d @$FILE_NAME http://localhost:3000/demoKeyVal
````


Read Data from demo table

````
curl -X GET http://localhost:3000  | jq
````
````
curl  "http://localhost:3000/?limit=3&orderby=ticketNo"  | jq
````
````
curl  "http://localhost:3000/?limit=12&orderby=fullName"  | jq
````

Read Data for a specific TicketNumber using GET command


````
curl -X GET http://localhost:3000/1762322446040  | jq
````

DELETE Data for a specific TicketNumber 

````
curl -X DELETE http://localhost:3000/1762322446040  | jq
````

👷 BUILD SPECIFIC to APIS and running using Instance principal

````
function createClient() {
  return  new NoSQLClient({
    region: process.env.OCI_REGION,
    compartment:process.env.NOSQL_COMP_ID,
    auth: {
        iam: {
            useInstancePrincipal: true
        }
    }
  });
}
````


