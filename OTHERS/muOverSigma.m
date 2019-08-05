function dispersionIndex = muOverSigma(dataStack)
%MUOVERSIGMA This function generates the dispersion index mu/sigma. The mu
%is just the incoherent multitemporal average of the datastack, while sigma
%is the dispersion (standard deviation)

if isa(dataStack, 'char') || isa(dataStack, 'string')
    filePointer = matfile(dataStack);
    dataStack = filePointer.data_stacks_calibrated;
end

%Incoherent average
averageTemporalValue = mean(abs(dataStack),3);

% Incoherent average of the squared values
averageTemporalValueSquared = mean(abs(dataStack).^2,3);

% power
sigmaSquared = averageTemporalValueSquared-(averageTemporalValue.^2);

dispersionIndex = averageTemporalValue./realsqrt(sigmaSquared);

mmu = mean(dispersionIndex(:)); 
smu=std(dispersionIndex(:));
thre = mmu+5*smu;
dispersionIndex(dispersionIndex > thre)=thre;


end

