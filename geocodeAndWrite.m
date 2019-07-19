function geocodeAndWrite(imageToGeocode,GG, pathAndName)
%GEOCODEANDWRITE This function simply geocode and write the image given in
%input

geocoded = sar_gcd_nn(imageToGeocode, GG);
geotiffwrite(pathAndName, geocoded, GG.xref);

end

