#!/bin/bash

# Throughput test
# This benchmark tracks the time it took for the entire transfer
# of data from point A to point B

INSTANCE=$1
WRITE_TEST_FILE_NAME="IO_test_results.csv"
echo "instance","blocksize","time" >> $WRITE_TEST_FILE_NAME


if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi


# oflag=dsync This option get rid of caching

for power in {1..34}; do
  blockSize=$((2**$power))
  totalTime=0
  for iteration in {1..5}; do
    totalTime=$(python -c "print $(dd if=/dev/zero of=/tmp/test bs=$blockSize count=1 oflag=dsync 2>&1 | sed 1,2d | cut -d',' -f3 | grep -oP "\d+\.\d+") + $totalTime")
    $(rm /tmp/test)
  done
  totalTime=$(python -c "print $totalTime / 5.0")
  echo $totalTime
  echo $INSTANCE,$blockSize,$totalTime >> $WRITE_TEST_FILE_NAME
done

