#!/bin/bash

# (( )) is used for arithmetic evaluation in Bash
for (( i=1; i<=1000; i++ )); do
    sl -alfe
done

echo "Loop finished."
