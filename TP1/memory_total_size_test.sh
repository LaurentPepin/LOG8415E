#!/bin/bash

INSTANCE=$1
BLOCK_SIZE=$2
RESULTS_WRITE_FILE_NAME="./results/memory_total_write_test_results.csv"
RESULTS_READ_FILE_NAME="./results/memory_total_read_test_results.csv"

if [[ "$INSTANCE" == "" || "$BLOCK_SIZE" == "" ]]; then
  echo "First parameter is INSTANCE"
  echo "Second parameter is block size (KB)"
  exit 1
fi

if [ ! -f $RESULTS_WRITE_FILE_NAME ]; then
  echo "instance,totalSize,time,blockSize" > $RESULTS_WRITE_FILE_NAME
fi
if [ ! -f $RESULTS_READ_FILE_NAME ]; then
  echo "instance,totalSize,time,blockSize" > $RESULTS_READ_FILE_NAME
fi

# test read
for power in {0..9}; do
  totalSize=$(((10**$power)*$BLOCK_SIZE))
  avgTime=0
  for iteration in {1..5}; do
    result=$(python3 -c "print($(sysbench memory --memory-block-size=$BLOCK_SIZE\K \
    --memory-total-size=$totalSize\K \
    --memory-oper=read run|\
    grep "total time:" |grep -oP "\d+\.\d+"))")

    time=$(python3 -c "print($time+$result)")
	if [[ "$iteration" == 5 ]]; then
        avgTime=$(python3 -c "print($time /5)")
		echo $INSTANCE,$totalSize,$avgTime,$BLOCK_SIZE >> $RESULTS_READ_FILE_NAME
	fi
  done
done
