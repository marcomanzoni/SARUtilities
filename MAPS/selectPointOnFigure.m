function [selectedRow, selectedCol] = selectPointOnFigure(inputImage, inputColormap)
%SELECTPOINTONFIGURE Summary of this function goes here
%   Detailed explanation goes here

figure;
imagesc(inputImage);
colormap(inputColormap);
colorbar;
title({'Select a point on the scene', '(Left button on a point, then press enter)'});

[selectedRow,selectedCol] = getpts;

selectedRow = round(selectedRow);
selectedCol = round(selectedCol);

end

