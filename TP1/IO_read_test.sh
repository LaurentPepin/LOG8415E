#!/bin/bash


INSTANCE=$1
DISK_PARTITION=$2
TEST_FILE_NAME="IO_test_results.csv"
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
    result=$(sudo hdparm -Tt /dev/$DISK_PARTITION)
    echo $result
    echo $(echo $result  | grep "cached" | grep -oP "=.*" | grep -oP " \d+\.\d+")
    cachedSpeed=$(python -c "print(echo $result  | grep "cached" | grep -oP "=.*" | grep -oP " \d+\.\d+") + $cachedSpeed")
    echo $cachedSpeed
    regularSpeed=$(python -c "print(echo $result  | grep "cached" | grep -oP "=.*" | grep -oP " \d+\.\d+") + $regularSpeed")
done
  cachedSpeed=$(python -c "print $cachedSpeed / 5.0")
  regularSpeed=$(python -c "print $regularSpeed / 5.0")
  echo $INSTANCE,$DISK_PARTITION,$cachedSpeed,$regularSpeed >> $TEST_FILE_NAME
done