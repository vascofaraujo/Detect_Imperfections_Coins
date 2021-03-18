function binaryImage = createBinaryEdge2(im)
% This function receives an RGB image and returns a binary matrix with only
% the biggest edges of the coin

% Paints the outside of the coin black
[imClear, radiiCoin, centerCoinX, centerCoinY] = clearOutsideCoin(im);

aux = imClear;

% Every pixel below 75 in grayscale will be converted to pure white in
% order to make the contrast bigger to the rest of the coin
t = 75;
imClear(aux < t) = 255;

aux = imClear;

imClear(aux ~= 255) = 0;

circleImage = false(size(imClear,1), size(imClear,2)); 

[x, y] = meshgrid(1:size(imClear,1), 1:size(imClear,2)); 

circleImage((x - centerCoinX).^2 + (y - centerCoinY).^2 <= radiiCoin.^2) = true;

imClear(~circleImage) = 0;

binaryImage = imClear;

binaryImage = imclose(binaryImage, strel('disk', 2));

% Removes objects smaller than 200 pixels to reduce noise and small errors
binaryImage = bwareaopen(binaryImage, 200);


end