function [temporalVariog, temporalAxis] = temporalVariogram(dataCube, dates)
%UNTITLED This function performs the temporal variogram of a cube of data

[Nr, Naz, Ni] = size(dataCube);

dates                    = fix(dates - dates(1));
stepOneTemporalBaselines = diff(dates);
minTemporalBaseline      = min(stepOneTemporalBaselines);
imagesToAdd              = stepOneTemporalBaselines/minTemporalBaseline;
totalImages              = sum(imagesToAdd)+1;

% Making the data at a fixed time spacing
newDataCube              = NaN(Nr, Naz, totalImages);

checkVector              = 1;
imagesToAdd = [1; imagesToAdd];

for ii = 2:length(imagesToAdd)

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

for ii = 1:totalImages
    if checkVector(ii) == 1
        newDataCube(:,:,ii) = dataCube(:,:,indexOK);
        indexOK             = indexOK + 1;
    else
        newDataCube(:,:,ii) = NaN;
    end
end

temporalVariog = NaN(totalImages - 1, 1);

% Computing the variogram
for ii = 1:totalImages-1
    shiftedData           = circshift(newDataCube, ii, 3);
    shiftedData(:,:,1:ii) = NaN;
    
    differSquared         = (newDataCube - shiftedData).^2;

    shiftedData           = circshift(newDataCube, -ii, 3);
    shiftedData(:,:,end-ii+1:end) = NaN;
    differSquared         = cat(3 , differSquared, (newDataCube - shiftedData).^2);

    temporalVariog(ii) = mean(differSquared(:), 'omitnan');
end

temporalAxis = (1:totalImages-1)*minTemporalBaseline;
end

