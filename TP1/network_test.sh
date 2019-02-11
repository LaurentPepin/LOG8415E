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
	echo Instance,Ping,Download,Upload > $RESULTS_FILE_NAME
fi

# Results are in bit/s according to https://www.mankier.com/1/speedtest-cli#--bytes
ping=0
download=0
upload=0
for iteration in {1..5}; do
	results=$(speedtest-cli --csv --server $SERVERID)
	ping=$(python -c "print $(echo $results | cut -d ',' -f 7) + $ping")
	download=$(python -c "print $(echo $results | cut -d ',' -f 8) + $download")
	upload=$(python -c "print $(echo $results | cut -d ',' -f 9) + $upload")
done

echo $INSTANCE,$ping,$download,$upload >> $RESULTS_FILE_NAME
