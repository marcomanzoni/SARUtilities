function [dates,rainValues] = readARPACSV(filename)
%READARPACSV Summary of this function goes here
%   Detailed explanation goes here

csv         = readtable(filename);

rainValues  = csv(:,3);
rainValues  = table2array(rainValues);
rainValues(rainValues == -999) = NaN;

samples     = csv(:,2);
samples     = cell2mat(table2array(samples));
dates       = datenum(samples, "yyyy/mm/dd HH:MM");

end

