#!/bin/bash

# --- 1. Define the Trap Handler Function ---
cleanup_and_exit() {
    echo -e "\n\n🚨 Caught Ctrl+C (SIGINT)! Stopping the loop."
    echo "Performing necessary cleanup... (e.g., deleting temp files, saving progress)"
    exit 1 # Exit the script gracefully with a non-zero status
}

# --- 2. Set the Trap ---
# 'trap' registers the 'cleanup_and_exit' function to run when the
# script receives the SIGINT signal (Ctrl+C).
trap cleanup_and_exit SIGINT

# (( )) is used for arithmetic evaluation in Bash
for (( i=1; i<=1000; i++ )); do
    sl -aF
done

echo "Loop finished."
