#!/bin/bash

MAX_PRIME=$1
N_THREADS=$2

if [[ "$MAX_PRIME" == "" && "$N_THREADS" == "" ]]; then
  echo "First parameter is max_prime"
  echo "Second parameter is n_threads"
else
  sysbench --test=cpu --cpu-max-prime=$MAX_PRIME --num-threads=$N_THREADS run
fi