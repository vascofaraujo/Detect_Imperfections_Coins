function flagSameSize = checkImageSize(coin1, coin2)

if size(coin1, 1) == size(coin2, 1) && size(coin1,2) == size(coin2, 2)
    flagSameSize = 0;
else
    flagSameSize = 1;
end


end