# DTI Analysis

1. CreateIndex_DTIAnalysis.sh 
FSL requires index.txt to be specified for DTI analysis. Usually, index.txt is not provided with the sequences. Hence, one needs to create index.txt file from ".bval" file supplied with each DTI sequence, hence each subject.

Usage:
```
bash CreateIndex_DTIAnalysis.sh /path/to/bval/files
```