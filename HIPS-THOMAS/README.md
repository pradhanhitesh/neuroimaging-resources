# HIPS-THOMAS

<a href= https://github.com/thalamicseg/hipsthomasdocker>HIPS-THOMAS</a> is a new modified pipeline for accurate segmentation of T1w (SPGR,MPRAGE) data based on <a href=https://github.com/thalamicseg/thomas_new>THOMAS</a> which performs segmentation of the thalamus into 11 nuclei and MTT using white-matter-nulled MPRAGE MRI image contrast. 

For your analysis, if you want to run multiple T1W images using HIPS-THOMAS, you can use use any of the two scripts as described below. The original HIPS-THOMAS command runs only one T1W image and there is no argument specified to run paralle or multiple T1W images. As suggested by the authors of the script, I have created a wrapper script to ease-out the process. 

## hips_sequence.sh
The script runs all the subject in sequential order. Place the hips_sequence.sh script within the main directory where all the T1W images are located within each folder. Here is an example distribution:

Example file directory structure:
```
|MAIN-DIRECTORY
    hips_sequence.sh
        |SUBJECT_001
            |T1.nii
        |SUBJECT_002
            |T1.nii
        |SUBJECT_003
        |SUBJECT_004
        .
        .
        .
```

Launch command line terminal (CLI) from the main directory to run the script. Make sure the sript is executionable by using <b>chmod +x hips_sequence.sh</b> first. And then run the script in the CLI,

```
bash hips_sequence.sh
```

<b>NOTE:</b> Depending on your system configuration, the process duration might vary. However, I do suggest running the script in parallel to save time.

## hips_parallel.sh
The script is an extension of the above-mentioned workflow. In this script, we can run parallel processes for each subjects to save some time. By default, the script runs on 10 cores, meaning 10 subjects will be processed simultaneously. Make sure than you have installed <a href=https://www.gnu.org/software/parallel/>GNU Parallel</a>, so that the script run without issues. 

```
bash hips_parallel.sh
```

However, if you want to change the number of default cores, use any text editor (e.g., VIM) to change the code. You can modify the following particular line of the hips_parallel.sh to change the number of cores. 

```
find . -mindepth 1 -maxdepth 1 -type d | parallel -j 10 process_folder
```

In this code, change the number 10 to your desired value.