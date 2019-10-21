function coherence = computeCoherence(master,slave, rowAverage, columnsAverage)
%COMPUTECOHERENCE Summary of this function goes here
%   Detailed explanation goes here
interf = movmean2(master.*conj(slave), rowAverage, columnsAverage);
pow1 = movmean2(master.*conj(master), rowAverage, columnsAverage);
pow2 = movmean2(slave.*conj(slave), rowAverage, columnsAverage);

coherence = interf./sqrt(pow1.*pow2);

end

