#!/bin/bash

INSTANCE=$1
DISK_PARTITION=$2
WRITE_TEST_FILE_NAME="./results/IO_write_results_$INSTANCE.csv"

if [ ! -f $WRITE_TEST_FILE_NAME ]; then
	echo "instance","time" > $WRITE_TEST_FILE_NAME
fi

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

if [[ "$DISK_PARTITION" == "" ]]; then
  echo "Second parameter is DISK_PARTITION"
  exit 1
fi

result=$(sudo dd if=/dev/zero of=/dev/$DISK_PARTITION bs=64K  oflag=direct 2>&1 | sed 1,3d | cut -d ',' -f3 | grep -oP "\d+.\d+")
echo $INSTANCE,$result >> $WRITE_TEST_FILE_NAME
