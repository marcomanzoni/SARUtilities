function P = extractLatLonVal(geocodedMap,geocodingInfo)
%EXTRACTLATLONVAL From a geocoded map extract (for each non-nan pixel in
%the map) a matrix containing in each raw the tripet LON, LAT, VALUE).
%
%   Inputs:
%           - geocodedMap: [Nr, Nc double] geocodedMap
%           - geocodingInfo: GG strucy for the geocoding procedure
%
%   Outputs:
%           - P: [Nx3 double] with LON, LAT, VALUE

mask = isnotnan(geocodedMap);
numberOfPoints = nnz(mask);

% LON, LAT, VALUE
P = zeros(numberOfPoints,3);

[ind_r,ind_a] = ind2sub(size(mask),find(mask > 0));
P(:,1)        = geocodingInfo.Lon(ind_a)/pi*180;
P(:,2)        = geocodingInfo.Lat(ind_r)/pi*180;
P(:,3)        = geocodedMap(mask);
end

