#!/bin/bash

INSTANCE=$1
WRITE_TEST_FILE_NAME="IO_write_test_results.csv"
READ_TEST_FILE_NAME="IO_read_test_results.csv"



if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

#Throughput test
# analyze the rate at which the storage system delivers data
# oflag=dsync This option get rid of caching

#write
for power in {1..9}; do
  blockSize=$((8**$power))
  for iteration in {1..5}; do
  totalTime=$(dd if=/dev/zero of=/tmp/test bs=$blockSize count=1 oflag=dsync | grep "MB/S" | grep -oP ",\d+\.\d+MB/S" | grep -oP "\d+\.\d+" )
    echo $INSTANCE,$blockSize,$totalTime >> $WRITE_TEST_FILE_NAME
  done
done

#read
for power in {1..9}; do
  blockSize=$((8**$power))
  for iteration in {1..5}; do
  totalTime=$(dd if=/dev/zero of=/tmp/test bs=$blockSize count=1 oflag=dsync | grep "MB/S" | grep -oP ",\d+\.\d+MB/S" | grep -oP "\d+\.\d+" )
    echo $INSTANCE,$blockSize,$totalTime >> $READ_TEST_FILE_NAME
  done
done
