// graphql_oracle_nosql.js
// You need create the following table described in ddl.sql

let express = require('express');
const NoSQLClient = require('oracle-nosqldb').NoSQLClient;
const ServiceType = require('oracle-nosqldb').ServiceType;
const bodyParser = require('body-parser');
const process = require('process');

let app = express();
app.use(bodyParser.json());
let port = process.env.PORT || 3000;

process
.on('SIGTERM', function() {
  console.log("\nTerminating");
  if (client) {
     console.log("\close client SIGTERM");
     client.close();
  }
  process.exit(0);
})
.on('SIGINT', function() {
  console.log("\nTerminating");
  if (client) {
     console.log("\close client SIGINT");
     client.close();
  }
  process.exit(0);
});

// Create a new baggage entry
app.post('/', async (req, res) => {
    try {
        const result = await client.put("demo", req.body );
        res.json({ result: result});
    } catch (err) {
        console.error('failed to insert data', err);
        res.status(500).json({ error: err });
    }
});

// Get a baggage by ticketNo
app.get('/:ticketNo', async (req, res) => {
    const { ticketNo } = req.params;
    try {
        const result = await client.get("demo", { ticketNo })
        res.json(result.row);
    } catch (err) {
        console.error('failed to get data', err);
        res.status(500).json({ error: err });
    }
});

// Delete a  baggage by ticketNo
app.delete('/:ticketNo', async (req, res) => {
    const { ticketNo } = req.params;
    try {
        const result = await client.delete("demo", { ticketNo });
        res.json({ result: result});
    } catch (err) {
        console.error('failed to delete data', err);
        res.status(500).json({ error: err });
    }
});

// Get all  baggage with pagination
app.get('/', async function (req, resW) {
    let statement = `SELECT * FROM demo`;
    const rows = [];

    let offset;

    const page = parseInt(req.query.page);
    const limit = parseInt(req.query.limit);
    const orderby = req.query.orderby;
    if (page)
      console.log (page)
    if (orderby )
      statement = statement + " ORDER BY " + orderby;
    if (limit)
      statement = statement + " LIMIT " + limit;
    if (page) {
      offset = page*limit;
      statement = statement + " OFFSET " + offset;
    }

  
    try {
      let cnt ;
      let res;
      do {
         res = await client.query(statement, { continuationKey:cnt});
         rows.push.apply(rows, res.rows);
         cnt = res.continuationKey;
      } while(res.continuationKey != null);
      resW.send(rows)
    } catch (err){
        console.error('failed to select data', err);
        resW.sendStatus(500).json({ error: err });
    } finally {
    }
  });

  app.listen(port);
  client = createClient();
  console.log('Application running!');


function createClient() {
  console.log (process.env.OCI_REGION)  
  console.log (process.env.COMP_ID) 
  return new NoSQLClient({
      region: process.env.OCI_REGION,
      compartment:process.env.NOSQL_COMP_ID,
            auth: {
                iam: {
                    tenantId: process.env.OCI_TENANCY,
                    userId: process.env.NOSQL_USER_ID,
                    fingerprint: process.env.NOSQL_FINGERPRINT,
                    privateKeyFile: 'NoSQLprivateKey.pem'
                }
            }
        });
}
/*
function createClient() {
  console.log (process.env.OCI_REGION)  
  console.log (process.env.COMP_ID)  
  return  new NoSQLClient({
    region: process.env.OCI_REGION,
    compartment:process.env.COMP_ID,
    auth: {
        iam: {
            useInstancePrincipal: true
        }
    }
  });
}
*/
