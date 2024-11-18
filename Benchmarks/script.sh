#!/bin/bash

# Set the time limit in hours (e.g., 5 hours)
time_limit_hours=5
time_limit_seconds=$((time_limit_hours * 3600))  # Convert hours to seconds (5 hours * 3600 seconds/hour)

for file in *.cnf; do
    # Define the output filename and log filename
    output_file="${file%.cnf}_output.txt"
    log_file="${file%.cnf}_log.txt"
    
    # Run MiniSat with the set CPU time limit
    minisat -cpu-lim="$time_limit_seconds" "$file" "$output_file" > "$log_file" 2>&1
    
    # Capture the exit code from MiniSat
    exit_code=$?
    
    # Check if the execution exceeded the time limit
    if [ $exit_code -eq 2 ]; then
        echo "Execution for $file exceeded the time limit of $time_limit_hours hours and was terminated due to CPU timeout." >> "$log_file"
    fi
    
    # Check if MiniSat returned any other error code
    if [ $exit_code -ne 0 ]; then
        echo "MiniSat returned an error code $exit_code for file $file." >> "$log_file"
    fi
    
    echo "The result and log for $file have been saved in $output_file and $log_file"
done