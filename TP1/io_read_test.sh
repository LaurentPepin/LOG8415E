#!/bin/bash

INSTANCE=$1
DISK_PARTITION=$2
TEST_FILE_NAME="./results/io_read_test_results_$INSTANCE.csv"
echo "instance","DiskPartition","cachedReadingSpeed","regularReadingSpeed" > $TEST_FILE_NAME


if [[ "$INSTANCE" == "" || "$DISK_PARTITION" == "" ]]; then
  echo "First parameter is INSTANCE"
  echo "Second parameter is DISK_PARTITION"
  exit 1
fi

results=$(sudo hdparm -Tt /dev/$DISK_PARTITION  | grep -oP "=.*MB/sec$" | grep -oP "\d+\.*\d+")
cachedSpeed=$(echo $results | cut -d ' ' -f 1)
regularSpeed=$(echo $results | cut -d ' ' -f 2)

echo $INSTANCE,$DISK_PARTITION,$cachedSpeed,$regularSpeed >> $TEST_FILE_NAME