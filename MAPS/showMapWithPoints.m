function showMapWithPoints(pointsLat, pointsLon, mapTitle)
%SHOWMAPWITHPOINTS Shows a map of points into a map gathered by open street
%map.
%   Inputs:
%           - pointsLat [Nx1 double] latitudes of all the points
%           - pointsLon [Nx1 double] longitude of all the points
%           - mapTitle [string] title to place at the top of the map
%     
    figure;
    name = 'openstreetmap';
    url = 'a.tile.openstreetmap.org';
    copyright = char(uint8(169));
    attribution = copyright + "OpenStreetMap contributors";
    displayName = 'Open Street Map';
    addCustomBasemap(name,url,'Attribution',attribution,'DisplayName',displayName)
    geoscatter(pointsLat,pointsLon);
    geolimits([min(pointsLat) max(pointsLat)],[min(pointsLon) max(pointsLon)]);
    geobasemap('openstreetmap');
    title(mapTitle);
end

