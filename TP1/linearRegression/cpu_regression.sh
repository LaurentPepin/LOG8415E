#!/bin/bash

INSTANCE=$1
TEST_FILE_NAME="./results/cpu_results.csv"

if [ ! -f $TEST_FILE_NAME ]; then
	echo "instance, maxPrime" > $TEST_FILE_NAME
fi

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

maxTime=600000
maxNumberOfEvents=1
incrementRate=8
foundMaxPrime=false
maxPrime=1
lastPrime=0

while [ $foundMaxPrime != 1 ]; do
    numberOfEvents=$(sysbench --max-time=$maxTime cpu --cpu-max-prime=$maxPrime run | grep "total number of events:" | grep -oP "\d+$")
    if (( $numberOfEvents > $maxNumberOfEvents )); then
        lastPrime=$maxPrime
        maxPrime=$(($maxPrime + 10**$incrementRate))
    else
        echo "Busted max with maxPrime:"
        echo $maxPrime
        if [[ $incrementRate -gt 3 ]]; then
            incrementRate=$(($incrementRate-1))
        else 
            foundMaxPrime=1
        fi
        maxPrime=$lastPrime
    fi
done

echo "Regression test over"
echo "maxPrime is:"
echo $maxPrime
echo $INSTANCE,$maxPrime >> $TEST_FILE_NAME