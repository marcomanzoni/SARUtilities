function [posit, subsetImage] = selectROIMatrix(imma, limits)
%SELECTROIMATRIX Summary of this function goes here
%   Detailed explanation goes here

figure; imagesc(imma); colorbar;
if nargin>1
    caxis(limits);
end
xlabel("Pixel Number");
ylabel("Pixel Number");

h = drawrectangle('Position', [1, 1, size(imma,2)/2, size(imma,1)/2]);
pos = customWait(h);


    function pos = customWait(hROI)
        l = addlistener(hROI, 'ROIClicked', @clickCallback);
        
        uiwait;
        
        delete(l);
        
        pos = hROI.Position;

        position    = round(pos);
        
        firstRow  = position(2);
        rowSize     = position(4);
        
        firstCol  = position(1);
        colSize     = position(3);
        
        posit = [firstRow, firstCol, rowSize, colSize];
        
        subsetImage = imma(firstRow:firstRow+rowSize, firstCol:firstCol+colSize);
        
    end

    function clickCallback(~, evt)
        if strcmp(evt.SelectionType, 'double')
            uiresume;
        end
    end

end

