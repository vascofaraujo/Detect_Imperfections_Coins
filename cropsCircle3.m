function [croppedImage] = cropsCircle3(im, cropX, cropY, diameter)
%This function receives a RGB image and crops to stay only the circle of
%the coin


croppedImage = imcrop(im, [cropX cropY diameter diameter]);

end