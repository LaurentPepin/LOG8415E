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
#minimum of 1024 bytes
# max block size will be 2^31 -> 2GB
for power in {10..31}; do
  blockSize=$((2**$power))
  meanTime=0
  for iteration in {1..5}; do
    # writeTime=$(python -c "print $(dd if=/dev/zero of=/tmp/test bs=$blockSize count=1 oflag=dsync 2>&1 | sed 1,2d | cut -d',' -f4) + $writeTime")
    result=$(dd if=/dev/zero of=/tmp/test bs=$blockSize count=1 oflag=dsync 2>&1 | sed 1,2d | cut -d',' -f4)
    unit=$(echo $result | grep -oP "[a-zA-Z]+B/s$")
    writeTime=$(echo $result | grep -oP "\d+\.*\d+")
    if [[ "$unit" == "kB/s" ]]
    then
      writeTime=$(python -c "print ($writeTime / 1000.0)")
    fi
  meanTime=$(python -c "print $meanTime + $writeTime")
  done
  meanTime=$(python -c "print $meanTime / 5.0")
  echo $meanTime
  rm /tmp/test
  echo $INSTANCE,$blockSize,$writeTime,$readTime >> $WRITE_TEST_FILE_NAME
done

