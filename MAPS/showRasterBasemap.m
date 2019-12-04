function showRasterBasemap(raster,georefRaster, basemap, georefBasemap)
%SHOWRASTERBASEMAP Show a raster map with a base layer. 
%   Inputs;
%           - raster: [NxM double/single] raster to show superimposed to
%           the basemap layer
%           - georefRaster: [GeoRefCells] Georeference object to the raster
%           (output from geotiffread)
%           - basemap: [KxLx4 double] raster to show as a basemap. The
%           first three layers are important since they are RGB layers.
%           Download this map from QGIS.
%           - [GeoRefCells] Georeference object to the raster (output from geotiffread)


% Plot the basemap using geoshow
geoshow(basemap(:,:,1:3), georefBasemap); hold on;

% Plot the raster as a texture map
geoimg = geoshow(raster, georefRaster, 'DisplayType','texturemap');

% Fix the axis
axis([georefRaster.LongitudeLimits(1), georefRaster.LongitudeLimits(2), georefRaster.LatitudeLimits(1), georefRaster.LatitudeLimits(2)]);

geoimg.AlphaDataMapping     = 'none'; % interpet alpha values as transparency values
geoimg.FaceAlpha            = 'texturemap'; % Indicate that the transparency can be different each pixel
alpha(geoimg,double(~isnan(raster))) % Change transparency to matrix where if data==NaN --> transparency = 1, else 0.
end

