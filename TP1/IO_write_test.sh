#!/bin/bash


INSTANCE=$1
WRITE_TEST_FILE_NAME="IO_test_results.csv"

if [ ! -f $WRITE_TEST_FILE_NAME ]; then
	echo "instance","blocksize","writeTime,readTime" > $WRITE_TEST_FILE_NAME
fi

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi


# oflag=dsync This option get rid of caching
# max block size will be 2^31 -> 2GB
for power in {1..31}; do
  blockSize=$((2**$power))
  writeTime=0
  for iteration in {1..5}; do
    writeTime=$(python -c "print $(dd if=/dev/zero of=/tmp/test bs=$blockSize count=1 oflag=dsync 2>&1 | sed 1,2d | cut -d',' -f3 | grep -oP "\d+\.\d+") + $writeTime")
  done
  writeTime=$(python -c "print $writeTime / 5.0")
  rm /tmp/test
  echo $INSTANCE,$blockSize,$writeTime,$readTime >> $WRITE_TEST_FILE_NAME
done

