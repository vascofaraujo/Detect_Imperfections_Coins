function finalMatrix = checkSquare(im)

if size(im,1) == size(im,2)
    finalMatrix = im;
else
    if size(im,1) > size(im,2)
        smallestSize = size(im,2);
    else
        smallestSize = size(im,1);
    end
    finalMatrix = imresize(im, [smallestSize smallestSize]);
end

end