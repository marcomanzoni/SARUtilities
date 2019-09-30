function SLC = readSLC(fileName, polarization, startPosition, lengths, steps)
%READSLC Read an SLC in HDF5 format and compose the SLC image as a complex
%single.
%
% Inputs:
%          fileName: [string] filename of the .h5 file
%          polarization: [string] can be VV or VH
%          startPosition: [1*2 integer vector] where is the starting
%          position in row and col
%          lengths: [1*2 integer vector] How many row and cols do i read?
%          steps: [1*2 integer vector] sampling interval. If i put [2 2] it 
%                   reads one sample every two.

if nargin == 2
    startPosition = [1, 1];
    lengths = [Inf, Inf];
    steps = [1, 1];
elseif nargin == 3
    lengths = [Inf, Inf];
    steps = [1, 1];
elseif nargin == 4
    steps = [1, 1];
end

iBandName = sprintf("/i_%s", polarization);
qBandName = sprintf("/q_%s", polarization);

iBand = h5read(fileName,iBandName,startPosition,lengths,steps);
qBand = h5read(fileName,qBandName,startPosition,lengths,steps);

SLC = single(complex(iBand,qBand));
end

