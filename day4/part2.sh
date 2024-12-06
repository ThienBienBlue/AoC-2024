#!/bin/bash

if [[ -z "$1" ]]; then
    echo 'Please supply a file'
fi

rows=$(wc -l "$1" | awk '{print $1}')
cols=$(wc -L "$1" | awk '{print $1}')

echo "rows=$rows, cols=$cols"

declare -A grid
r=0

while read line; do
    for c in $(seq 0 $cols); do
        grid[($r,$c)]="${line:$c:1}"
    done

    r=$((r + 1))
done < "$1"

{
    for r in $(seq 0 $((rows - 1))); do
        for c in $(seq 0 $((cols - 1))); do
            echo "${grid[($((r - 1)),$((c - 1)))]}${grid[($r,$c)]}${grid[($((r + 1)),$((c + 1)))]}"
            echo "${grid[($((r - 1)),$((c + 1)))]}${grid[($r,$c)]}${grid[($((r + 1)),$((c - 1)))]}"
        done
    done \
        } | {
    sum=0;
    while read line; do
        read line2

        if [[ ('MAS' == "$line" || 'SAM' == "$line") \
                  && ('MAS' == "$line2" || 'SAM' == "$line2") ]]; then
            sum=$((sum + 1))
        fi;
    done <&0;

    echo $sum;
}
