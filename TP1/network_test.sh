#!/bin/bash

INSTANCE=$1
SERVERID=$2
RESULTS_FILE_NAME="network_test_results.csv"

if [[ "$INSTANCE" == "" || "$SERVERID" == "" ]]; then
  echo "First parameter is INSTANCE"
  echo "Second parameter is SERVERID, find it with speedtest-cli --list"
  exit 1
fi

if [ ! -f $RESULTS_FILE_NAME ]; then
	speedtestHeaders=$(speedtest-cli --csv-header)
	echo Instance,$speedtestHeaders > $RESULTS_FILE_NAME
fi

# Results are in bit/s according to https://www.mankier.com/1/speedtest-cli#--bytes
for iteration in {1..5}; do
	results=$(speedtest-cli --csv --server $SERVERID)
	echo $INSTANCE,$results >> $RESULTS_FILE_NAME
done
