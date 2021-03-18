function binaryImage = createEdgeDetection(im)
% This function receives an RGB image and returns the edges in binary

imGray = rgb2gray(im);

imClear = clearOutsideCoin(im);
% aux = imClear;
% imClear(aux < 15) = 255;

gauss1 = imgaussfilt(imClear, 2*sqrt(2));
[Gmag1, ~] = imgradient(gauss1);
t1 = graythresh(imGray);
Gmag1 = Gmag1 > t1*max(Gmag1(:));

binaryImage = Gmag1;




end