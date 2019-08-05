function dataStack = from2Dto3D(dataStack, Nr)
%FROM2DTO3D Convert a 3D array of size [Ni, Nr*Nc] into a 2D array of size
%[Ni, Nr*Nc]
%   Inputs:
%           - dataStack the 2D stack of size [Ni, Nr x Nc]
%           - Nr the number of rows of the output stack. The number of
%           columns is automatically calculated
%
%   Outputs:
%           - dataStack: the reshaped dataStack


dataStack = permute(reshape(dataStack, size(dataStack,1) , Nr , [] ),[2 3 1]);

end

