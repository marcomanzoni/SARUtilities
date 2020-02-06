function [variogr, distanceAxis] = variogramFromMatrix(data, rowSampling, colSampling, maxExtent)
%VARIOGRAMFROMMATRIX This function performs the variogram on an input
%matrix called data.
% Inputs:
%
%       - data: [Nx, Ny, Ni double] the matrix with the data, it can be a
%       3D matrix (in that case only the spatial variogram is computed) or
%       3D with two layers, in that case the spatio-temporal variogram is
%       computed
%       - rowSampling, colSampling [double, in meters]: sampling of the data in row and col
%       space, the program will automatically resample everything at the
%       lower of the two to have uniform gridding
%       - maxExtent [double, in pixels] maximum number of pixel for the computation of
%       the variogram. This parameter is optional. If not given, it's half
%       of the minimum size of the image
%
%       - output: [maxExtent x Ni] first colum is the variogram at temporal
%       baseline = 0, second variogram at temporal baseline 1.
%       - distanceAxis: [maxExtent x Ni] distance axis in meters useful to
%                       plot the variogram.

if isreal(data)
    realData = true;
else
    realData = false;
end

[Nrows, Ncols, Ni]      = size(data);

if Ni == 1
    fprintf("Computing just the spatial variogram. \n");
elseif Ni == 2
    fprintf("Computing the spatio-temporal variogram. \n");
else
    error("The data parameter has more than three layers!");
end

overSamplingFactor  = rowSampling/colSampling;
sampling            = min([rowSampling, colSampling]);

fprintf("Interpolating the dataset to a common grid. \n");
for ii = 1:Ni
    F                   = griddedInterpolant(double(data(:,:,ii)));
    
    if overSamplingFactor < 1
        rowVec          = 1:Nrows;
        colVec          = 1:overSamplingFactor:Ncols;
    else
        colVec          = 1:Ncols;
        rowVec          = 1:(1/overSamplingFactor):Nrows;
    end
    
    if ii == 1
        interpData = zeros(length(rowVec), length(colVec), Ni);
    end
    interpData(:,:,ii)          = F({rowVec, colVec});
end

% If I don't provide a max extent, the max extent is half the smaller
% dimension of the dataset
if nargin < 4
    maxExtent           = round(min(size(interpData))/2);
end

%f1 = figure; imagesc(data); colorbar; title("Original Data");
%f2 = figure; imagesc(interpData); colorbar; title("Interpolated Data");

fprintf("In the interpolated data each pixel is %.2f x %.2f meters\n", sampling, sampling);
fprintf("I'm computing the variogram up to %.2f meters\n", maxExtent*sampling);

variogr             = zeros(maxExtent, Ni);
distanceAxis        = (1:maxExtent)*sampling;
h                   = waitbar(0,'Please wait...');

for ii = 1:maxExtent
    
    % Shifting matrix (I shift only in x and y, but un-down, left-right)
    shiftMatrix = [[1; 1; 2; 2], [1; -1; 1; -1]*ii];
    difference = zeros(size(interpData,1), size(interpData,2), size(shiftMatrix,1));
    
    % first run at temporal baseline = 0, second run at temporal baseline
    % equal to 1
    for kk = 0:Ni-1
        temporalShiftData = circshift(interpData, kk, 3);
        
        % Shift left, right, up, down
        for jj = 1:size(shiftMatrix, 1)
            shiftAmount     = shiftMatrix(jj,2);
            shiftDim        = shiftMatrix(jj,1);
            shiftedData     = circshift(temporalShiftData, shiftAmount, shiftDim);
            
            if shiftDim == 1
                if shiftAmount > 0
                    shiftedData(1:shiftAmount, :, :)           = NaN;
                else
                    shiftedData(end+shiftAmount+1:end, :, :)   = NaN;
                end
            else
                if shiftAmount > 0
                    shiftedData(:, 1:shiftAmount, :)           = NaN;
                else
                    shiftedData(:, end+shiftAmount+1:end, :)   = NaN;
                end
            end
            if realData
                difference(:,:,jj) = (1/Ni)*sum((interpData - shiftedData).^2, 3);
            else
                difference(:,:,jj) = (1/Ni)*sum((angle(interpData.*conj(shiftedData))).^2, 3);
            end
        end
        variogr(ii, kk+1) = mean(rmmissing(difference(:)));
        waitbar(ii/maxExtent,h)
    end
end

close(h);
fprintf("Done.");
% close(f1);
% close(f2);

end

