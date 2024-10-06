# VBM Analysis

## cat12_image_metrics.m
CAT12 "Segmentation" generates QC-reports which are very helpful in assessing if the T1-scans are of good quality and therefore can be used in the analysis. However, when working with large number of T1 scans, consolidating QC-metrics can be tiresome. Therefore, I have created a simple function which calculates and generates a table consisting of all necessary image metrics. 

Usage:

```
metrics = cat12_image_metrics(path/to/cat12/reports, 75)
```
The **metrics** variable store the results in a table format in MATLAB and also saves the table as .csv file in the current working directory of MATLAB.

## spm12_extractlabels.m
SPM12 "Display Results" option shows all significant clusters and voxels with peak XYZ coordinates in mm. The XYZ coorindates can be saved as .csv file and used to extract the associated label based on atlas available in **./SPM/tpm** folder.

 **IMPORTANT**: The function will recognize the the first three columns as X-Y-Z columns, unless modified in the code. 

Usage:
```
spm12_extractlables(path/to/your/xyz/coordinates/.csv)
```
The function will extract the labels and save the results to .csv file in the current working directory of the MATLAB.

## spm12_extractROIvolumes.m
Using SPM12 Results section you can view your significant clusters at specific FWE-corrected p-value and cluster threshold. Now, you can also save the clusters as "Binary Mask" which can be used to extract volume from those significant regions of the brain for all the subjects in your study. 

I would like to thanks <a href="https://scholar.google.com/citations?user=SAqX3r4AAAAJ&hl=en">Gerad R. Ridgway</a> for writing the original function <a href=http://www0.cs.ucl.ac.uk/staff/G.Ridgway/vbm/get_totals.m>get_totals.m</a>. On top of this function, I created a batch-system which is automated to extract from the subjects *mwp1** files (if you use CAT12 Segmentation). Just specify the path to where *mwp1** files are stored and function will generated a table consisting of filename and associated the GM-volume.


## cat12_extract_xml.py
CAT12 stores the RAW data (e.g., volume and thickness measuremenets associated with GM, WM, CSF) in XML files. Depending upon the specification of the preprocessing, CAT12 can generate GM, WM, CSF volumetric measurements for 8 atlases and thickness measurements of 2 atlases. Here is a list of atlases used in CAT12:

1. Volumetric Atlases

    1. Hammers
    2. Neuromorphometrics
    3. LPBA40
    4. Cobra
    5. IBSR
    6. Thalamic Nuclei
    7. Suit
    9. Thalamus

2. Cortical Thickness Atlases

    1. Desikan-Killiany (equivalent to aparc2009s in FreeSurfer)
    2. Destrieux (equivalent to aparc_DK40 in FreeSurfer)


cat12_extract_xml.py function takes in list of filepaths associated with .xml files (e.g., use glob function to list all the xml files). If your are using catROI_\*.xml files, you will be able to extract volumetric measurements and the volumetric atlases listed above. If you are using catROIs_\*.xml files, you will be able to extract cortical thickness measurements and the cortical thickness atlases listed above.

**IMPORTANT**: Here are the atlases type and the associated TPM values which can be used with the function. For example, when atlas specified is "cobra", you cannot specify TPM as "Vcsf" as it is not allowed in the function. With "cobra" specified at atlas, only "Vgm" or "Vwm" can be used as TPM for the function.

```
atlas_rules = {
    "cobra": ['Vgm','Vwm'],
    "hammers": ['Vgm','Vwm','Vcsf'],
    "ibsr": ['Vgm','Vwm','Vcsf'],
    "lpba40": ['Vgm','Vwm'],
    "neuromorphometrics": ['Vgm','Vwm','Vcsf'],
    "suit": ['Vgm','Vwm'],
    "thalamic_nuclei": ['Vgm'],
    "thalamus": ['Vgm'],
    "aparc_a2009s" : ['thickness'],
    "aparc_DK40" : ['thickness']
}
```