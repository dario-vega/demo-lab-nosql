mkdir ~/BaggageData
cd ~/BaggageData
curl https://objectstorage.us-ashburn-1.oraclecloud.com/p/WwljGusAgTOa0HNqK7f_8dV0jGo_DzNg7ZnMIlvpDMDbD5PmTcBFDfUut6JvTbiH/n/c4u04/b/data-management-library-files/o/BaggageData.tar.gz -o BaggageData.tar.gz
tar xvzf BaggageData.tar.gz
rm  BaggageData.tar.gz

# Create a file to do a multi line load
rm -f load_multi_line.json
for file in `ls -1 ~/BaggageData/baggage_data* | tail -50`; do
  echo $file
  cat $file | tr '\n' ' ' >> load_multi_line.json
  echo >> load_multi_line.json
done

