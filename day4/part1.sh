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
            # CC rotation starting from the right
            echo "${grid[($r,$c)]}${grid[($r,$((c + 1)))]}${grid[($r,$((c + 2)))]}${grid[($r,$((c + 3)))]}"
            echo "${grid[($r,$c)]}${grid[($((r - 1)),$((c + 1)))]}${grid[($((r - 2)),$((c + 2)))]}${grid[($((r - 3)),$((c + 3)))]}"
            echo "${grid[($r,$c)]}${grid[($((r - 1)),$c)]}${grid[($((r - 2)),$c)]}${grid[($((r - 3)),$c)]}"
            echo "${grid[($r,$c)]}${grid[($((r - 1)),$((c - 1)))]}${grid[($((r - 2)),$((c - 2)))]}${grid[($((r - 3)),$((c - 3)))]}"

            echo "${grid[($r,$c)]}${grid[($r,$((c - 1)))]}${grid[($r,$((c - 2)))]}${grid[($r,$((c - 3)))]}"
            echo "${grid[($r,$c)]}${grid[($((r + 1)),$((c - 1)))]}${grid[($((r + 2)),$((c - 2)))]}${grid[($((r + 3)),$((c - 3)))]}"
            echo "${grid[($r,$c)]}${grid[($((r + 1)),$c)]}${grid[($((r + 2)),$c)]}${grid[($((r + 3)),$c)]}"
            echo "${grid[($r,$c)]}${grid[($((r + 1)),$((c + 1)))]}${grid[($((r + 2)),$((c + 2)))]}${grid[($((r + 3)),$((c + 3)))]}"
        done
    done \
} | { sum=0; while read line; do if [[ 'XMAS' == "$line" ]]; then sum=$((sum + 1)); fi; done <&0; echo $sum; }
