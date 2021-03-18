function centers= drawRedCircle2(sub, numberCircles, numberImages)
% This function receives the final image with only the imperfections in
% white and everything else in black, finds the three largest imperfections
% and returns it's center to plot red circles around it

for i = 1:numberImages
    stats{i} = regionprops('table', sub{i}, 'Area', 'Centroid');
    
    [~, maxIndex{i}] = maxk(stats{i}.Area,numberCircles);

    centers{i} = stats{i}.Centroid(maxIndex{i},:);
end

end
