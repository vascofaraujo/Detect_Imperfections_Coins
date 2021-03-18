function croppedImage = cropsCircle(im)
%This function receives a RGB image and crops to stay only the circle of
%the coin

specularG = rgb2gray(im);

[~, radiiCoin, centerCoinX, centerCoinY] = clearOutsideCoin(im);

radiiCoin = ceil(radiiCoin);
centerCoinX = round(centerCoinX);
centerCoinY = round(centerCoinY);
% [centers, radii] = imfindcircles(specularG,[radiiCoin-10 radiiCoin+10], 'Sensitivity',0.99,  'ObjectPolarity','dark');
% 
% if ~(isempty(radii))
%     disp('hello');
%    centerCoinX = round(centers(1,1));
%     centerCoinY = round(centers(1,2));
%     radiiCoin = ceil(radii);
%     
% end 

croppedImage = imcrop(im, [centerCoinX-radiiCoin centerCoinY-radiiCoin 2*radiiCoin 2*radiiCoin]);


end