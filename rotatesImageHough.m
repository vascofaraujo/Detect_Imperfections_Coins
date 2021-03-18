function rotatedImage = rotatesImageHough(im, im_line)
% This function receives the original RGB image and returns
% the original image rotated along the vertical line

% Binarizes the image
binaryEdge = createBinaryEdge(im_line);

% Hough transform
[H, theta] = hough(binaryEdge);

% Finds peaks in hough transform
peak = houghpeaks(H);

% Calculates the angle of the line
barAngle = theta(peak(2));

% Rotates the image without a line accordingly to the orientation of the
% line
rotatedImage = imrotate(im,barAngle, 'bilinear','crop');

end