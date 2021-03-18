function binaryImage = createBinaryEdge(im)
% This function receives an RGB image and returns a binary matrix with only
% the bigger edges of the coin

% Clears outside coin
clearImage = clearOutsideCoin(im);

% Function to retrive bigger edges of the coin
[B,L,N] = bwboundaries(clearImage);

% Create binary image that is 1 for the return of bwboundaries and 0
% otherwise
BW = zeros(size(im,1));
for k = 1:length(B),
    boundary = B{k};
    for q = 1:length(boundary)
        BW(boundary(q,1), boundary(q,2)) = 1;
    end
end

% Since the bwboundaries return is not a straight line we have to fill in
% the rest of the image

% Gaussian Filter
gaussBW = imgaussfilt(BW, sqrt(2));

[blackGmag, ~] = imgradient(gaussBW);

tBlack = graythresh(clearImage);

newBlackGmag = blackGmag > tBlack*max(blackGmag);

binaryImage = imclose(newBlackGmag, strel('disk', 2));

binaryImage = bwareaopen(binaryImage, 800);

end