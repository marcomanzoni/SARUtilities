function [temporalVariog, temporalAxis] = temporalVariogram(dataCube, dates)
%temporalVariogram This function performs the temporal variogram of a cube of data. 
% First I calculate the minumum temporal baseline, then I fill missing data
% with NaN in order to have a uniform sampling in time domain. 
%   Inputs:
%           - dataCube [NrxNazxNi double] datacube with all the APS
%           - dates [Ni double] acquisition dates for each image inside
%           dataCube
%
%
%       dates = [6,12,24,30,54];
%       testCube = randn(20,20,5);
%       [temporalVariog, temporalAxis] = temporalVariogram(testCube, dates)  

[Nr, Naz, Ni] = size(dataCube);

%% Get uniform sampling in the time domain.
% Fill the gaps with NaN maps

% The first if date 0, all the others are 6,12, etc.
dates                    = fix(dates - dates(1));

% Minumum temporal baseline in the stack. This will be the sampling of the
% variogram
stepOneTemporalBaselines = diff(dates);
minTemporalBaseline      = min(stepOneTemporalBaselines);

% Images to add where there are gaps
imagesToAdd              = stepOneTemporalBaselines/minTemporalBaseline;

% Total number of images after gap filling
totalImages              = sum(imagesToAdd)+1;

% Making the data at a fixed time spacing
newDataCube              = NaN(Nr, Naz, totalImages);

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
temporalVariog = NaN(totalImages - 1, 1);

% Computing the variogram
for ii = 1:totalImages-1
    
    % Shift the data in the third dimension
    shiftedData           = circshift(newDataCube, ii, 3);
    
    % Delete the portion that circularly shift at the top of the stack
    shiftedData(:,:,1:ii) = NaN;
    
    % Difference
    differSquared         = (newDataCube - shiftedData).^2;

    % Mean of the difference squared
    temporalVariog(ii) = mean(differSquared(:), 'omitnan');
end

temporalAxis = (1:totalImages-1)*minTemporalBaseline;
end

