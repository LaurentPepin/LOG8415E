#!/bin/bash


INSTANCE=$1
DISK_PARTITION=$2
TEST_FILE_NAME="./results/IO_read_test_results.csv"
echo "instance","DiskPartition","cachedReadingSpeed","regularReadingSpeed" > $TEST_FILE_NAME


if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

if [[ "$DISK_PARTITION" == "" ]]; then
  echo "First parameter is DISK_PARTITION"
  exit 1
fi

cachedSpeed=0
regularSpeed=0
for iteration in {1..5}; do
  #name of disk partition
  results=$(sudo hdparm -Tt /dev/$DISK_PARTITION  | grep -oP "=.*MB/sec$" | grep -oP "\d+\.*\d+")
  cachedSpeed=$(python -c "print ($(echo $results | cut -d ' ' -f 1) + $cachedSpeed)")
  regularSpeed=$(python -c "print ($(echo $results | cut -d ' ' -f 2) + $regularSpeed)")
done

cachedSpeed=$(python -c "print $cachedSpeed / 5.0")
regularSpeed=$(python -c "print $regularSpeed / 5.0")
echo $INSTANCE,$DISK_PARTITION,$cachedSpeed,$regularSpeed >> $TEST_FILE_NAME