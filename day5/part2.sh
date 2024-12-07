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

# Iterate over orderings and use graph to check validity.
sum=0
while read ordering; do
    unset check
    unset indegrees
    declare -A check
    declare -A indegrees

    for node in $ordering; do
        # Init to 0 to act as subset of nodes we care about.
        check[$node]=0
        indegrees[$node]=0
    done
    for node in $ordering; do
        for outdegree in ${outdegrees[$node]}; do
            # Use subset from earlier to prevent extra work incrementing
            # irrelevant nodes.
            if [[ -n ${check[$outdegree]} ]]; then
                check[$outdegree]=$((${check[$outdegree]} + 1))
                indegrees[$outdegree]=$((${indegrees[$outdegree]} + 1))
            fi
        done
    done

    # Walk through the ordering to see if :check match up.
    valid=true
    ordering_length=0
    for node in $ordering; do
        if [[ 0 -lt ${check[$node]} ]]; then
            valid=false
        fi

        ordering_length=$((ordering_length + 1))

        for outdegree in ${outdegrees[$node]}; do
            check[$outdegree]=$((${check[$outdegree]} - 1))
        done
    done

    # End of part1, now we know that the ordering is incorrect.
    if $valid; then
        continue
    fi

    queue=()
    for node in ${!indegrees[@]}; do
        if [[ 0 -eq ${indegrees[$node]} ]]; then
           queue+=($node)
        fi
    done

    inorder=''
    while [[ 0 -lt ${#queue[@]} ]]; do
        node=${queue[-1]}
        inorder+="$node "

        unset queue[-1]
        for outdegree in ${outdegrees[$node]}; do
            if [[ -n ${indegrees[$outdegree]} ]]; then
                new_outdegree=$((${indegrees[$outdegree]} - 1))

                if [[ 0 -eq $new_outdegree ]]; then
                    queue+=($outdegree)
                fi

                indegrees[$outdegree]=$new_outdegree
            fi
        done
    done

    ordering_length=$((ordering_length / 2))
    for node in $inorder; do
        if [[ 0 -eq $ordering_length ]]; then
            sum=$((sum + node))
            break
        else
            ordering_length=$((ordering_length - 1))
        fi
    done
done < <(tail -n "+$edge_lines" "$1" | tr ',' ' ')

echo "Sum of all valid middle page numbers: $sum"
