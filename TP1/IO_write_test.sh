#!/bin/bash

INSTANCE=$1
COUNT=$2
WRITE_TEST_FILE_NAME="./results/IO_write_results.csv"

if [ ! -f $WRITE_TEST_FILE_NAME ]; then
	echo "instance","time" > $WRITE_TEST_FILE_NAME
fi

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

if [[ "$COUNT" == "" ]]; then
  echo "Second parameter is COUNT"
  exit 1
fi

result=$(dd if=/dev/zero of=/tmp/test bs=64K count=$COUNT oflag=dsync 2>&1 | sed 1,2d | cut -d ',' -f3 | grep -oP "\d+\.\d+")
rm /tmp/test
echo $INSTANCE,$result >> $WRITE_TEST_FILE_NAME