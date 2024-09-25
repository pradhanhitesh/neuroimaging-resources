#!/bin/bash

# Main directory is the current working directory
main_directory=$(pwd)

# Path to the script
single_subject="preproc_singlesubject.sh"
single_path=""
if [ -f "$main_directory/$single_subject" ]; then
    single_path="$main_directory/$single_subject"
    echo "Found $single_subject in $main_directory. Using it as the sub-script."
else
    echo "Error: $single_subject not found in $main_directory."
    exit 1
fi

# Directory to copy .qc folders to
qc_destination_directory="$(pwd)/QC"
# Directory to copy dti_FA.nii.gz files to
fa_destination_directory="$(pwd)/ALL_FA"

# Ensure the destination directories exist
mkdir -p "$qc_destination_directory"
mkdir -p "$fa_destination_directory"

# Function to process a single directory
process_directory() {
    sub_directory="$1"
    subject_name=$(basename "$sub_directory")
    
    # Skip processing for FA and QC folders
    if [[ "$subject_name" == "ALL_FA" || "$subject_name" == "QC" ]]; then
        echo "Skipping processing for $subject_name folder."
        return
    fi

    echo "Processing files in $sub_directory..."

    # Change to the sub-directory
    cd "$sub_directory" || exit

    # Run the preprocessing script and wait for it to complete
    starting_time=$(date "+%Y-%m-%d %H:%M:%S")
    echo "Running preprocessing script for $subject_name at $starting_time"
    bash "$single_path" -f 0.2 -w 0
    if [ $? -ne 0 ]; then
        echo "Error while running the preprocessing script for $subject_name."
        return 1
    fi

    # After the script has completed, copy the .qc folder
    qc_folder=$(find . -type d -name "*.qc" | head -n 1)  # Find the first folder ending with .qc
    if [ -n "$qc_folder" ]; then
        echo "Found .qc folder: $qc_folder. Copying to $qc_destination_directory."
        cp -r "$qc_folder" "$qc_destination_directory"
    else
        echo "No .qc folder found in $sub_directory."
    fi

    # Copy and rename dti_FA.nii.gz file
    fa_file="$sub_directory/dti_FA.nii.gz"
    if [ -f "$fa_file" ]; then
        new_fa_filename="${subject_name}_dti_FA.nii.gz"
        echo "Found dti_FA.nii.gz. Copying as $new_fa_filename to $fa_destination_directory."
        cp "$fa_file" "$fa_destination_directory/$new_fa_filename"
    else
        echo "No dti_FA.nii.gz file found in $sub_directory."
    fi

    # Change back to the main directory
    cd "$main_directory" || exit

    completion_time=$(date "+%Y-%m-%d %H:%M:%S")
    echo "Completed processing files in $sub_directory at $completion_time."   
    echo "---------------------------------------------------------------------------"

}

# Loop through sub-folders and process them one by one
for sub_directory in "$main_directory"/*/; do
    # Check if the sub-directory is a directory
    if [ -d "$sub_directory" ]; then
        # Process the directory sequentially
        process_directory "$sub_directory"
    fi
done

echo "All tasks are completed."

