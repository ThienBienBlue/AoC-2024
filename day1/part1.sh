#!/bin/bash

# Part 1

left=$(awk '{print($1);}' < part1.input | sort -n)
right=$(awk '{print($2);}' < part1.input | sort -n)

exec 3< <(echo "$left")
exec 4< <(echo "$right")

retval=0

while read lv <&3; do
    read rv <&4
    lr_diff=$((lv - rv))
    retval=$((retval + ${lr_diff#-}))

    #echo $lv $rv ${lr_diff#-}
done

echo "Total difference: $retval"

# Part 2

declare -A counts
for r in ${right[@]}; do
    rv=${counts[$r]}

    if [[ -z "$rv" ]]; then
        rv=0
    fi

    counts[$r]=$((rv + 1))
done

retval=0

for l in ${left[@]}; do
    rv=${counts[$l]}

    if [[ -n "$rv" ]]; then
        add=$((l * rv))
        retval=$((retval + add))
    fi
done

echo "Similarity Score: $retval"
