#!/bin/bash

# Author: Hitesh Pradhan
# Date: 01-05-2024
# Description: FSL requires index.txt to be specified for DTI analysis
# Usually, index.txt is not provided with the sequences. Hence, one
# needs to create index.txt file from ".bval" file supplied with each
# DTI sequence, hence each subject. 

# Get the directory argument or use the current directory
folder="${1:-.}"

# Check if the directory exists
if [ ! -d "$folder" ]; then
    echo "Directory '$folder' not found."
    exit 1
fi

# Find all files with the .bval extension in the folder
files=$(find "$folder" -type f -name "*.bval")

# Loop through each file
for file in $files; do
    # Extract the filename without the extension
    filename=$(basename "$file" .bval)
    
    # Run your command with the extracted filename
    myVar=($(wc -w "$filename.bval")); indx=""; for ((i=1; i<=$myVar; i+=1)); do indx="$indx 1"; done; echo $indx > index.txt
done

