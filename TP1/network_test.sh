#!/bin/bash

INSTANCE=$1
RESULTS_FILE_NAME="network_test_results.csv"

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

if [ ! -f $RESULTS_FILE_NAME ]; then
  speedtest-cli --csv-header > $RESULTS_FILE_NAME
fi

for iteration in {1..5}; done
  speedtest-cli --csv >> $RESULTS_FILE_NAME
done
