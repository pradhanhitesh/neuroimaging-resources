% Author: Hitesh Pradhan
% Date: 01 March 2024
% More information: github.com/pradhanhitesh
% 
% Description: The function can be used to extract lables associated with 
% XYZ coordinates obtained from the resulst section. Currenly, only
% supproting "Neuromorphometrics" atlas.
%
% Usage:
% 1. path: provide path to the .csv file consisting of three columns of XYZ
% coordinates, starting with X and ending with Z. It is necessary to have
% first three columns as X-Y-Z coordinates.

function spm12_extractlabels(path)

    % Load the .csv file containing XYZ coordinates
    coordinates = readtable(path);
    
    % Specify the first three columns as X-Y-Z coordinates
    XYZmm = table2array(coordinates(:, 1:3))';
    
    % Load the "neuromorphometrics" atlas
    xA = spm_atlas('load', 'neuromorphometrics');
    
    % Create empty cell-array to store lables
    labels = cell(size(XYZmm,2),1);
    
    % Loop through all the XYZ coordinates
    for k=1:size(XYZmm,2)
        
        % Use spm_atlas, 'query' mode to extract labels
        Q = spm_atlas('query', xA, XYZmm(:,k));
    
        % Store the extracted lables in the cell-array
        labels{k,1} = Q;
    
    end
    
    % Append the extracted lables to coordinates-table
    coordinates.Regions = labels;
    
    % Save the coordinates table
    writetable(coordinates, 'ExtractedLabels.csv')

end