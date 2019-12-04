function [variogr, distanceAxis] = variogramFromMatrix(data, rowSampling, colSampling)
%VARIOGRAMFROMMATRIX This function performs the variogram on an input
%matrix called data.

[Nrows, Ncols]      = size(data);
overSamplingFactor  = rowSampling/colSampling;
sampling            = min([rowSampling, colSampling]);
F                   = griddedInterpolant(double(data));

if overSamplingFactor < 1
    rowVec          = 1:Nrows;
    colVec          = 1:overSamplingFactor:Ncols;
else
    colVec          = 1:Ncols;
    rowVec          = 1:(1/overSamplingFactor):Nrows;
end

interpData          = F({rowVec, colVec});

maxExtent           = round(min(size(interpData))/2);

f1 = figure; imagesc(data); colorbar; title("Original Data");

f2 = figure; imagesc(interpData); colorbar; title("Interpolated Data");
fprintf("In the interpolated data each pixel is %.2f x %.2f \n", sampling, sampling);
fprintf("I'm computing the variogram up to %.2f \n", maxExtent*sampling);

variogr             = zeros(maxExtent, 1);
distanceAxis        = (1:maxExtent)*sampling;
h = waitbar(0,'Please wait...');
for ii = 1:maxExtent
    shiftMatrix = [[1; 1; 2; 2], [1; -1; 1; -1]*ii];
    difference = zeros(size(interpData,1), size(interpData,2), size(shiftMatrix,1));
    for jj = 1:size(shiftMatrix, 1)
        shiftAmount = shiftMatrix(jj,2);
        shiftDim = shiftMatrix(jj,1);
        shiftedData = circshift(interpData, shiftAmount, shiftDim);
        
        if shiftDim == 1
            if shiftAmount > 0
                shiftedData(1:shiftAmount, :) = NaN;
            else
                shiftedData(end+shiftAmount+1:end, :) = NaN;
            end
        else
            if shiftAmount > 0
                shiftedData(:, 1:shiftAmount) = NaN;
            else
                shiftedData(:, end+shiftAmount+1:end) = NaN;
            end
        end
        
        difference(:,:,jj) = (interpData - shiftedData).^2;
    end
    variogr(ii) = mean(rmmissing(difference(:)));
    waitbar(ii/maxExtent,h)
end

close(h);
close(f1);
close(f2);

end

