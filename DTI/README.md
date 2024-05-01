# DTI Analysis

**CreateIndex_DTIAnalysis.sh**

FSL requires index.txt to be specified for DTI analysis. Usually, index.txt is not provided with the sequences. Hence, one needs to create index.txt file from ".bval" file supplied with each DTI sequence, hence each subject. The bash script creates the index.txt for
each .bval file. You can create the index.txt only once, assuming all the subjects have the same DTI acquistion protocol. 

Usage:
```
bash CreateIndex_DTIAnalysis.sh /path/to/bval/files
```