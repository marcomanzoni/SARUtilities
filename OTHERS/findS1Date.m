function date = findS1Date(filename)
%FINDS1DATE This function find the acquisition date of an image gathered by
%sentinel-1
%
%   inputs:
%           filename: [characther vector] the filename of a SAR image
%   outputs:
%           date: [character vector] acquisition date in ISO8601
filename = convertStringsToChars(filename);
reg = '([12]\d{3}(0[1-9]|1[0-2])(0[1-9]|[12]\d|3[01]))';
[startIndex, endIndex] = regexp(filename, reg);
date = filename(startIndex(1):endIndex(1));
end

