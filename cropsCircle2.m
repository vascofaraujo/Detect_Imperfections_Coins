function [croppedImage, cropX, cropY, diameter] = cropsCircle2(im)
%This function receives a RGB image and crops to stay only the circle of
%the coin

% Turns the image from RGB to grayscale
specularG = rgb2gray(im);

%Estimates the coin radii 
[~, radiiCoin, centerCoinX, centerCoinY] = clearOutsideCoin(im);

% Rounds the radii towards a positive integer
radiiCoin = ceil(radiiCoin);

% Finds all circles 
%[centers, radii] = imfindcircles(specularG,[radiiCoin-80 radiiCoin],'EdgeThreshold', 0.2, 'Sensitivity',0.99,  'ObjectPolarity','dark');
% [centers, radii] = imfindcircles(specularG, [radiiCoin-80 radiiCoin], 'Sensitivity', 0.99, 'ObjectPolarity', 'dark');
% [centersW, radiiW] = imfindcircles(specularG, [radiiCoin-80 radiiCoin], 'Sensitivity', 0.99, 'ObjectPolarity', 'bright');
% [centersS, radiiS] = imfindcircles(specularG, [radiiCoin-120 radiiCoin-60], 'Sensitivity', 0.99, 'ObjectPolarity', 'dark'
[centers, radii] = imfindcircles(specularG, [radiiCoin-100 radiiCoin-50], 'Sensitivity', 0.99, 'ObjectPolarity', 'bright');

% We want the smallest radii found
[~,index] = min(radii);
if ~(isempty(radii))
    centerCoinX = ceil(centers(index,1));
    centerCoinY = ceil(centers(index,2));
    radiiCoin = ceil(radii(index));
    
end 

% Returns the cropped image
croppedImage = imcrop(im, [centerCoinX-radiiCoin centerCoinY-radiiCoin 2*radiiCoin 2*radiiCoin]);

% This are for when the flagAllAngles =  1, otherwise they won´t be
% necessary
cropX = centerCoinX-radiiCoin;
cropY = centerCoinY-radiiCoin;
diameter = 2*radiiCoin;
end