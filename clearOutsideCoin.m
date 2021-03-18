function [specularCleared, radiiCoin, centerCoinX, centerCoinY] = clearOutsideCoin(specular)
% This function receives a RGB image of a coin  and returns an image with the
% outside of the coin entirely black to reduce noise in the image

% Turns image into grayscale
specularG = rgb2gray(specular);

% Turns the grayscaled image into a binary image
binary = imbinarize(specularG);
% Closes the image to make the contrast bigger
bwclose = imclose(binary, strel('disk', 20));

% Calculate the 
stats = regionprops('table', bwclose, 'Centroid', 'MajorAxisLength', 'MinorAxisLength');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;

coinI = 0;
for i = 1:size(radii,1)
    if radii(i) > 600 && radii(i) < 700
        coinI = i;
    end
end
if coinI == 0
    [~,coinI] = max(radii);
end
centerCoinX = centers(coinI,1);
centerCoinY = centers(coinI,2);
radiiCoin = radii(coinI);


circleImage = false(size(specularG,1), size(specularG,2)); 
[x, y] = meshgrid(1:size(specularG,1), 1:size(specularG,2)); 
circleImage((x - centerCoinX).^2 + (y - centerCoinY).^2 <= radiiCoin.^2) = true;

specularG(~circleImage) = 0;
specularCleared = specularG;

end