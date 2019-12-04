function image = smoothAbsStackMedian(image)
%SMOOTHABSSTACK Smoothing of a SAR image (amplitude) based on the amplitude
%over median value.
%
% inputs:
%           image: [Nr, Na, Ni double complex] stack of images in input
% outputs:
%           image: [Nr, Na, Ni double complex] stack of images in output

[Nr, Na, Ni] = size(image);
% apply subsampling to scan stats
subsampling = ceil(Nr*Na / 5e4);
% cut samples that are ovr_med above median
overMedianFactor = 3;

for jj=1:Ni
    tmp                 = image(:,:,jj);
    amplitudeTemp       = abs(tmp);
    amplitudeTempSub    = amplitudeTemp(1:subsampling:end);
    sca = overMedianFactor * median(amplitudeTempSub(amplitudeTempSub>0), 'omitnan' );
    [r, c] = find(amplitudeTemp > sca);
    %ind_pk = amplitudeTemp(:) > sca;
    
    amplitudeTempMed    = medfilt2(amplitudeTemp, [7,3]);
    indexToSubstitute   = sub2ind(size(amplitudeTemp), r,c); 
    amplitudeTemp(indexToSubstitute) = amplitudeTempMed(indexToSubstitute); 
    image(:,:,jj)       = exp(1i*angle(tmp)).*amplitudeTemp;
%     
%     if any(ind_pk)
%         tmp(ind_pk) = exp(1i*angle(tmp(ind_pk))).*sca;
%     end
    %image(:,:,jj) = tmp;
end
end
