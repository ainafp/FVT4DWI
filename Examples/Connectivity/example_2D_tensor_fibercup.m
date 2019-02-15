% Example using the phantom Fibercup (2D version)
% Data can be downloaded in http://www.tractometer.org/original_fibercup/data/
%
% Author: Aina Frau-Pascual


% Load Input image, generated with DSI Studio
%dsi_studio_run --action=src --source=data.nii.gz --bval=bvals --bvec=bvecs --output=data.src.gz'
%dsi_studio_run --action=rec --source=data.src.gz --mask=nodif_brain_mask.nii.gz --method=1 --output_tensor=1 --output_dif=1 --output=data.src.gz.012fy.dti.fib.gz';

% Alternatively, you could generate your own tensors and load them as
% im = (im_x, im_y, tensor_x, tensor_y)
folder = '/autofs/space/galata_001/users/afrau/Data/Fibercup/';
file_name = fullfile(folder, 'acq-averaged_b-1500.nii.gz.src.gz.012fz.dti.fib.gz'); 
[fa0, md, im0, voxel_size] = read_fib(file_name);

% Choose to use the whole image '0' (default), a medium size image '1' 
% or a small size image '2'
image_size = 2;

% Load the image you chose, with its corresponding FA map
% We are here removing one dimension a bit roughly, only for testing
if image_size==2
    ax = 32:36; ay = 22:26;
elseif image_size==1
    ax = 31:50; ay = 13:33;
else
    ax = 1:size(im0,1); ay = 1:size(im0,2);
end
im1 = squeeze(im0(ax, ay, 2, :));
Nx = size(im1, 1); 
Ny = size(im1, 2); 
im = zeros(Nx, Ny, 2, 2);
im(:, :, :, 1) = im1(:, :, 1:2);
im(:, :, :, 2) = im1(:, :, [2, 4]);
fa = fa0(ax, ay, 2);

% Compute conductance and plot it interactively
[meshstruct, D, M, RHSbc] = computeDiffusionMatrix2D(im, size(im));
[potentials, mask_index] = computePotentials2D(D, meshstruct, M, RHSbc);
interactiveConductance2D(fa, [Nx, Ny], potentials, mask_index);
