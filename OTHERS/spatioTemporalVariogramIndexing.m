function [spatioTemporalVariogram,spatialAxis, temporalAxis] = spatioTemporalVariogramIndexing(dataCube,dates, cellSize, maxSpatialOffset)
%UNTITLED2 Compute the spatio-temporal variogram both in space and time.
%
%   Inputs:
%           - dataCube [Nr x Nc x Ni double] 3D matrix containing the data over
%           which the variogram is computed. If dataCube is 2D only the
%           spatial variogram is computed
%           - dates [Nix1 double] vector containing the dates (as double) of
%            the data in the first variable
%           - cellSize [scalar double] size of the single pixel in the
%           input data. Before calling this function the data should be
%           resampled to have the same pixel size along rows and columns
%           - maxSpatialOffset [scalar integer] maximum extent for the
%           spatifal variogram defined in pixel. The maximum spatial extent
%           in meters will be cellSize*maxSpatialOffset
%
%   Outputs:
%           - spatioTemporalVariogram [time x space double] variogram with
%           time axis = y, space axis = x. If you want to see just the
%           temporal variogram with zero space offset use
%           spatioTemporalVariogram(:,1) while if you want to see just the
%           spatial variogram at 0 time delay.
%           - spatialAxis: axis useful to plot the variogram along the space
%           dimension
%           - temporalAxis: axis useful to plot the variogram along the
%           time dimension
%
%   Example:
%           plot the result of the function as
%           surf(spatialAxis, temporalAxis, spatioTemporalVariogram);

[Nr, Nc, Ni] = size(dataCube);

if Ni == 2
    fprintf("Data is 2D: only the spatial variogram is computed \n");
else
    fprintf("Data is 3D: spatio-temporal variogram is computed \n");
end

dates = dates(:);
% The first if date 0, all the others are 6,12, etc.
dates                    = round(dates - dates(1));

% Minumum temporal baseline in the stack. This will be the sampling of the
% variogram
stepOneTemporalBaselines = diff(dates);
minTemporalBaseline      = min(stepOneTemporalBaselines);

% Images to add where there are gaps
imagesToAdd              = stepOneTemporalBaselines/minTemporalBaseline;

% Total number of images after gap filling
totalImages              = sum(imagesToAdd)+1;

% Making the data at a fixed time spacing
newDataCube              = NaN(Nr, Nc, totalImages);

checkVector              = 1;
imagesToAdd = [1; imagesToAdd];

for ii = 1:length(imagesToAdd)
    
    temp = imagesToAdd(ii);
    if temp == 1
        checkVector = vertcat(checkVector , 1);
    else
        temp = temp - 1;
        checkVector = vertcat(checkVector , zeros(temp, 1));
        checkVector = vertcat(checkVector , 1);
    end
end

indexOK = 1;
checkVector(1)=[];

for ii = 1:totalImages
    if checkVector(ii) == 1
        newDataCube(:,:,ii) = dataCube(:,:,indexOK);
        indexOK             = indexOK + 1;
    else
        newDataCube(:,:,ii) = NaN;
    end
end

%% Compute the variogram
spatioTemporalVariogram = zeros(totalImages, maxSpatialOffset+1);
h                   = waitbar(0,'Computing variograms, Please wait...');
% Computing the variogram
for ii = 0:totalImages-1
    
    % Shift the data in the third dimension (time domain)
    originalDataCube       = newDataCube(:,:,ii+1:end);
    temporalShiftedData    = newDataCube(:,:,1:end-ii);
    
    for jj = 0:maxSpatialOffset
        
        % Shifting matrix (I shift only in x and y: up-down, left-right)
        shiftMatrix = [[1; 1; 2; 2], [1; -1; 1; -1]*jj];
        difference = [];
        
        % Shift left, right, up, down
        for tt = 1:size(shiftMatrix, 1)
            
            shiftAmount     = shiftMatrix(tt,2);
            shiftDim        = shiftMatrix(tt,1);
            
            if shiftDim == 1
                if shiftAmount > 0
                    originalDataCube    = originalDataCube(shiftAmount+1:end,:,:);
                    temporalShiftedData = temporalShiftedData(1:end-shiftAmount, :, :);
                else
                    shiftAmount = abs(shiftAmount);
                    originalDataCube    = originalDataCube(1:end-shiftAmount, :, :);
                    temporalShiftedData = temporalShiftedData(shiftAmount+1:end,:,:);
                end
            else
                if shiftAmount > 0
                    originalDataCube    = originalDataCube(:,shiftAmount+1:end,:);
                    temporalShiftedData = temporalShiftedData(:, 1:end-shiftAmount, :);
                else
                    shiftAmount         = abs(shiftAmount);
                    originalDataCube    = originalDataCube(:, 1:end-shiftAmount, :);
                    temporalShiftedData = temporalShiftedData(:,shiftAmount+1:end,:);
                end
            end
            difference = cat(3, difference, (originalDataCube - temporalShiftedData).^2);
        end
        
        spatioTemporalVariogram(ii+1, jj+1) = mean(difference(:), 'omitnan');
        
    end
    fprintf("%d/%d -", ii, totalImages);
    waitbar(ii/totalImages,h);
end

temporalAxis = (0:totalImages-1)*minTemporalBaseline;
spatialAxis = (0:maxSpatialOffset)*cellSize;

end

