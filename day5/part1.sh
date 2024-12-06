#!/bin/bash

# Build up graph.
declare -A outdegrees
edge_lines=2  # \n\n separates graph edges from orderings.

while read from; do
    read to;

    #echo "$from -> $to"
    edge_lines=$((edge_lines + 1))
    outdegrees[$from]+="$to "
done < <(awk -F '|' '/[0-9]+\|[0-9]+/ { print($1); print($2); }' "$1")

#for node in "${!outdegrees[@]}"; do
#    echo "$node: ${outdegrees[$node]}"
#done

# Iterate over orderings and use graph to check validity.
sum=0
while read ordering; do
    declare -A indegrees
    for node in $ordering; do
        # Init to 0 to act as subset of nodes we care about.
        indegrees[$node]=0
    done
    for node in $ordering; do
        for outdegree in ${outdegrees[$node]}; do
            # Use subset from earlier to prevent extra work incrementing
            # irrelevant nodes.
            if [[ -n ${indegrees[$outdegree]} ]]; then
                indegrees[$outdegree]=$((${indegrees[$outdegree]} + 1))
            fi
        done
    done

    #for key in ${!indegrees[@]}; do echo "$key: ${indegrees[$key]}"; done

    # Walk through the ordering to see if :indegrees match up.
    valid=true
    ordering_length=0
    for node in $ordering; do
        if [[ 0 -lt ${indegrees[$node]} ]]; then
            valid=false
            break
        fi

        ordering_length=$((ordering_length + 1))

        for outdegree in ${outdegrees[$node]}; do
            indegrees[$outdegree]=$((${indegrees[$outdegree]} - 1))
        done
    done

    if $valid; then
        #echo "$ordering"
        ordering_length=$((ordering_length / 2))

        for node in $ordering; do
            if [[ 0 -eq $ordering_length ]]; then
                sum=$((sum + node))
                break
            else
                ordering_length=$((ordering_length - 1))
            fi
        done
    fi
done < <(tail -n "+$edge_lines" "$1" | tr ',' ' ')

echo "Sum of all valid middle page numbers: $sum"
