#!/bin/bash

retval=0

while read line; do
    unset prev
    unset slope
    safe=true

    for num in $line; do
        if [[ -z "$prev" ]]; then
            prev="$num"
            continue
        fi

        difference=$((num - prev))
        if [[ -3 -le "$difference" && "$difference" -le -1 ]]; then
            difference=-1
        elif [[ 1 -le "$difference" && "$difference" -le 3 ]]; then
            difference=1
        fi

        if [[ -z "$slope" ]]; then
            if [[ "$difference" -eq 0 ]]; then
               safe=false
               break
            else
                slope=$difference
            fi
        else
            if [[ "$difference" != "$slope" ]]; then
               safe=false
            fi
        fi

        prev="$num"
    done

    #echo "$line is safe: $safe"
    if "$safe"; then
        retval=$((retval + 1))
    fi
done < <(cat input.txt)

echo "Number of safe reports: $retval"
