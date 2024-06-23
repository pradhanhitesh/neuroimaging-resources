## LST-AI
<a href="https://github.com/CompImg/LST-AI">LST-AI</a>, the deep learning-based successor of the original Lesion Segmentation Toolbox (LST) by Schmidt et al. LST-AI was collaboratively developed by the Department of Neurology and Department of Neuroradiology, Klinikum rechts der Isar at the Technical University of Munich, and the Department of Computer Science at the Technical University of Munich.

For my ease of workflow, I have created two wrapper scripts, namely, <a href="https://github.com/pradhanhitesh/neuroimage-plugins/blob/main/LST-AI/sequence_lst.py">seuquence_lst.py</a> which is GPU-based, sequential processing of subject, whereas <a href="https://github.com/pradhanhitesh/neuroimage-plugins/blob/main/LST-AI/parallel_lst.py">parallel_lst.py</a> is a CPU-based, parallel processing of subjects. 

Example file directory structure:
```
|MAIN-DIRECTORY
    parallel_lst.py
    sequence_lst.py
        |T1
            |sub-001_T1.nii.gz
            |sub-002_T1.nii.gz
            |sub-003_T1.nii.gz
            .
            .
            .
        |T2F
            |sub-001_T2F.nii.gz
            |sub-002_T2F.nii.gz
            |sub-003_T2F.nii.gz
            .
            .
            .            
        .
        .
        .
```

# parallel_lst.py
NOTE: I am assuming that you have setup LST-AI according to the instructions provided by author of toolboxes.


The wrapper script is designed to take "number of cores" to be used as an argument. Activte your "LST" enviroment and open Command Line Interpreter (CLI) to execute the following command:

```
python /path/to/the/script/parallel_lst.py --max_workers 5
```

Here, each subject will be processed using one thread and the wrapper script will simultaneously process 5 subjects at any instance. Each subject's output and temp will also be stored within the Output and Temp directory as a separate subject-specific folder. 

# sequence_lst.py
NOTE: I am assuming that you have setup LST-AI according to the instructions provided by author of toolboxes.

The wrapper script is designed to use the power of GPU to process each subject. Since, the processing will take place on a GPU, there is no way it can handle simulataneous process. Hence, each subject will be processed sequentially. 

```
python /path/to/the/script/sequence_lst.py 
```

# compile_stats.py
I will soon add python-script to automatically extract all the necessary details such as lesion volume, lesion classification into a .csv file.

Last updated on: 23 June 2024