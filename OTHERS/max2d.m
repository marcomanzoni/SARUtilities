function [maxValue,rowsOfMaxes,colsOfMaxes] = max2d(A)
%MAX2D Summary of this function goes here
%   Detailed explanation goes here
[maxValue, ~] = max(A(:));
[rowsOfMaxes, colsOfMaxes] = find(A == maxValue);
end

