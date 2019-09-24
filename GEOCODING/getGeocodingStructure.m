function GG = getGeocodingStructure(varargin)

%function GG = get_gg_snap(xm,xr,Nrg,Naz)
%   compute geododing information
% Ouptut:
%   GG: geocoding structure
% Input:
%   xm: matrix of size [Nlat,Nlon,2] with range (1) and azimuth (2) indexes
%   Nrg: size of SAR image in range (if all valid indese Nrg should be
%        max(max(xm(:,:,1);
%   Naz: size of SAR image in azimuth

nargs = length(varargin);
if nargs == 3
    [xm, xr] = geotiffread(varargin{1}); % load mapping
    Nrg = varargin{2};
    Naz =  varargin{3};
elseif nargs == 4
    xm = varargin{1};
    xr = varargin{2};
    Nrg = varargin{3};
    Naz =  varargin{4};
else
    error('Wrong number of arguments');
end    

[Nxg, Nyg] = size(xm(:,:,1));    % get image size in latlong domain
X = xm(:,:,3);  % X coordinates of SAR image in the latlong domain
Y = xm(:,:,4);  % Y coordinates
indgood = (X(:)>1) & (Y(:)>1);  % mask with samples to use from SAR image

% construct a pointer to SAR image with linear index from row-col
ind_sar_im = sub2ind([Nrg, Naz],X(indgood),Y(indgood));

GG.xref = xr;
% GG.indexes address the whole SLC space. Keep it small by using the
% proper class
if max(ind_sar_im) > intmax('uint32')
    GG.indexes = uint64(ind_sar_im);
else
    GG.indexes = uint32(ind_sar_im);
end
GG.mask = indgood(:);
GG.Nsar = [Nrg, Naz];
GG.Ngec = [Nxg Nyg];
% Get latidues (Y) and longitudes (X) for the output grid
Nlat = xr.RasterSize(1);
Nlong = xr.RasterSize(2);
l1 = xr.LongitudeLimits(1)+xr.CellExtentInLongitude/2;
l2 = xr.LongitudeLimits(2)-xr.CellExtentInLongitude/2;
Lon = linspace(l1,l2,Nlong);
l1 = xr.LatitudeLimits(1)+xr.CellExtentInLatitude/2;
l2 = xr.LatitudeLimits(2)-xr.CellExtentInLatitude/2;
Lat = linspace(l2,l1,Nlat);

% store in radiants (for compatibility)
GG.Lat = Lat/180*pi;
GG.Lon = Lon/180*pi;


end

