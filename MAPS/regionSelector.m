function pos = regionSelector(image)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

figure('units','normalized','outerposition',[0 0 1 1]); 
imagesc(image); colorbar; colormap('gray');
xlabel("Azimuth pixel number");
ylabel("Range pixel number");

h = drawrectangle('Position', [1 1 600 3600]);
pos = customWait(h);


    function pos = customWait(hROI)
        l = addlistener(hROI, 'ROIClicked', @clickCallback);
        
        uiwait;
        
        delete(l);
        
        pos = hROI.Position;
        
    end

    function clickCallback(~, evt)
        if strcmp(evt.SelectionType, 'double')
            uiresume;
        end
    end
end

