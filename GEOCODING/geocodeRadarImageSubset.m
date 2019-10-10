function [subsetGeocodedImage, R] = geocodeRadarImageSubset(imageToBeGeocoded, maskImage, geocodingInfoFull)
%GETGEOCODINGSTRUCTURESUBSET geocode a subset of a radar image

maskImage(not(isnan(maskImage))) = imageToBeGeocoded;

geocodedImage           = geocodeRadarImage(maskImage, geocodingInfoFull);
[rowIndex,colIndex]     = ind2sub(size(geocodedImage),find(not(isnan(geocodedImage))));

subsetGeocodedImage = geocodedImage(min(rowIndex):max(rowIndex), min(colIndex):max(colIndex));

geocodedImage(min(rowIndex):max(rowIndex), min(colIndex):max(colIndex)) = 1;

P = extractLatLonVal(geocodedImage, geocodingInfoFull);

minLon = min(P(:,1));
maxLon = max(P(:,1));

minLat = min(P(:,2));
maxLat = max(P(:,2));

R = georefcells([minLat, maxLat],[minLon, maxLon],...
    geocodingInfoFull.xref.CellExtentInLatitude,...
    geocodingInfoFull.xref.CellExtentInLongitude,...
    'ColumnsStartFrom','north');


end

