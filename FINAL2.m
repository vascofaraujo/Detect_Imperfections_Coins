%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detection of imperfections for an 1€ coin captured using RTI (Reflectance Transformance Imaging) 
%
%
% June and August 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The objective is to test the best method for capturing the scratches and
% imperfections the coin has, in order to produce an unique pattern for the
% coin.


clc; % Clear Command Window
% Delete all open figures
close all;
% Clear all variables from the workplace
clearvars;

% Confirms if the user has the necessary files
% Checks if the user has the Image Processing Toolbox
if ~license('test', 'image_toolbox')
    sprintf('You must have the Image Processing Toolbox in order to run this code');
    return;
end

% Asks the user if he wants to run the program
message = sprintf('This program will analyze images of coins captured with RTIViewer. Do you want to continue?');
reply1 = questdlg(message, 'Run Program', 'Yes','No', 'Yes');
if strcmpi(reply1, 'No')
	return;
end

% Asks the user from which country the coins are from
list = sprintf('Portugal\nSpain\nFrance\nNeither/mixed');
[index, tf] = listdlg('PromptString', {'From which country are the'... 
            'coins you want to analyze?'}, 'SelectionMode', 'single','Initialvalue', 1, 'ListString', list );
if tf == 0
    return
else
    countryCoin = index;
end

% Asks the user if he wants to analyze one or more images
message = sprintf('Do you want to analyze a single image of a coin, multiple coins or one coin with images from all quadrants? (the images should be captured with the Specular Enhancement filter on RTIViewer)');
reply2 = questdlg(message, 'Select One Option', 'Single coin', 'Multiple coins', 'Single coin with all angles', 'Single coin');
% Flag that is one only if the user chooses the last option
flagAllAngles = 0;
%If user selects one image
if strcmpi(reply2, 'Single Coin')
    numberImages = 1;
	[filename, pathname] = uigetfile('*.jpg', 'Select one image');
    fullFileName = fullfile(pathname, filename);
    coin{1} = imread(fullFileName);
% If user selects more than oneimage
elseif strcmpi(reply2, 'Multiple coins')
        [filename, pathname] = uigetfile('*.jpg', 'Select two or more images', 'MultiSelect', 'on');
        numberImages = size(filename,2);
    for i = 1:numberImages
        fullFileName = fullfile(pathname, filename{i});
        coin{i} = imread(fullFileName);
    end
% If user selects one image with all angles
elseif strcmpi(reply2, 'Single coin with all angles')
    flagAllAngles = 1;
    [filename, pathname] = uigetfile('*.jpg', 'Select two or more images', 'MultiSelect', 'on');
        numberImages = size(filename,2);
    for i = 1:numberImages
        fullFileName = fullfile(pathname, filename{i});
        coin{i} = imread(fullFileName);
    end
else
    return
end

% This is a way for the subplot to look nice and even
numberPlotY = ceil(sqrt(numberImages));
numberPlotX = ceil(numberImages/numberPlotY);
numberFig = 1;
% Plots the images chosen by the user
figure(numberFig);
numberFig = numberFig + 1;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
sgtitle('Original');
for i = 1:numberImages
    subplot(numberPlotX, numberPlotY, i);
    imshow(coin{i});
end
    
    

% Now the user has to select the same number of images with a line drawn
message = sprintf('Since the images captured with the RTIViewer are not centered, in order to best process them you have to input the same images but with a vertical line drawn on the center crown of the coin');
reply3 = questdlg(message, 'Continue?', 'Ok','Cancel', 'Ok');
if strcmpi(reply3, 'Cancel')
	return;
