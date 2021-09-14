export APP_NAME="nosql_demos"
CMP_ID=`oci iam compartment list --name  demonosql | jq -r '."data"[].id'`
# Advanced user, if you deploy in a compartment other than root or root/demonosql, change the following line with the good compartment_ocid and unconmmented
# CMP_ID=<your_compartment ocid>
export COMP_ID=${CMP_ID-$OCI_TENANCY}

export COMP_ID=${CMP_ID-$OCI_TENANCY}
export NOSQL_COMP_ID=${CMP_ID-$OCI_TENANCY}
export NOSQL_USER_ID=`cat ~/info.json | jq -r '."data"."user-id"'`
export NOSQL_FINGERPRINT=`cat ~/info.json | jq -r '."data"."fingerprint"'`
export NOSQL_PRIVKEY_FILE=~/NoSQLLabPrivateKey.pem
echo $OCI_REGION
echo $OCI_TENANCY
echo $NOSQL_USER_ID
echo $NOSQL_FINGERPRINT
echo $NOSQL_PRIVKEY_FILE
echo $NOSQL_COMP_ID

if [ ! -e ~/.ignore_serverless-with-nosql-database_conf_review ]
then
  echo Validating YOUR Environment
  TEST_NOSQLTABLES=`oci nosql table list --compartment-id $COMP_ID | jq '.data.items[].name ' | wc -l`
  TEST_FUNCTIONS=`oci fn application  list --compartment-id $COMP_ID | jq '.data[]."display-name"' |wc -l`
  if [ $TEST_NOSQLTABLES -le 0 ] || [ $TEST_FUNCTIONS -le 0 ]
  then
     echo "ERROR: Please review the configuration"
  else
     echo "Configuration succesfully reviewed"
     touch ~/.ignore_serverless-with-nosql-database_conf_review
  fi
fi
