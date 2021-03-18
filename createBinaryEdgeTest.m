function binaryImage = createBinaryEdgeTest(im)
% This function receives an RGB image and returns a binary matrix with only
% the biggest edges of the coin


clearImage = clearOutsideCoinTest(im);

[B,L,N] = bwboundaries(clearImage);

BW = zeros(size(im,1));
for k = 1:length(B),
    boundary = B{k};
    for q = 1:length(boundary)
        BW(boundary(q,1), boundary(q,2)) = 1;
    end
end

gaussBW = imgaussfilt(BW, sqrt(2));

[blackGmag, ~] = imgradient(gaussBW);

tBlack = graythresh(clearImage);

newBlackGmag = blackGmag > tBlack*max(blackGmag);

binaryImage = imclose(newBlackGmag, strel('disk', 2));

%binaryImage = bwareaopen(binaryImage, 800);


end