function [centers, radii]= drawRedCircle(im)
% This function receives the final image with only the imperfections in
% white and everything else in black, finds the three largest imperfections
% and returns it's center to plot red circles around it

stats = regionprops('table', im, 'Area', 'Centroid');

[~, maxIndex] = maxk(stats.Area,3);

centers = stats.Centroid(maxIndex,:);
radii(1:3) = 50;

end
