function image = smoothAbsStack(image)
%SMOOTHABSSTACK Smoothing of a SAR image (amplitude) based on the amplitude
%over median value.
%
% inputs:
%           image: [Nr, Na, Ni double complex] stack of images in input
% outputs:
%           image: [Nr, Na, Ni double complex] stack of images in output
[Nr, Na, Ni] = size(image);
% apply subsampling to scan stats
subsampling = ceil(Nr*Na / 5e3);
% cut samples that are ovr_med above median
overMedianFactor = 3;

for jj=1:Ni
    tmp = image(:,:,jj);
    amplitudeTemp = abs(tmp);
    amplitudeTempSub = amplitudeTemp(1:subsampling:end);
    sca = overMedianFactor * median(amplitudeTempSub(amplitudeTempSub>0), 'omitnan' );
    ind_pk = amplitudeTemp(:) > sca;
    if any(ind_pk)
        tmp(ind_pk) = exp(1i*angle(tmp(ind_pk))).*sca;
    end
    image(:,:,jj) = tmp;
end
end

