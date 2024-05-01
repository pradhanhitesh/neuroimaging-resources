# VBM Analysis

## cat12_image_metrics.m
CAT12 "Segmentation" generates QC-reports which are very helpful in assessing if the T1-scans are of good quality and therefore can be used in the analysis. However, when working with large number of T1 scans, consolidating QC-metrics can be tiresome. Therefore, I have created a simple function which calculates and generates a table consisting of all necessary image metrics. 

Usage:

```
metrics = cat12_image_metrics(path/to/cat12/reports, threshold = 75)
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