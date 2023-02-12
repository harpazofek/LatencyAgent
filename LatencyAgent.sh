#!/bin/bash

TEST_PERIODICITY=5
DB_USERNAME="admin"
DB_PASSWORD="12345678"

#Error Code For debug
#E_TRESULTS=86   # Test results not found
#E_LRESULTS=87    # Latency results not found

echo "Please enter your root password (This password wosn't save in the sysyem)"
sudo echo "This script will be running only with root permissions"

# Use a for loop to run the containers
sudo docker run --rm --name influxdb -p 8086:8086 -e INFLUXDB_ADMIN_USER=admin -e INFLUXDB_ADMIN_PASSWORD=12345678 -e INFLUXDB_HTTP_AUTH_ENABLED=true influxdb:1.8.10 >> influx.log 2>&1 &
echo "Running influx docker is $?"
sleep 5s
#create a database named hosts_metrics in which the test data will be stored
curl -X POST 'http://localhost:8086/query' -u admin:12345678 --data-urlencode "q=CREATE DATABASE hosts_metrics" >> authinflux.log 2>&1 &
echo Create DB hosts_metrics is $?
sleep 2s
#Run Grafana server in a Docker con
sudo docker run --rm --name grafana -e "GF_SERVER_HTTP_PORT=3003" --network host grafana/grafana-oss >> grafana.log 2>&1 &
echo "Grafana docker is running $?"
sleep 5s

while true; do  #while loop forever
  while read line; do
  results=$(ping -c 1 -W 2 "$line") #This variable was print the ping for each line into the hosts file
  latency=$(echo "$results" | grep -oP '(?<=time=)\d+(\.\d+)?')
  test_results=$?
  time=$(date +%s%N) #The date CMD cat the timestamp in nanoseconds
  if [ $test_results -eq 0 ]; then #Present the test results
    test_results=1
  else
    test_results=0
    #exit $E_TRESULTS
  fi
  if [ -n "$latency" ]; #latency verifications
  then
   latency="$latency"
  else
    latency=0
    #exit $E_LRESULTS
  fi
#echo the test results and latency to stdout
  echo "Test result for $line is $test_results at $time"
  echo latency= "$latency"
#write the test results to InfluxDB
  curl -X POST 'http://localhost:8086/write?db=hosts_metrics' -u $DB_USERNAME:$DB_PASSWORD  --data-binary "availability_test,host=$line value=$latency"

done < hosts  #hosts present the file that i want to read
echo  "Send the results to the DB"
sleep $TEST_PERIODICITY
done
