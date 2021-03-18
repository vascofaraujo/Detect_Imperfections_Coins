function output = reshapeCircleImage2(input, number, sizeData)

sizeInput = size(input{1},1);

if sizeInput > sizeData
    for i = 1:number
        output{i} = imresize(input{i},[sizeData sizeData]);
    end
else
    if number == 1
        output = input;
    else
        smallestSize = sizeInput;
        smallestCoin = smallestSize;
        for i = 1:number
            currSize = size(input{i},1);
            if currSize < smallestSize
                smallestCoin = currSize;
                smallestSize = currSize;
            end

        end    
        for i = 1:number
            output{i} = imresize(input{i},[smallestCoin smallestCoin]);
        end
    end

end
   




end