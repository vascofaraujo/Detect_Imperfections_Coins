function [coin1New, coin2New, coin3New, coin4New, coin5New, coin6New] = reshapeCircleImage(coin1, coin2, coin3, coin4, coin5, coin6)
% This fucntion receives all the coins in different sizes and returns all
% the coins scaled to the smallest

coinArray = [size(coin1,1), size(coin2,1), size(coin3,1), size(coin4,1), size(coin5,1), size(coin6,1)];

[smallestCoin, smallestIndex] = min(coinArray);


coin1New = imresize(coin1,[smallestCoin smallestCoin]);
coin2New = imresize(coin2,[smallestCoin smallestCoin]);
coin3New = imresize(coin3,[smallestCoin smallestCoin]);
coin4New = imresize(coin4,[smallestCoin smallestCoin]);
coin5New = imresize(coin5,[smallestCoin smallestCoin]);
coin6New = imresize(coin6,[smallestCoin smallestCoin]);




end