#!/bin/bash

INSTANCE=$1
TEST_FILE_NAME="./results/cpu_results.csv"
REGRESSION_GRAPH_FILE_NAME="./results/cpu_regression_graph_results.csv"

if [ ! -f $TEST_FILE_NAME ]; then
	echo "instance, maxPrime" > $TEST_FILE_NAME
    echo "prime, time" > $REGRESSION_GRAPH_FILE_NAME
fi

if [[ "$INSTANCE" == "" ]]; then
  echo "First parameter is INSTANCE"
  exit 1
fi

maxTime=1
maxNumberOfEvents=1
incrementRate=5
foundPrimeToMaxTime=false
maxPrime=10
lastPrime=0

while [ $foundPrimeToMaxTime != 1 ]; do
    numberOfEvents=$(sysbench --max-time=$maxTime cpu --cpu-max-prime=$maxPrime run | grep "total number of events:" | grep -oP "\d+$")
    echo "Actual prime:"
    echo $maxPrime
    echo "Actual number of events:"
    echo $numberOfEvents
    if (( $numberOfEvents > $maxNumberOfEvents )); then
        lastPrime=$maxPrime
        maxPrime=$(($maxPrime + 10**$incrementRate))
    else
        echo "Busted max with maxPrime:"
        echo $maxPrime
        if [[ $incrementRate -gt 3 ]]; then
            incrementRate=$(($incrementRate-1))
        else 
            foundPrimeToMaxTime=1
        fi
        maxPrime=$lastPrime
    fi
done

echo "Found event limit:"
echo $maxPrime

incrementRate=5
computationThreshold=3
foundMaxPrime=false

while [ $foundMaxPrime != 1 ]; do
    computationTime=$(sysbench --max-time=$maxTime cpu --cpu-max-prime=$maxPrime run | grep "total time:" | grep -oP "\d+.\d+" | cut -d '.' -f1)
    echo "Actual computation time:"
    echo $computationTime
    echo "Actual max prime:"
    echo $maxPrime
    echo $maxPrime, $computationTime >> $REGRESSION_GRAPH_FILE_NAME
    if (( $computationTime < $computationThreshold )); then
        lastPrime=$maxPrime
        maxPrime=$(($maxPrime + 10**$incrementRate))
    else
        echo "Busted threshold with maxPrime:"
        echo $maxPrime
        if [[ $incrementRate -gt 4 ]]; then
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

git add ./results/cpu_regression_graph_results.csv
git add ./results/cpu_results.csv
git commit -m "CPU regression results for $INSTANCE"
git push 
