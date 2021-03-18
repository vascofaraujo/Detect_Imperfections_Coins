function isOneEuro = checkCoinValue(im)
% This function receives an RGB image of a coin and calculates the
% percentage of gold colour the coin has. If os less than a certain value,
% the coin is of 1 euro, if not is 2 euro

% Crops the image so that the size of the coin will be the same, regardless
% of the zoom used on the original image
croppedImage = cropsCircle2(im);

% Converts the image to HSV colormap
hsvImage = rgb2hsv(croppedImage);

% Calculates the gold points
goldPoints = hsvImage(:,:,1) <= 0.2 & hsvImage(:,:,2) >= 0.1 & hsvImage(:,:,3) >= 0.8;

% Calculates the percentage of gold points on the coin
percentGold = 100*(sum(sum(goldPoints))/(size(croppedImage,1)*size(croppedImage,2)))

% Returns the coin value (1 if is 1 euro, 0 if is 2 euro)
if percentGold < 33
    isOneEuro = 1;
else 
    isOneEuro = 0;
end

end
