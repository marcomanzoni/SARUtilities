function coherence = computeCoherence(master,slave, rowAverage, columnsAverage, gpuMode)
%COMPUTECOHERENCE Summary of this function goes here
%   Detailed explanation goes here

if nargin<5
    gpuMode = false;
else
    if gpuMode == true
        master = gpuArray(master);
        slave = gpuArray(slave);
    end
end

interf = movmean2(master.*conj(slave), rowAverage, columnsAverage);
pow1 = movmean2(master.*conj(master), rowAverage, columnsAverage);
pow2 = movmean2(slave.*conj(slave), rowAverage, columnsAverage);

coherence = interf./sqrt(pow1.*pow2);

if gpuMode == true
    coherence = gather(coherence);
end

end

