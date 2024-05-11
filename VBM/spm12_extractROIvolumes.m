% Author: Hitesh Pradhan
% Date: 11 March 2024
% More information: github.com/pradhanhitesh
% 
% Description: The function can be used to extract ROI-volumes from binary
% masks generated from SPM12 Results section.
% Thanks to Gerad Ridgway (http://www0.cs.ucl.ac.uk/staff/g.ridgway/) for
% write the main part of the function "get_volumes". Since, I work with
% large cohort study designs, I needed to automate the for large sample
% size (> 1000).Hence, the batch-mode for get_volumes function.

% Specify the directory path
dir_path = 'path\to\you\mwp1\files'; % I use CAT12 for Segmentation

% Get the list of all mwp1* files in the directory
files = dir(dir_path);

% Initialize a cell array to store the filenames
filenames = cell(length(files), 1);

% Loop through the files and extract just the filenames
for i = 1:length(files)
    filenames{i} = files(i).name;
end

% Convert the cell array to a table
file_table = cell2table(filenames, 'VariableNames', {'Filename'});

% Empty cell
store_data = cell(height(file_table),2);

for i=1:height(file_table) % You can play around the i-values
    filename = char(file_table{i,1});
    mask = char("your_thresholded_FWE_corrected_binary_mask.nii");
    store_data{i,1} = filename;
    store_data{i,2} = get_totals(filename, 0.1, mask); % Absolute threshold at 0.1
    disp(filename)
    
end


% DO NOT EDIT HERE
% Credits: Gerad Ridgway
function [t, files] = get_totals(files, thr, msk)
%get_totals - Returns image totals (sum over all voxels), in ml
%  t = get_totals
%  [t files] = get_totals(files, thr, msk)
% GUI file-selection is used if files not specified as argument (or empty).
%
% If thr is given, this will be treated as an absolute threshold
% (i.e. values below this will be zeroed, hence the total will better match
% the GM analysed in the voxelwise stats, with the same threshold masking).
%
% Similarly, if msk is specified this image will be used as an explicit
% mask (i.e. only non-zero mask voxels will be included).
% GUI file-selection is used if msk is given as empty string ('').
% [Currently, masking assumes that msk matches the voxel dimensions of each
% image, and that therefore, all images have the same dimensions.]

% check spm version:
if exist('spm_select','file') % should be true for spm5
    spm5 = 1;
    select = @(msg) spm_select(inf, 'image', msg);
elseif exist('spm_get','file') % should be true for spm2
    spm5 = 0;
    select = @(msg) spm_get(inf, 'img', msg);
else
    error('Failed to locate spm_get or spm_select; please add SPM to Matlab path')
end

if ( ~exist('files', 'var') || isempty(files) )
    files = select('choose images');
end
if ( ~exist('thr', 'var') || isempty(thr) )
    thr = -inf; % default to include everything (except NaNs)
end
if ~exist('msk', 'var')
    msk = 1; % default to include everything
end
if isempty(msk)
    msk = select('Choose mask image');
end
if ischar(msk)
    msk = spm_vol(msk);
end
if isstruct(msk)
    msk = spm_read_vols(msk);
end
msk = msk ~= 0;

vols = spm_vol(files);
N = length(vols);

t = zeros(N,1);
for n = 1:N
    vsz = abs(det(vols(n).mat));
    img = spm_read_vols(vols(n));
    img = img .* msk;
    t(n) = sum(img(img > thr)) * vsz / 1000; % vsz in mm^3 (= 0.001 ml)
end
end
