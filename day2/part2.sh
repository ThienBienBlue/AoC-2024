#!/bin/bash

safe_report () {
    local len=$(wc -w < <(echo $1))
    local skip

    for skip in $(seq 0 $len); do
        prev=""
        slope=""
        local i=0

        for num in $1; do
            if [[ $i -eq $skip ]]; then
                i=$((i + 1))
                continue
            fi

            if [[ -z "$prev" ]]; then
                prev="$num"
                i=$((i + 1))
                continue
            fi

            difference=$((num - prev))
            if [[ -3 -le "$difference" && "$difference" -le -1 ]]; then
                difference=-1
            elif [[ 1 -le "$difference" && "$difference" -le 3 ]]; then
                difference=1
            else
                difference=0  # Map all the other values to invalid (0).
            fi

            if [[ -z "$slope" && "$difference" -ne 0 ]]; then
                slope=$difference
            elif [[ -n "$slope" && "$slope" -eq "$difference" ]]; then
                true  # pass
            else
                continue 2
            fi

            i=$((i + 1))
            prev="$num"
        done

        echo 1
        return 0
    done

    echo 0
}

retval=0

while read line; do
    res=$(safe_report "$line")
    retval=$((retval + res))

    echo "$line is safe: $res"
done < $1

echo "Number of safe reports: $retval"
