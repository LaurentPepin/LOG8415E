#!/bin/bash


sudo apt-get install sysbench --yes

MAX_PRIME = 10


sysbench --test=cpu --cpu-max-prime=$MAX_PRIME run | grep "total time"
