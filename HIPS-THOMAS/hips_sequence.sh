#!/bin/bash

# Loop through each sub-directory in the current working directory
for dir in */ ; do
    # Change to the directory
    cd "$dir"

    # Find the .nii file
    nii_file=$(ls *.nii 2> /dev/null)

    # Check if a .nii file was found
    if [[ -z "$nii_file" ]]; then
        echo "No .nii file found in $dir"
    else
        # Execute the command with the detected .nii file
        docker run -v "${PWD}:${PWD}" -w "${PWD}" --user $(id -u):$(id -g) --rm -t anagrammarian/thomasmerged bash -c "hipsthomas_csh -i $nii_file -t1 -big"
    fi

    # Change back to the parent directory
    cd ..
done

