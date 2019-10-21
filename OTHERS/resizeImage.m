function resizedImage = resizeImage(inputImage,targetSize)
%RESIZEIMAGE Resize the image in input to the specified target size. The
%image can be real or complex

sourceSize = size(inputImage);  % 1752x2 for second series 
[X,Y] = meshgrid(linspace(1,sourceSize(2),targetSize(2)), ...
                 linspace(1,sourceSize(1),targetSize(1)));  % build the interpolant grid
             
if not(isreal(inputImage))
    realPart = real(inputImage);
    complexPart = imag(inputImage);
    
    resizedImage =interp2(realPart,X,Y) + 1j.*interp2(complexPart,X,Y);
else
    resizedImage =interp2(inputImage,X,Y);
end




end

