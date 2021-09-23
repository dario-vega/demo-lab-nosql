# Please modify the following to variables
export CMP_ID=your_compartment_ocid
export NOSQL_USER_ID=your_user_ocid

export COMP_ID=${CMP_ID}
export NOSQL_COMP_ID=${CMP_ID}
export NOSQL_FINGERPRINT=ab:8c:f1:98:a8:53:d7:1f:ac:2e:92:4a:47:80:1b:f4
export NOSQL_PRIVKEY_FILE=~/NoSQLLabPrivateKey.pem


export NOSQL_ALWAYS_FREE=false
if [ $OCI_REGION == "us-phoenix-1"]
then
  export NOSQL_ALWAYS_FREE=true
fi

if [ $CMP_ID == "your_compartment_ocid" ] || [ $NOSQL_USER_ID == "your_user_ocid" ]
then
  echo "ERROR: Please review the configuration - missing API key parameters"
  return
fi

if  [ ! -e $NOSQL_PRIVKEY_FILE ]
then
  echo "ERROR: Please review the configuration - missing NOSQL_PRIVKEY_FILE file"
  return
fi

echo $OCI_REGION
echo $OCI_TENANCY
echo $NOSQL_USER_ID
echo $NOSQL_FINGERPRINT
echo $NOSQL_PRIVKEY_FILE
echo $NOSQL_COMP_ID

oci nosql table list --compartment-id $NOSQL_COMP_ID > /dev/null
