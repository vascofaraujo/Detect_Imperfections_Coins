function binaryImage = createBinaryImage(im)
% This function receives a RGBimage and returns the image in black and
% white, with everything black except the countours inside the coin

% Clears outside of the coin and gets radii and center of coin
[imClear, radiiCoin, centerCoinX, centerCoinY] = clearOutsideCoin(im);

aux = imClear;

% Every pixel below 50 turns to white 
t = 50;
imClear(aux < t) = 255;

aux = imClear;

% Every pixel that is not white turns to black
imClear(aux ~= 255) = 0;

circleImage = false(size(imClear,1), size(imClear,2)); 

[x, y] = meshgrid(1:size(imClear,1), 1:size(imClear,2)); 

circleImage((x - centerCoinX).^2 + (y - centerCoinY).^2 <= radiiCoin.^2) = true;

% Every pixel outside of the coin turns to white
imClear(~circleImage) = 0;

% Variable to return
binaryImage = imClear;


end