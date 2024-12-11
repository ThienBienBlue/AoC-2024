#!/bin/bash

# DIRECTIONS=('>' 'v' '<' '^')
R_DELTA=(0 1 0 -1)
C_DELTA=(1 0 -1 0)

declare -A map
row=0
col=0
guard=''  # guard* needs to be set when building the map.
guard_row=''
guard_col=''

while read line; do
    col=0

    for cell in $line; do
        unset guard_found
        if [[ "$cell" == '>' ]]; then
            guard_found=0
        elif [[ "$cell" == 'v' ]]; then
            guard_found=1
        elif [[ "$cell" == '<' ]]; then
            guard_found=2
        elif [[ "$cell" == '^' ]]; then
            guard_found=3
        fi

        if [[ -n $guard_found ]]; then
            guard=$guard_found
            guard_row=$row
            guard_col=$col
            map[($row,$col)]='.'
        else
            map[($row,$col)]="$cell"
        fi

        (( col += 1 ))
    done

    (( row += 1 ))
done < <(awk '{ with_spaces = gensub(/(.)/, "\\1 ", "g", $0); print(with_spaces); }' <&0)

rows=$row
cols=$col
retval=0

while [[ 0 -le $guard_row && $guard_row -lt $rows \
             && 0 -le $guard_col && $guard_col -lt $cols ]]; do
    if [[ "${map[($guard_row,$guard_col)]}" == '.' ]]; then
        map[($guard_row,$guard_col)]='X'
        (( retval += 1 ))
    fi

    (( next_row = $guard_row + ${R_DELTA[$guard]} ))
    (( next_col = $guard_col + ${C_DELTA[$guard]} ))

    if [[ "${map[($next_row,$next_col)]}" == '#' ]]; then
        (( guard = (guard + 1) % 4 ))
    else
        (( guard_row = next_row ))
        (( guard_col = next_col ))
    fi
done

echo "The guard visited \`$retval' cells in the map"
