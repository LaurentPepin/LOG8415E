nStressors=1
result=$(stress-ng --brk $nStressors --stack $nStressors --bigheap $nStressors --metrics-brief --timeout 30s)

echo $result


    # | grep "total time" | grep -o '[0-9].*[0-9]'