#!/bin/bash

echo -n 'Sum of products: '
grep -E 'mul\([0-9]{1,3},[0-9]{1,3}\)' -o <&0 \
    | awk '{lr=gensub(/mul\(([0-9]+),([0-9]+)\)/, "\\1 \\2", "g", $0); print(lr)}' \
    | awk '{sum+=($1 * $2)} END {print(sum)}'
