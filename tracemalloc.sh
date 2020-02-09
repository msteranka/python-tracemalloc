#!/bin/bash

dir="tracemalloc"
tmp="$dir/.tmp"

for i in "$@"
do
    lineno=$(grep -n -m 1 "import pyperf" $i | cut -f 1 -d :)
    sed $lineno"s/^/import tracemalloc\ntracemalloc.start(25)\n/" $i > $tmp
    echo -e 'snapshot = tracemalloc.take_snapshot()\ntop_stats = snapshot.statistics('\''traceback'\'')\nfor stat in top_stats:\n\tprint(stat)\n' >> $tmp
    python3 $tmp | grep $tmp > "$(echo "$dir/$i" | cut -f 1 -d '.').txt"
done
