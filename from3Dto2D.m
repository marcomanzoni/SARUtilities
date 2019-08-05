function dataStack = from3Dto2D(dataStack)
%FROM3DTO2D Convert a 3D array of size [Nr,Nc,Ni] into a 2D array of size
%[Ni, Nr*Nc] for fast matrix multiplication

dataStack = reshape(permute(dataStack,[3 1 2]), size(dataStack,3), []);

end

