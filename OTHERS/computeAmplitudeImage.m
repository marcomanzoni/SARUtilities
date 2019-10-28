function multiTemporalAverage = computeAmplitudeImage(dataSet, temporalMultilook)
%SHOWAMPLITUDEIMAGE This function shows in a plot the multitemporal
%amplitude average. It's used just for reference

% Inputs:
%           dataSet = it's the 3D data cube (complex values). It can be a
%           string or a dataset of double
%    
%           temporalMultilook = it's the number of images to be averaged



if isa(dataSet, 'char') || isa(dataSet, 'string')
    filePointer = matfile(dataSet);
    dataSet = filePointer.data_stacks_calibrated(:,:,1:temporalMultilook);
end
temp = mean(abs(dataSet(:,:,1:temporalMultilook)),3);
Y = quantile(temp(:), 0.97);
temp(temp>Y)=Y;

multiTemporalAverage = movmean(movmean(temp, 5, 'omitnan'), 1, 5, 'omitnan');
end

