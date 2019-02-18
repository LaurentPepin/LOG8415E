#!/bin/bash

# latency test
# This benchmark tracks the time it take between request and response

INSTANCE=$1
TEST_FILE_NAME="./results/IO_latency_test_result.csv"

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

if [ ! -f $TEST_FILE_NAME ]; then
	echo "instance","latencyAvg" > $TEST_FILE_NAME
fi

LATENCY=$(ioping -c 10 ./ | grep -P "avg" | cut -d'/' -f6)

echo $INSTANCE,$LATENCY >> $TEST_FILE_NAME
