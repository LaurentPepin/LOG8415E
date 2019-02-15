#!/bin/bash

# Source: https://wiki.ubuntu.com/Kernel/Reference/stress-ng

INSTANCE=$1
RESULTS_FILE_NAME="./results/memory_results.csv"

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

if [ ! -f $RESULTS_FILE_NAME ]; then
	echo "instance,nStressors,memoryErrorsCount" > $RESULTS_FILE_NAME
fi

# Run and increase stressors until we get the first memory error.
memoryErrorsCount=0
nStressors=1
while [[ "$memoryErrorsCount" -lt 11 ]]; do
	result="$(stress-ng --brk $nStressors --stack $nStressors --bigheap $nStressors --metrics-brief --timeout 60s 2>&1)"
echo $result
	memoryErrorsCount=$(echo $result | grep -o "Cannot allocate memory" * | wc -l)
	echo "memoryErrors: "$memoryErrorsCount
    echo $INSTANCE,$nStressors,$memoryErrorsCount >> $RESULTS_FILE_NAME
done
echo "Regression test over"
