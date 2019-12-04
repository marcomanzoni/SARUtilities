function showMapWithPoints(pointsLat, pointsLon, mapTitle, R)
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
    geoplot([R.LatitudeLimits(2) R.LatitudeLimits(2)],[R.LongitudeLimits(1) R.LongitudeLimits(2)],'b', ...
        [R.LatitudeLimits(2) R.LatitudeLimits(1)],[R.LongitudeLimits(1) R.LongitudeLimits(1)],'b',...
        [R.LatitudeLimits(1) R.LatitudeLimits(1)],[R.LongitudeLimits(1) R.LongitudeLimits(2)],'b',...
        [R.LatitudeLimits(1) R.LatitudeLimits(2)],[R.LongitudeLimits(2) R.LongitudeLimits(2)],'b');
    hold on;
    geoscatter(pointsLat,pointsLon, 'r', 'filled');
    
    geolimits([min(pointsLat) - 0.2, max(pointsLat)+ 0.2],[min(pointsLon)- 0.2, max(pointsLon)+ 0.2]);
    geobasemap('openstreetmap');
    %geobasemap colorterrain
    title(mapTitle);
end