end
% If the number of images is 1 or if flagAllAngles is 1 (in that case the
% user only has to input a single image (because the orientation will be
% the same to all)
if numberImages == 1 || flagAllAngles == 1
    [filename, pathname] = uigetfile('*.jpg', 'Select one image');
    fullFileName = fullfile(pathname, filename);
    coin_line{1} = imread(fullFileName);
else
    % If the number of images is larger than one
    [filename, pathname] = uigetfile('*.jpg', 'Select two or more images', 'MultiSelect', 'on');
    for i = 1:numberImages
        fullFileName = fullfile(pathname, filename{i});
        coin_line{i} = imread(fullFileName);
    end
end


% Asks if the user wants to check the value of the coin or not
message = sprintf('Will you want to check the value of the coin?');
replyValue = questdlg(message, 'Please select one', 'Yes', 'No', 'No');
if strcmpi(replyValue, 'Yes')
    messageBox = 'Input images with no filter';
    q = msgbox(messageBox);
    pause(1);
    flagCheckValue = 1;
    if numberImages == 1 
        [filename, pathname] = uigetfile('*.jpg', 'Select one image');
        fullFileName = fullfile(pathname, filename);
        coin_value{1} = imread(fullFileName);
    else
        % If the number of images is larger than one
        [filename, pathname] = uigetfile('*.jpg', 'Select two or more images', 'MultiSelect', 'on');
        for i = 1:numberImages
            fullFileName = fullfile(pathname, filename{i});
            coin_value{i} = imread(fullFileName);
        end
    end
end
    
    

% Since the images selected by the user can be of every size, we have to
% make sure they are squared to run the algorithm, and if they are not
% reshape the matrix to be squared
if flagAllAngles == 0
    for i = 1:numberImages
        coin{i} = checkSquare(coin{i});
        coin_line{i} = checkSquare(coin_line{i});
    end
else
    for i = 1:numberImages
        coin{i} = checkSquare(coin{i});
    end
    coin_line{1} = checkSquare(coin_line{1});
end
    


% Depending on the country of origin of the coin we load the respective mat
% files
% If country of origin is Portugal
if countryCoin == 1
    % Checks if the .mat files used to calculate the average coin exist
    if exist('binaryCoinsForAverage_1.mat') && exist('binarySub3_1.mat')
        % Flag to see if files exist or not
        existFiles = 1;
        % Loads the average and sub3 files
        averageData = load('binaryCoinsForAverage_1.mat');
        sub3Data = load('binarySub3_1.mat');
        % Counts number of data in average.mat (since they have the same
        % size we only need to check the size of one dataset)
        numberFields = numel(averageData.coin);
        % Loop to extract all info to the two cell arrays
        for i = 1:numberFields
            binaryCoinData{i} = averageData.coin{i};
            binarySub3Data{i} = sub3Data.sub{i};
        end
        % Size of the coins stored on the dataset
        sizeBinaryData = size(averageData.coin{1},1);
    else 
        existFiles = 0;
        message = 'Since the .mat file used to calculate the average of the coin doesn´t exist the result will not be as accurate';
        z = msgbox(message);
    end
% If country of origin is Spain
elseif countryCoin == 2
    % Checks if the .mat files used to calculate the average coin exist
    if exist('binaryCoinsForAverage_2.mat') && exist('binarySub3_2.mat')
        % Flag to see if files exist or not
        existFiles = 1;
        % Loads the average and sub3 files
        averageData = load('binaryCoinsForAverage_2.mat');
        sub3Data = load('binarySub3_2.mat');
        % Counts number of data in average.mat (since they have the same
        % size we only need to check the size of one dataset)
        numberFields = numel(averageData.coin);
        % Loop to extract all info to the two cell arrays
        for i = 1:numberFields
            binaryCoinData{i} = averageData.coin{i};
            binarySub3Data{i} = sub3Data.sub{i};
        end
        % Size of the coins stored on the dataset
        sizeBinaryData = size(averageData.coin{1},1);
    else 
        existFiles = 0;
        message = 'Since the .mat file used to calculate the average of the coin doesn´t exist the result will not be as accurate';
        z = msgbox(message);
    end
% If country of origin is France
elseif countryCoin == 3
    % Checks if the .mat files used to calculate the average coin exist
    if exist('binaryCoinsForAverage_3.mat') && exist('binarySub3_3.mat')
        % Flag to see if files exist or not
        existFiles = 1;
        % Loads the average and sub3 files
        averageData = load('binaryCoinsForAverage_3.mat');
        sub3Data = load('binarySub3_3.mat');
        % Counts number of data in average.mat (since they have the same
        % size we only need to check the size of one dataset)
        numberFields = numel(averageData.coin);
        % Loop to extract all info to the two cell arrays
        for i = 1:numberFields
            binaryCoinData{i} = averageData.coin{i};
            binarySub3Data{i} = sub3Data.sub{i};
        end
        % Size of the coins stored on the dataset
        sizeBinaryData = size(averageData.coin{1},1);
    else 
        existFiles = 0;
        message = 'Since the .mat file used to calculate the average of the coin doesn´t exist the result will not be as accurate';
        z = msgbox(message);
    end
% If country of origin is mixed or other than Portugal, Spain or France we
% don´t load any .mat file since we do not have that much data on other
% countries
elseif countryCoin == 4
    existFiles = 0;
    message = 'Since the the country of origin is mixed/other we do not have a .mat file to calculate the average and as such the results will not be as accurate';
    z = msgbox(message);
end
        

% Since the calculations can last a long time, this creates a loading bar
f = waitbar(0,'Please wait...');
for i = 1:numberImages
    % RotatesImageHough calculate the angle of the vertical line drawn by
    % the user and rotates the original image according to the angle of the
    % line
    if flagAllAngles == 0
        coin_rotated{i} = rotatesImageHough(coin{i}, coin_line{i});
    else 
        coin_rotated{i} = rotatesImageHough(coin{i}, coin_line{1});
    end
    
    % CropsCircle2 calculates the radius from the center of the coin to the
    % last black line and crops the image around it
    if flagAllAngles == 1 && i == 1
        [coin_rotated_cropped{i}, cropX, cropY, diameter] = cropsCircle2(coin_rotated{i});
    elseif flagAllAngles == 1 && i ~= 1
        coin_rotated_cropped{i} = cropsCircle3(coin_rotated{i}, cropX, cropY, diameter);
    else
        coin_rotated_cropped{i} = cropsCircle2(coin_rotated{i});
    end
    
    % CreateBinaryEdge and CreateBinaryEdge2  both take the cropped image 
    % of the coin and turns it into a binary image with only the most important 
    % edges in white
    % The difference is:
    %   i) createBinaryEdge uses the bwboundaries() function
    %       from MATLAB and does a series of operations to it
    %   ii) createBinaryEdge2 uses the Otsu's method to calculate a
    %   threshold value for the image and everything lower than that value
    %   is white
    % We have both functions because I found that the second method is
    % better to calculate the average and the first method is better to
    % perform the first subtraction (explained ahead)
    binaryCoin2_Rotated{i} = createBinaryEdge2(coin_rotated_cropped{i});
    
    binaryCoin_Rotated{i} = createBinaryEdge(coin_rotated_cropped{i});
    
    % Since the method 2 is only used to calculate the average we don't
    % perform the following operations until the average is finished
    binaryCoin_RotatedThick{i} = bwmorph(binaryCoin_Rotated{i}, 'thicken', 8);
                
    binaryCoin_RotatedFinal{i} = imclose(binaryCoin_RotatedThick{i}, strel('disk', 2));

   
    % This function creates a binary image from the original where it's values
    % are 1 if the pixel has a value less than 50 in grayscale and 0 if higher,
    % to obtain an image with only the most proeminet edges and scratches (if
    % wanted, this value could be reduced or increased).
    binaryImage{i} = createBinaryImage(coin_rotated_cropped{i});
    
    
    % If the size of the new image is smaller than the size of the coins on
    % the dataset
    if existFiles == 1
        if size(binaryImage{i},1) < sizeBinaryData
            sizeBinaryData = size(binaryImage{i},1);
        end
    else 
        sizeBinaryData = size(binaryImage{i},1);
    end
    
    % When reaches the last loop
    if i == numberImages 
        waitbar(i/numberImages + (i/(2*numberImages)), f, 'Almost...');

        % In order to compare the images produced by createBinaryEdge and createBinaryImage, we have to
        % make sure that they all have the same size, since the crop function has a
        % small error and the size of the images can vary up to 10 pixels.
        binaryCoin_RotatedFinal = reshapeCircleImage2(binaryCoin_RotatedFinal, numberImages, sizeBinaryData);
        
        binaryCoin2_Rotated = reshapeCircleImage2(binaryCoin2_Rotated, numberImages, sizeBinaryData);
        
        binaryImage = reshapeCircleImage2(binaryImage, numberImages, sizeBinaryData);
        
        if existFiles == 1
            binaryCoinData = reshapeCircleImage2(binaryCoinData, numberFields, sizeBinaryData);

            binarySub3Data = reshapeCircleImage2(binarySub3Data, numberFields, sizeBinaryData);
        end
        
        if existFiles == 1
            % Calculates the average pixel for the non-rotated and rotated set
            % of images
            average_Rotated = 0;

            for r = 1:numberFields
                average_Rotated = average_Rotated + binaryCoinData{r};
            end

            average_Rotated = average_Rotated/numberFields;
            
            
            % In order to be more precise, we only count as 1 if the
            % pixel is at lest a 0.33 on average (this number could be
            % changed but this is the one that gave the best results)
            average_Rotated = average_Rotated > (1/3)*max(average_Rotated);

            % We then thicken and close the averages to count to small errors for every
            % image, since they are not exactly centered.
            average_RotatedThick = bwmorph(average_Rotated, 'thicken', 4);

            average_RotatedFinal = imclose(average_RotatedThick, strel('disk', 2));
        end

        % At this point the loop is about to be finished and we have all 
        % the images we need to compute the subtractions, so we will loop
        % all coins one last timesub
        for a = 1:numberImages
            % Perform all three subtractions
            sub1{a} = and(binaryImage{a}, not(binaryCoin_RotatedFinal{a}));
            if existFiles == 1
                sub2{a} = and(binaryImage{a}, not(average_RotatedFinal));
                sub3{a} = and(sub1{a}, sub2{a});
            else
                sub3{a} = sub1{a};
            end
            
