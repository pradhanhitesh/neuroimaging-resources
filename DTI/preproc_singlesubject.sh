#!/bin/bash

# Set default values for options
bet_f=0.2
eddy_fwhm=0

# Parse command line options
while getopts ":f:w:" opt; do
  case $opt in
    f) bet_f="$OPTARG";;
    w) eddy_fwhm="$OPTARG";;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1;;
    :) echo "Option -$OPTARG requires an argument." >&2; exit 1;;
  esac
done

# Shift the option parameters so that "$1" now refers to the first non-option argument (if any)
shift $((OPTIND - 1))

# Array of required file extensions and file names
required_files=( ".nii" ".bval" ".bvec" "index.txt" "acqparams.txt" )

# Flag to track if all required files are found
all_files_exist=true

# Variable to store the .nii filename
nii_filename=""

# Loop through required files
for file in "${required_files[@]}"; do
    # Check if any file with the required extension or name exists
    if ! ls *"$file" 1> /dev/null 2>&1; then
        all_files_exist=false
        break
    fi
done

# Check if all required files exist
if $all_files_exist; then
    # Get the .nii filename
    nii_filename=$(ls *.nii)
    nii_basename=$(basename "$nii_filename" .nii)

    # Run bet
    bet "$nii_filename" "$nii_filename" -m -f "$bet_f"

    # Wait before running eddy
    wait
    # Execute your second command here
    eddy --imain="$nii_filename" --mask="${nii_basename}_mask.nii.gz" --index=index.txt --acqp=acqparams.txt --bvecs="${nii_basename}.bvec" --bvals="${nii_basename}.bval" --fwhm="$eddy_fwhm" --out=eddy_"$nii_basename"

    # Wait before running dtifit
    wait
    dtifit --data="eddy_${nii_basename}.nii.gz" --out=dti --mask="${nii_basename}_mask.nii.gz" --bvecs="${nii_basename}.bvec" --bvals="${nii_basename}.bval"
else
    echo "Error: One or more required files are missing."
    exit 1
fi

