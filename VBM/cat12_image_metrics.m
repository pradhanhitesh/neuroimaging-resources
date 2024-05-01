% Author: Hitesh Pradhan
% Date: 15 March 2024
% More information: github.com/pradhanhitesh
% 
% Description: CAT12 "Segmentation" generates QC-files and stores the
% information in .mat files and also reports in form of .pdf files.
% However, when working with large sample size, it is not possible to go
% through all the QC-reports. Therefore, this function utilizes the .mat
% files generated during "Segmentation" proccess and provides a table
% consisting of all necessary image statistics. 
%
% Usage:
% 1. path: provide path to the "reports" folder which contains .mat files
% 2. threshold: provide a numberic threshold (0-100) below which the image
% will be given a remark of "FAILED QC" and rest will be given a remark of
% "QC PASSED".


function metrics = cat_image_metrics(path,threshold)

    % FUNCTION
    % List all .mat files in the reports folder
    mat_folder = struct2cell(dir(append(path, '\*.mat')))';
    
    % Create empty cell to store data
    data = cell(length(mat_folder),7);
    
    % Loop for all the .mat files
    for k=1:length(mat_folder)
        % Extract Subject_ID
        sub_id = strsplit(mat_folder{k,1},".");
        sub_id = strsplit(sub_id{1},'cat_');
        
        % Load .mat file
        mat_filepath = append(mat_folder{k,2}, "\",mat_folder{k,1});
        mat = load(mat_filepath);
        
        % Extract parameters
        weighted_average = 105 - 10*mat.S.qualityratings.IQR;
        bias = 105 - 10*mat.S.qualityratings.ICR;
        defect_area = mat.S.qualityratings.SurfaceDefectArea;
        defect_number = mat.S.qualityratings.SurfaceDefectNumber;
        euler_number = mat.S.qualityratings.SurfaceEulerNumber;
    
        % Assigns 'QC FAILED' based on threshold
        if weighted_average < threshold
            data{k,7} = 'QC FAILED';
        else
            continue
        end
    
        %Store data
        data{k,1} = sub_id{2};
        data{k,2} = weighted_average;
        data{k,3} = bias;
        data{k,4} = defect_area;
        data{k,5} = defect_number;
        data{k,6} = euler_number;
    end
    
    % Generate table from cell array
    metrics = cell2table(data);
    metrics.Properties.VariableNames = {'SubID', 'Weighted Avergae', 'Bias',...
        'Defect Area', 'Defect Number', 'Euler Number','Remarks'};

    % Save the table
    writetable(metrics,'CAT12_IQR.csv')
end