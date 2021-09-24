CMP_ID=`oci iam compartment list --name  demonosql  --compartment-id $OCI_TENANCY | jq -r '."data"[].id'`
# Advanced user, if you deploy in a compartment other than root or root/demonosql, change the following line with the good compartment_ocid and unconmment
# CMP_ID=<your_compartment ocid>

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

