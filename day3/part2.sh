#!/bin/bash

echo -n 'Sum of products: '
grep -E '(mul\(([0-9]{1,3}),[0-9]{1,3}\)|do\(\)|don'"'"'t\(\))' -o <&0 \
    | awk '/mul/ {lr=gensub(/mul\(([0-9]+),([0-9]+)\)/, "\\1 \\2", "g", $0); print(lr)} /do/' \
    | awk 'BEGIN {enabled=1} !/do/ {if (enabled) {sum+=($1 * $2)}} /do\(\)/ {enabled=1} /don/ {enabled=0} END {print(sum)}'
