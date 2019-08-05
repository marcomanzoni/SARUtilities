function outerProduct = outerProduct3D(dataStack)
%OUTERPRODUCT3D Given in input a data stack this function generates a new
%datastack where each carrot (3rd dimension) is the vectorized outer
%product of the carrot in the same position in dataStack

%   Inputs:
%           - dataStack: [Nr, Naz, Ni] data stack with SLC images
%   Outputs:
%           - outerProduct: [Nr, Naz, Ni^2] vectorized outer products

[Nrows, ~, Ni] = size(dataStack);

% Generate the matrices necessary for fast outer product computation
H0 = eye(Ni);
H0 = repmat(H0, Ni,1);
H0 = H0>0;

temp = [ones(Ni, 1), zeros(Ni,Ni-1)];
H1 = temp;
for idx = 1:Ni-1
    H1 = vertcat(H1, circshift(temp, [0 idx])); %#ok<AGROW>
end
H1 = H1>0;

dataStack = reshape(permute(dataStack,[3 1 2]), Ni, []);
outerProduct = (H1*dataStack).* conj(H0*dataStack);
clear dataStack

% Going back to a 3d matrix
outerProduct = permute(reshape(outerProduct, Ni^2 , Nrows , [] ),[2 3 1]);

end

