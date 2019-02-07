#!/bin/bash

# Throughput test
# This benchmark tracks the time it took for the entire transfer
# of data from point A to point B

INSTANCE=$1
WRITE_TEST_FILE_NAME="IO_test_results.csv"



if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi


# oflag=dsync This option get rid of caching

# for power in {1..34}; do
for power in {1..5}; do
  blockSize=$((2**$power))
  totalTime=0
  # TODO : les unites changent...
  for iteration in {1..5}; do
    totalTime= $(dd if=/dev/zero of=/tmp/test bs=$blockSize count=1 oflag=dsync 2>&1 | sed 1,2d | cut -d',' -f4)
    $(rm /tmp/test)
  done
  # totalTime= totalTime / 34.0
  echo $INSTANCE,$blockSize,$totalTime >> $WRITE_TEST_FILE_NAME
done

