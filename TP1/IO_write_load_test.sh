#!/bin/bash


INSTANCE=$1
BLOCK_SIZE=$2
WRITE_TEST_FILE_NAME="IO_write_load_results.csv"

if [ ! -f $WRITE_TEST_FILE_NAME ]; then
	echo "instance","mean_time" > $WRITE_TEST_FILE_NAME
fi

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

if [[ "$BLOCK_SIZE" == "" ]]; then
  echo "second parameter is BLOCK_SIZE"
  exit 1
fi


# oflag=dsync This option get rid of caching
for power in {1..8}; do
  n_iteration=$((10**$power))
  meanTime=0
  for iteration in {1..5}; do
    result=$(dd if=/dev/zero of=/tmp/test bs=$BLOCK_SIZE count=$n_iteration oflag=dsync 2>&1 | sed 1,2d | cut -d ',' -f3 | grep -oP "\d+\.\d+")
    meanTime=$(python -c "print $meanTime + $result")
  done
  meanTime=$(python -c "print $meanTime / 5.0")
  rm /tmp/test
  echo $INSTANCE,$meanTime >> $WRITE_TEST_FILE_NAME
done