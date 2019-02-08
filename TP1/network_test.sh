#!/bin/bash

INSTANCE=$1
RESULTS_FILE_NAME="network_test_results.csv"

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

if [ ! -f $RESULTS_FILE_NAME ]; then
	speedtestHeaders=$(speedtest-cli --csv-header)
	echo Instance,$speedtestHeaders > $RESULTS_FILE_NAME
fi

for iteration in {1..1}; do
	results=$(speedtest-cli --csv)
	echo $INSTANCE,$results >> $RESULTS_FILE_NAME
done
