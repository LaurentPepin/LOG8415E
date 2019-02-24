#!/bin/bash

# latency test
# This benchmark tracks the time it take between request and response

INSTANCE=$1
TEST_FILE_NAME="./results/IO_latency_test_result.csv"
echo "instance","latencyAvg" > $TEST_FILE_NAME

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

LATENCY=$(ioping -c 100 ./ | grep -P "avg" | cut -d'/' -f6)

echo $INSTANCE,$LATENCY >> $TEST_FILE_NAME
