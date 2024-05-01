# DTI Analysis

## create_indexfile.sh

FSL requires index.txt to be specified for DTI analysis. Usually, index.txt is not provided with the sequences. Hence, one needs to create index.txt file from ".bval" file supplied with each DTI sequence, hence each subject. The bash script creates the index.txt for
each .bval file. You can create the index.txt only once, assuming all the subjects have the same DTI acquistion protocol. 

Usage:
```
bash create_indexfile.sh /path/to/bval/files
```
## preproc_singlesubject.sh

The scipt can be used to perform BET, EDDY and DTIFIT, in that sequence, for a single subject in DTI analysis. Place the bash script in the subject directory and open terminal in the subject directory to run the bash script. 

**IMPORTANT:** The script requires 5 files to execute which are: 

(1) YOUR_SUBJECT_DTI_FILE.nii

(2) YOUR_SUBJECT_BVAL_FILE.bval

(3) YOUR_SUBJECT_BVEC_FILE.bvec

(4) index.txt

(5) acqparams.txt

If the files are not found, the script would not execute and exit with error. You can use **create_indexfile.sh** script to generate index.txt file. Additionally, if you need help extracting the acqparams.txt, please refer to the python notebook for help.

Usage 1: The script runs at default values of -f 0.2 in BET command and -fwhm=0 in EDDY command.

```
bash preproc_singlesubject.sh
```

Usage 2: If you wanna modify the default values, use the following flags along with the bash script. 

```
bash preproc_singlesubject.sh -f 0.3 -w 0.1
```
## preproc_sequence.sh
The scripts uses the **preproc_singlesubject.sh** script to run in each sub-folders containing files for each subject.

Example file directory structure:
```
|MAIN-DIRECTORY
    preproc_singlesubject.sh
    preporc_sequence.sh
        |SUBJECT_001
            |T1.nii
            |B.bval
            |B.bvecs
            |index.txt
            |acqparams.txt
        |SUBJECT_002
            |T1.nii
            |B.bval
            |B.bvecs
            |index.txt
            |acqparams.txt
        |SUBJECT_004
        |SUBJECT_005
        .
        .
        .

```
Place the **preproc_singlesubject.sh** and **preproc_sequence.sh** in the main directory where the subject folders are located. Open the terminal in the main directory and run the **preproc_sequence.sh** script

Usage:

```
bash preproce_sequence.sh
```



