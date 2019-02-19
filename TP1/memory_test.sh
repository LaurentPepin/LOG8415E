#!/bin/bash

INSTANCE=$1
RESULTS_FILE_NAME="./results/memory_test_results_$INSTANCE.csv"

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

if [ ! -f $RESULTS_FILE_NAME ]; then
	echo "instance,brk,stack,bigheap" > $RESULTS_FILE_NAME
fi

nStressors=3

# results are bogo ops/s (real time)

result="$(stress-ng --brk $nStressors --stack $nStressors --bigheap $nStressors --metrics-brief --timeout 60s 2>&1)"
subresult="${result#*] brk }"
brk=$(echo $subresult | cut -d ' ' -f 5)
stack=$(echo $subresult | cut -d ' ' -f 15)
bigheap=$(echo $subresult | cut -d ' ' -f 25)
echo $INSTANCE,$brk,$stack,$bigheap >> $RESULTS_FILE_NAME

