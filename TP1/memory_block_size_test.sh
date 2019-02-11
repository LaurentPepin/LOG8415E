#!/bin/bash

INSTANCE=$1
RESULTS_WRITE_FILE_NAME="./results/memory_write_test_results.csv"
RESULTS_READ_FILE_NAME="./results/memory_read_test_results.csv"

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

if [ ! -f $RESULTS_WRITE_FILE_NAME ]; then
  echo "instance,blockSize,speed" > $RESULTS_WRITE_FILE_NAME
fi
if [ ! -f $RESULTS_READ_FILE_NAME ]; then
  echo "instance,blockSize,speed" > $RESULTS_READ_FILE_NAME
fi

# test read
for power in {1..31}; do
  blockSize=$((2**$power))
  speed=0
  for iteration in {1..5}; do
    result=$(python3 -c "print($(sysbench memory --memory-block-size=$blockSize\K \
    --memory-total-size=$blockSize\K \
    --memory-oper=read run|\
    grep "transferred"|\
    grep -oP "\d+\.\d+ MiB/sec"|\
    grep -oP "\d+\.\d+"))")

    if [[ "$result" == "" ]]; then
      echo $INSTANCE,$blockSize,0 >> $RESULTS_READ_FILE_NAME
      break
    else
      speed=$(python3 -c "print($avgSpeed+$result)")
      if [[ "$iteration" == 5 ]]; then
        avgSpeed=$(python3 -c "print($speed /5)")
        echo $INSTANCE,$blockSize,$avgSpeed >> $RESULTS_READ_FILE_NAME
      fi
    fi
  done
done

# write test
for power in {1..31}; do
  blockSize=$((2**$power))
  speed=0
  for iteration in {1..5}; do
    result=$(python3 -c "print($(sysbench memory --memory-block-size=$blockSize\K \
    --memory-total-size=$blockSize\K \
    --memory-oper=write run|\
    grep "transferred"|\
    grep -oP "\d+\.\d+ MiB/sec"|\
    grep -oP "\d+\.\d+"))")

    if [[ "$result" == "" ]]; then
      echo $INSTANCE,$blockSize,0 >> $RESULTS_WRITE_FILE_NAME
      break
    else
      speed=$(python3 -c "print($avgSpeed+$result)")
      if [[ "$iteration" == 5 ]]; then
        avgSpeed=$(python3 -c "print($speed /5)")
        echo $INSTANCE,$blockSize,$avgSpeed >> $RESULTS_WRITE_FILE_NAME
      fi
    fi
  done
done
