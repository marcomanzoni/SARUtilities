function [readMatrix, writeMatrix, singleTileSize, numberOfTiles] = getTilingSteps(Naz, tileSize, windowSize)
%GETTILINGSTEPS Generate the matrices with the indexes where I should start
%to read and write a stack in the case of a processing carried out using
%tiles.
%   Inputs: 
%           - Naz: number of azimuth lines. Usually the tiling happens in
%           the azimuth, meaning that I take all the range lines from n to
%           n+tileSize, so I segment along the azimuth
%           - tileSize: size of a single tile. Keep in mind that the last
%           one can be smaller
%           - The size of the covariance matrix in the azimuth direction.
%
%   Outputs:
%           - readMatrix: [numberOfTiles x 2] matrix. At each step of
%           the tiling process start reading at readingMatrix(ii,1) and
%           stop at readingMatrix(ii,2). At the same time start writing at
%           writeMatrix(ii,1) and stop at writeMatrix(ii,2). Remember to
%           remove from the dataset the first and last (windowsSize-1)/2
%           samples
%           - singleTileSize: size of the single tile that I'm reading,
%           this is useful for the last tile that can be smaller
%           - numberOfTiles: scalar containing the total number of tiles
%           that I'm creating


startReadVector     = 1:tileSize-(windowSize+1)/2:Naz;
stopReadVector      = startReadVector+tileSize-1;
stopReadVector(end) = Naz;

readMatrix          = [startReadVector(:), stopReadVector(:)];
singleTileSize      = readMatrix(:,2)-readMatrix(:,1)+1;

numberOfTiles       = length(singleTileSize);

startWriteVector    = readMatrix(:,1) + (windowSize-1)/2;
stopWriteVector     = readMatrix(:,2) - (windowSize-1)/2;

writeMatrix         = [startWriteVector(:), stopWriteVector(:)];


end

