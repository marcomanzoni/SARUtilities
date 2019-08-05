function coherenceMatrix = covarianceToCoherence(dataStack)
%COVARIANCETOCOHERENCE convert from covariances to coherences. The
%covariance needs to be vectorized in the colums of dataStack OR dataStack
%can be a 3D vector with vectorized coherences in the third dimension
%   Inputs:
%           - dataStack: [Nr, Nc, Ni^2] or [Ni^2, Nr x Nc]. The dimension
%           of Ni^2 contains the vectorized covariance matrix


if ndims(dataStack) == 3
    dataStack = from3Dto2D(dataStack);
end

Ni = sqrt(size(dataStack,1));
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

corr_diag = realsqrt(real(dataStack(1:Ni+1:end,:)));
coherenceMatrix = dataStack ./ ((H1*corr_diag).* (H0*corr_diag));
end

