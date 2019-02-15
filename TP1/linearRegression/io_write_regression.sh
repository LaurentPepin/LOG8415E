#!/bin/bash

INSTANCE=$1
WRITE_TEST_FILE_NAME="./results/IO_results.csv"
REGRESSION_GRAPH_FILE_NAME="./results/IO_regression_graph_results.csv"

if [ ! -f $WRITE_TEST_FILE_NAME ]; then
	echo "instance, maxCount" > $WRITE_TEST_FILE_NAME
    echo "count, transferTime" > $REGRESSION_GRAPH_FILE_NAME
fi

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

maxTime=600
incrementRate=5
foundMaxCount=false
count=0
lastCount=0

while [ $foundMaxCount != 1 ]; do
    transferTime=$(dd if=/dev/zero of=/tmp/test bs=64K count=$count conv=fdatasync 2>&1 | sed 1,2d | cut -d ',' -f3 | grep -oP "\d+\.\d+" | cut -d '.' -f1)
    rm /tmp/test
    echo "Actual transfer time:"
    echo $transferTime
    echo "Actual count:"
    echo $count
    echo $count, $transferTime >> $REGRESSION_GRAPH_FILE_NAME
    if (( $transferTime > $maxTime )); then
        echo "Busted Max Time with count:"
        echo $count
        if [[ $incrementRate -gt 3 ]]; then
            incrementRate=$(($incrementRate-1))
        else 
            foundMaxCount=1
        fi
        count=$lastCount
    else
        lastCount=$count
        count=$(($count + 10**$incrementRate))
    fi
done
echo "Regression test over"
echo "Count is:"
echo $count
echo $INSTANCE,$count >> $WRITE_TEST_FILE_NAME

git add ./results/IO_regression_graph_results.csv
git add ./results/IO_results.csv
git commit -m "IO regression results for $INSTANCE"
git push 
