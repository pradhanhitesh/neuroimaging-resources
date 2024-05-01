#!/bin/bash

# Main directory is the current working directory
main_directory=$(pwd)

# Path to the script
single_subject="SingleSub_DTI.sh"
single_path=""
if [ -f "$main_directory/$single_subject" ]; then
	single_path="$main_directory/$single_subject"
    echo "Found $single_subject in $main_directory. Using it as the sub-script."
else
    echo "Error: $single_subject not found in $main_directory."
    exit 1
fi

# Loop through sub-folders
for sub_directory in "$main_directory"/*/; do
    # Check if the sub-directory is a directory
    if [ -d "$sub_directory" ]; then
        echo "Processing files in $sub_directory..."

        # Change to the sub-directory
        cd "$sub_directory" || continue

        # Run your script here
        bash "$single_path" -f 0.2 -w 0

        # Change back to the main directory
        cd "$main_directory" || continue

        echo "Completed processing files in $sub_directory."
    fi
done

