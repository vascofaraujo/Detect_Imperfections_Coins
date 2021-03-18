function percentage = checkEqualPercentage(matrix1, matrix2)
% This function receives two matrices and returns the percentage of their
% similarity

% This program will only run if the matrices are the same size
if size(matrix1,1) == size(matrix2,1) && size(matrix1,2) == size(matrix2,2)
    equalNum = 0;
    totalNum = size(matrix1,1) * size(matrix1,2);
    % Loops the entire matrix
    for i = 1:size(matrix1,1)
        for j = 1:size(matrix1,2)
            if matrix1(i,j) == matrix2(i,j)
                equalNum = equalNum + 1;
            end
        end
    end
    % Calculates percentage to return
    percentage = (equalNum / totalNum) * 100; 
end




end