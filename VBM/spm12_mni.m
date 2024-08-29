filename = char("D:\wALK002_V1_t1_mprage_sag_p2_iso_TA_5_03_MPR_cor.nii");
volumeInfo = spm_vol(filename);
[intensityValues,xyzCoordinates ]=spm_read_vols(volumeInfo);

xyz1 = xyzCoordinates'; % MNI-space (mm)
xyz2 = mni2cor(xyz1,volumeInfo.mat); % Voxel-space (matrix-indeces)
% Transformation affine matrix should be specified from the source image
% intensityValues only take xyz2 coordinates




function coordinate = mni2cor(mni, T)
% function coordinate = mni2cor(mni, T)
% convert mni coordinate to matrix coordinate
%
% mni: a Nx3 matrix of mni coordinate
% T: (optional) transform matrix
% coordinate is the returned coordinate in matrix
%
% caution: if T is not specified, we use:
% T = ...
%     [-4     0     0    84;...
%      0     4     0  -116;...
%      0     0     4   -56;...
%      0     0     0     1];
%
% xu cui
% 2004-8-18
%

if isempty(mni)
    coordinate = [];
    return;
end

if nargin == 1
	T = ...
        [-4     0     0    84;...
         0     4     0  -116;...
         0     0     4   -56;...
         0     0     0     1];
end

coordinate = [mni(:,1) mni(:,2) mni(:,3) ones(size(mni,1),1)]*(inv(T))';
coordinate(:,4) = [];
coordinate = round(coordinate);
return;
end