%             % Remove objects smaller than 5 pixels from every subtraction
            % to remove useless information
            sub1{a} = bwareaopen(sub1{a}, 5);
            if existFiles == 1
                sub2{a} = bwareaopen(sub2{a}, 5);
            end
            sub3{a} = bwareaopen(sub3{a}, 5);                
        end
        
        % Finally, reshapes every image to the exact same size as the
        % smallest to be similar to all the subtractions
        coin_rotated_cropped = reshapeCircleImage2(coin_rotated_cropped, numberImages, sizeBinaryData);
    end
        
    if i ~= numberImages
        % Increments the waiting bar
        waitbar(i/numberImages, f, 'Processing...');
    end
end
% Closes the loading bar
w = waitbar(1,f,'Finishing');
pause(1);
close(w);
   


reply4 = '';
% Asks the user what the want to see
while 1
    list = sprintf('Show x largest scratches\nShow all scratches\nCheck if picture is in dataset and add it if not\nShow coin value');
    [index, tf] = listdlg('PromptString', {'Please choose one'}, 'SelectionMode', 'single', 'ListString', list );
    if tf == 0
        break
    elseif index == 1
        messageNew = sprintf('How many?');
        reply5 = questdlg(messageNew, 'How any', '1', '2', '3', '1');
        numberCircles = str2num(reply5);
        figure(numberFig);
        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
        sgtitle(strcat(reply5,' largest scratches'));
        numberFig = numberFig + 1;
        centers = drawRedCircle2(sub3, numberCircles, numberImages);
        radii(1:numberCircles) = 50;
        for i = 1:numberImages
            subplot(numberPlotX, numberPlotY, i);
            imshow(coin_rotated_cropped{i}); hold on; 
            viscircles(centers{i}, radii);
        end
    elseif index == 2
        figure(numberFig);
        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
        sgtitle('All Scratches');
       numberFig = numberFig + 1;
        for i = 1:numberImages  
            [B,L] = bwboundaries(sub3{i},'noholes');
            subplot(numberPlotX, numberPlotY, i); 
            imshow(coin_rotated_cropped{i}); hold on; 
            for k = 1:length(B)
               boundary = B{k};
               plot(boundary(:,2), boundary(:,1), 'r')
            end   
        end
        if flagAllAngles == 1
             figure(numberFig);
             numberFig = numberFig + 1;
             sub4 = 0;
             for i = 1:numberImages
                 sub4 = sub4 + sub3{i};
             end
             imshow(coin_rotated_cropped{1}); hold on;
             [B,L] = bwboundaries(sub4,'noholes');
             for k = 1:length(B)
                   boundary = B{k};
                   plot(boundary(:,2), boundary(:,1), 'r')
             end
        end
    elseif index == 3
        if existFiles == 1
            flagExists = zeros(numberFields,1);
            flagImageExists = zeros(numberImages,1);
            numFlagExists = 0;
            numStringExists = "";
            for i = 1:numberImages
                % Check if binaryCoin2 exists in the dataset
                for j = 1:numberFields
                    equalPercentage = checkEqualPercentage(binaryCoin2_Rotated{i}, binaryCoinData{j});
                    if equalPercentage >= 99
                        flagExists(j) = 1;
                        flagImageExists(i) = 1;
                        numFlagExists = numFlagExists + 1;
                        numStringExists = strcat(numStringExists, " ");
                        numStringExists = strcat( numStringExists, string(j));
                    end
                end            
            end
        else
            flagImageExists = 0;
            numFlagExists = 0;
            numberFields = 0;
        end

        for i = 1:numberImages
            if flagImageExists == 0
                % The coin i is not in the dataset and we need to add it
                numberFields = numberFields + 1;
                
                binaryCoinData{numberFields} = binaryCoin2_Rotated{i};
                binarySub3Data{numberFields} = sub3{i};

                coin = binaryCoinData;
                sub = binarySub3Data;
                
                if countryCoin == 1
                    save binaryCoinsForAverage_1.mat coin
                    save binarySub3_1.mat sub
                elseif countryCoin == 2
                    save binaryCoinsForAverage_2.mat coin
                    save binarySub3_2.mat sub 
                elseif countryCoin == 3
                    save binaryCoinsForAverage_3.mat coin
                    save binarySub3_3.mat sub 
                end
            end
        end
        if numFlagExists == numberImages
            if numberImages == 1
                messageBox = sprintf(strcat('The coin selected already exists in the dataset on position: ', numStringExists));
            else 
                messageBox = sprintf(strcat('All the coins already exist in the dataset on positions: ', numStringExists));
            end
        elseif numFlagExists == 0
            if numberImages == 1
                messageBox = sprintf(strcat('The coin selected does not exist in the dataset and will be added to it to position: ', string(numberFields)));
            else 
                messageBox = sprintf('None of the coins selected exist in the dataset and will be added to it');
            end
        else
            auxString = sprintf(' %d coins selected are in the dataset on positions: ', numFlagExists);
            messageBox = strcat(auxString, numStringExists);
        end
        f = msgbox(messageBox);
    elseif index == 4
        numStringOneEuro = "";
        if flagCheckValue == 0
            messageBox = 'You did not select images to check the coin values';
        else
            isOneEuro = zeros(numberImages,1);
            numberOneEuro = 0;
            for i = 1:numberImages
                isOneEuro(i) = checkCoinValue(coin_value{i});
                if isOneEuro(i) == 1
                    numberOneEuro = numberOneEuro + 1;
                    numStringOneEuro = strcat(numStringOneEuro, " ");
                    numStringOneEuro = strcat( numStringOneEuro, string(i));
                end
            end
            if numberOneEuro == numberImages
                if numberImages == 1
                    messageBox = 'The coin selected is 1 euro';
                else 
                    messageBox = 'All coins are 1 euro';
                end
            elseif numberOneEuro == 0
                if numberImages == 1
                    messageBox = 'The coin selected is 2 euro';
                else 
                    messageBox = 'All coins are 2 euro';
                end            
            else
                auxString = sprintf(' %d coins selected are 1 euro on positions: ', numberOneEuro);
                messageBox = strcat(auxString, numStringOneEuro);
            end
        end
        f = msgbox(messageBox);
    end
     pause(5);  
     message = sprintf('Do you want to continue?');
     reply5 = questdlg(message, 'Continue?', 'Ok','Cancel', 'Cancel');
    if strcmpi(reply5, 'Cancel')
        break
    end
end

disp('Goodbye');

