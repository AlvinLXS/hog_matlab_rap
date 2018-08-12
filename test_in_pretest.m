%% test the pre_test
clear

addpath('./common/');
addpath('./svm/');
addpath('./search/');
addpath('./svm/minFunc/');

load('rap_ori_C10_hard.mat')
hog.threshold = 0;%0.4 need to be changed when different hog.mat are used

testimgdir = 'G:\RAP-Detection\train_jpg\pre_test';
subtestimgdir  = dir( testimgdir );
 [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
BBX.id=id;
BBX.h=h;
BBX.w=w;
BBX.y=y;
BBX.x=x;
BBX.name=name;
for num = 3 : length( subtestimgdir )%subdir(1)=current path     subdir(2)=former path 
    filename=subtestimgdir(num).name;
    datpath = fullfile( testimgdir, subtestimgdir(num).name);
    img=imread(datpath);
    index=find(strcmp(name,filename));
    goodRects=[x(index) y(index)   w(index) h(index) 1];

    [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=subtestimgdir(num).name;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;

    % Column 5 indicates whether the annotated rectangle is required or 
    % optional.	Person who are in full view are required, persons who are
    % significantly occluded are optional.
    requiredIndeces = (goodRects(:, 5) == 1);
    optionalIndeces = (goodRects(:, 5) == 0);
    goodRects = [goodRects(requiredIndeces, :); goodRects(optionalIndeces, :)];
    numVisiblePeople = sum(requiredIndeces);
    rectsFound = zeros(numVisiblePeople, 1);
    numFalsePositives = 0;
    % Add a column of zeros to the results to store whether it was a true
    % positive (1), a false positive (0), or an optional positive (-1)
    resultRects = [resultRects, zeros(size(resultRects, 1), 1)];
    for k = 1 : size(resultRects, 1)
        % Check if the result rectangle overlaps any of the good rectangles.
        % It will check the 'required' rectangles first because we sorted the rectangles.
        indeces = checkRectOverlap(resultRects(k, :), goodRects, 0.5);%threshold value for overlap
        % If we didn't find a match...
        if (isempty(indeces))
            resultRects(k, end) = 0;
            numFalsePositives = numFalsePositives + 1;
        else
                for i = 1 : length(indeces)
                    if (goodRects(indeces(i), 5) == 1)                    % Indicate it's a good result.
                        resultRects(k, end) = 1;
                        rectsFound(indeces(i)) = 1;
                    else
                        resultRects(k, end) = -1;
                    end
                end
        end
    end
    % The number of unique visible people that we found.
    totalVisibleFound = sum(rectsFound);
    % Print the results.
    fprintf('Found %d / %d people (%.2f%%), with %d false positives.\n', ...
            totalVisibleFound, numVisiblePeople, ...
            totalVisibleFound / numVisiblePeople * 100.0, ...
            numFalsePositives);
    acc(num,1)=totalVisibleFound;
    acc(num,2)=numVisiblePeople;
    acc(num,3)=totalVisibleFound/numVisiblePeople;
    acc(num,4)=numFalsePositives;
    acc(num,5)=totalWindows;

end
missrate1= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW1=sum(acc(:,4))/sum(acc(:,5));
 fprintf('This model rap_ori_C10_hard_0 has the missrate at FPPW =%.5f@%f\n', missrate1,FPPW1);
 
 %%  2
clear

addpath('./common/');
addpath('./svm/');
addpath('./search/');
addpath('./svm/minFunc/');

load('rap_ori_C10_hard.mat')
hog.threshold = 0.1;%0.4 need to be changed when different hog.mat are used

testimgdir = 'G:\RAP-Detection\train_jpg\pre_test';
subtestimgdir  = dir( testimgdir );
 [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
BBX.id=id;
BBX.h=h;
BBX.w=w;
BBX.y=y;
BBX.x=x;
BBX.name=name;
for num = 3 : length( subtestimgdir )%subdir(1)=current path     subdir(2)=former path 
    filename=subtestimgdir(num).name;
    datpath = fullfile( testimgdir, subtestimgdir(num).name);
    img=imread(datpath);
    index=find(strcmp(name,filename));
    goodRects=[x(index) y(index)   w(index) h(index) 1];

    [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=subtestimgdir(num).name;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;

    % Column 5 indicates whether the annotated rectangle is required or 
    % optional.	Person who are in full view are required, persons who are
    % significantly occluded are optional.
    requiredIndeces = (goodRects(:, 5) == 1);
    optionalIndeces = (goodRects(:, 5) == 0);
    goodRects = [goodRects(requiredIndeces, :); goodRects(optionalIndeces, :)];
    numVisiblePeople = sum(requiredIndeces);
    rectsFound = zeros(numVisiblePeople, 1);
    numFalsePositives = 0;
    % Add a column of zeros to the results to store whether it was a true
    % positive (1), a false positive (0), or an optional positive (-1)
    resultRects = [resultRects, zeros(size(resultRects, 1), 1)];
    for k = 1 : size(resultRects, 1)
        % Check if the result rectangle overlaps any of the good rectangles.
        % It will check the 'required' rectangles first because we sorted the rectangles.
        indeces = checkRectOverlap(resultRects(k, :), goodRects, 0.5);%threshold value for overlap
        % If we didn't find a match...
        if (isempty(indeces))
            resultRects(k, end) = 0;
            numFalsePositives = numFalsePositives + 1;
        else
                for i = 1 : length(indeces)
                    if (goodRects(indeces(i), 5) == 1)                    % Indicate it's a good result.
                        resultRects(k, end) = 1;
                        rectsFound(indeces(i)) = 1;
                    else
                        resultRects(k, end) = -1;
                    end
                end
        end
    end
    % The number of unique visible people that we found.
    totalVisibleFound = sum(rectsFound);
    % Print the results.
    fprintf('Found %d / %d people (%.2f%%), with %d false positives.\n', ...
            totalVisibleFound, numVisiblePeople, ...
            totalVisibleFound / numVisiblePeople * 100.0, ...
            numFalsePositives);
    acc(num,1)=totalVisibleFound;
    acc(num,2)=numVisiblePeople;
    acc(num,3)=totalVisibleFound/numVisiblePeople;
    acc(num,4)=numFalsePositives;
    acc(num,5)=totalWindows;

end
missrate1= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW1=sum(acc(:,4))/sum(acc(:,5));
 fprintf('This model rap_ori_C10_hard_0.1 has the missrate at FPPW =%.5f@%f\n', missrate1,FPPW1);
 %% 3
 clear

addpath('./common/');
addpath('./svm/');
addpath('./search/');
addpath('./svm/minFunc/');

load('rap_ori_C10_hard.mat')
hog.threshold = 0.2;%0.4 need to be changed when different hog.mat are used

testimgdir = 'G:\RAP-Detection\train_jpg\pre_test';
subtestimgdir  = dir( testimgdir );
 [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
BBX.id=id;
BBX.h=h;
BBX.w=w;
BBX.y=y;
BBX.x=x;
BBX.name=name;
for num = 3 : length( subtestimgdir )%subdir(1)=current path     subdir(2)=former path 
    filename=subtestimgdir(num).name;
    datpath = fullfile( testimgdir, subtestimgdir(num).name);
    img=imread(datpath);
    index=find(strcmp(name,filename));
    goodRects=[x(index) y(index)   w(index) h(index) 1];

    [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=subtestimgdir(num).name;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;

    % Column 5 indicates whether the annotated rectangle is required or 
    % optional.	Person who are in full view are required, persons who are
    % significantly occluded are optional.
    requiredIndeces = (goodRects(:, 5) == 1);
    optionalIndeces = (goodRects(:, 5) == 0);
    goodRects = [goodRects(requiredIndeces, :); goodRects(optionalIndeces, :)];
    numVisiblePeople = sum(requiredIndeces);
    rectsFound = zeros(numVisiblePeople, 1);
    numFalsePositives = 0;
    % Add a column of zeros to the results to store whether it was a true
    % positive (1), a false positive (0), or an optional positive (-1)
    resultRects = [resultRects, zeros(size(resultRects, 1), 1)];
    for k = 1 : size(resultRects, 1)
        % Check if the result rectangle overlaps any of the good rectangles.
        % It will check the 'required' rectangles first because we sorted the rectangles.
        indeces = checkRectOverlap(resultRects(k, :), goodRects, 0.5);%threshold value for overlap
        % If we didn't find a match...
        if (isempty(indeces))
            resultRects(k, end) = 0;
            numFalsePositives = numFalsePositives + 1;
        else
                for i = 1 : length(indeces)
                    if (goodRects(indeces(i), 5) == 1)                    % Indicate it's a good result.
                        resultRects(k, end) = 1;
                        rectsFound(indeces(i)) = 1;
                    else
                        resultRects(k, end) = -1;
                    end
                end
        end
    end
    % The number of unique visible people that we found.
    totalVisibleFound = sum(rectsFound);
    % Print the results.
    fprintf('Found %d / %d people (%.2f%%), with %d false positives.\n', ...
            totalVisibleFound, numVisiblePeople, ...
            totalVisibleFound / numVisiblePeople * 100.0, ...
            numFalsePositives);
    acc(num,1)=totalVisibleFound;
    acc(num,2)=numVisiblePeople;
    acc(num,3)=totalVisibleFound/numVisiblePeople;
    acc(num,4)=numFalsePositives;
    acc(num,5)=totalWindows;

end
missrate1= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW1=sum(acc(:,4))/sum(acc(:,5));
 fprintf('This model rap_ori_C10_hard_0.2 has the missrate at FPPW =%.5f@%f\n', missrate1,FPPW1);

 %% 4
 clear

addpath('./common/');
addpath('./svm/');
addpath('./search/');
addpath('./svm/minFunc/');

load('rap_ori_C10.mat')
hog.threshold = 0.1;%0.4 need to be changed when different hog.mat are used

testimgdir = 'G:\RAP-Detection\train_jpg\pre_test';
subtestimgdir  = dir( testimgdir );
 [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
BBX.id=id;
BBX.h=h;
BBX.w=w;
BBX.y=y;
BBX.x=x;
BBX.name=name;
for num = 3 : length( subtestimgdir )%subdir(1)=current path     subdir(2)=former path 
    filename=subtestimgdir(num).name;
    datpath = fullfile( testimgdir, subtestimgdir(num).name);
    img=imread(datpath);
    index=find(strcmp(name,filename));
    goodRects=[x(index) y(index)   w(index) h(index) 1];

    [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=subtestimgdir(num).name;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;

    % Column 5 indicates whether the annotated rectangle is required or 
    % optional.	Person who are in full view are required, persons who are
    % significantly occluded are optional.
    requiredIndeces = (goodRects(:, 5) == 1);
    optionalIndeces = (goodRects(:, 5) == 0);
    goodRects = [goodRects(requiredIndeces, :); goodRects(optionalIndeces, :)];
    numVisiblePeople = sum(requiredIndeces);
    rectsFound = zeros(numVisiblePeople, 1);
    numFalsePositives = 0;
    % Add a column of zeros to the results to store whether it was a true
    % positive (1), a false positive (0), or an optional positive (-1)
    resultRects = [resultRects, zeros(size(resultRects, 1), 1)];
    for k = 1 : size(resultRects, 1)
        % Check if the result rectangle overlaps any of the good rectangles.
        % It will check the 'required' rectangles first because we sorted the rectangles.
        indeces = checkRectOverlap(resultRects(k, :), goodRects, 0.5);%threshold value for overlap
        % If we didn't find a match...
        if (isempty(indeces))
            resultRects(k, end) = 0;
            numFalsePositives = numFalsePositives + 1;
        else
                for i = 1 : length(indeces)
                    if (goodRects(indeces(i), 5) == 1)                    % Indicate it's a good result.
                        resultRects(k, end) = 1;
                        rectsFound(indeces(i)) = 1;
                    else
                        resultRects(k, end) = -1;
                    end
                end
        end
    end
    % The number of unique visible people that we found.
    totalVisibleFound = sum(rectsFound);
    % Print the results.
    fprintf('Found %d / %d people (%.2f%%), with %d false positives.\n', ...
            totalVisibleFound, numVisiblePeople, ...
            totalVisibleFound / numVisiblePeople * 100.0, ...
            numFalsePositives);
    acc(num,1)=totalVisibleFound;
    acc(num,2)=numVisiblePeople;
    acc(num,3)=totalVisibleFound/numVisiblePeople;
    acc(num,4)=numFalsePositives;
    acc(num,5)=totalWindows;

end
missrate1= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW1=sum(acc(:,4))/sum(acc(:,5));
 fprintf('This model rap_ori_C10_0.1 has the missrate at FPPW =%.5f@%f\n', missrate1,FPPW1);

 %% 5
  clear

addpath('./common/');
addpath('./svm/');
addpath('./search/');
addpath('./svm/minFunc/');

load('rap_ori_C10.mat')
hog.threshold = 0;%0.4 need to be changed when different hog.mat are used

testimgdir = 'G:\RAP-Detection\train_jpg\pre_test';
subtestimgdir  = dir( testimgdir );
 [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
BBX.id=id;
BBX.h=h;
BBX.w=w;
BBX.y=y;
BBX.x=x;
BBX.name=name;
for num = 3 : length( subtestimgdir )%subdir(1)=current path     subdir(2)=former path 
    filename=subtestimgdir(num).name;
    datpath = fullfile( testimgdir, subtestimgdir(num).name);
    img=imread(datpath);
    index=find(strcmp(name,filename));
    goodRects=[x(index) y(index)   w(index) h(index) 1];

    [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=subtestimgdir(num).name;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;

    % Column 5 indicates whether the annotated rectangle is required or 
    % optional.	Person who are in full view are required, persons who are
    % significantly occluded are optional.
    requiredIndeces = (goodRects(:, 5) == 1);
    optionalIndeces = (goodRects(:, 5) == 0);
    goodRects = [goodRects(requiredIndeces, :); goodRects(optionalIndeces, :)];
    numVisiblePeople = sum(requiredIndeces);
    rectsFound = zeros(numVisiblePeople, 1);
    numFalsePositives = 0;
    % Add a column of zeros to the results to store whether it was a true
    % positive (1), a false positive (0), or an optional positive (-1)
    resultRects = [resultRects, zeros(size(resultRects, 1), 1)];
    for k = 1 : size(resultRects, 1)
        % Check if the result rectangle overlaps any of the good rectangles.
        % It will check the 'required' rectangles first because we sorted the rectangles.
        indeces = checkRectOverlap(resultRects(k, :), goodRects, 0.5);%threshold value for overlap
        % If we didn't find a match...
        if (isempty(indeces))
            resultRects(k, end) = 0;
            numFalsePositives = numFalsePositives + 1;
        else
                for i = 1 : length(indeces)
                    if (goodRects(indeces(i), 5) == 1)                    % Indicate it's a good result.
                        resultRects(k, end) = 1;
                        rectsFound(indeces(i)) = 1;
                    else
                        resultRects(k, end) = -1;
                    end
                end
        end
    end
    % The number of unique visible people that we found.
    totalVisibleFound = sum(rectsFound);
    % Print the results.
    fprintf('Found %d / %d people (%.2f%%), with %d false positives.\n', ...
            totalVisibleFound, numVisiblePeople, ...
            totalVisibleFound / numVisiblePeople * 100.0, ...
            numFalsePositives);
    acc(num,1)=totalVisibleFound;
    acc(num,2)=numVisiblePeople;
    acc(num,3)=totalVisibleFound/numVisiblePeople;
    acc(num,4)=numFalsePositives;
    acc(num,5)=totalWindows;

end
missrate1= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW1=sum(acc(:,4))/sum(acc(:,5));
 fprintf('\n\n5 TH This model rap_ori_C10_0 has the missrate at FPPW =%.5f@%f\n', missrate1,FPPW1);
 %% 6
  clear

addpath('./common/');
addpath('./svm/');
addpath('./search/');
addpath('./svm/minFunc/');

load('rap_ori_C10.mat')
hog.threshold = 0.2;%0.4 need to be changed when different hog.mat are used

testimgdir = 'G:\RAP-Detection\train_jpg\pre_test';
subtestimgdir  = dir( testimgdir );
 [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
BBX.id=id;
BBX.h=h;
BBX.w=w;
BBX.y=y;
BBX.x=x;
BBX.name=name;
for num = 3 : length( subtestimgdir )%subdir(1)=current path     subdir(2)=former path 
    filename=subtestimgdir(num).name;
    datpath = fullfile( testimgdir, subtestimgdir(num).name);
    img=imread(datpath);
    index=find(strcmp(name,filename));
    goodRects=[x(index) y(index)   w(index) h(index) 1];

    [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=subtestimgdir(num).name;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;

    % Column 5 indicates whether the annotated rectangle is required or 
    % optional.	Person who are in full view are required, persons who are
    % significantly occluded are optional.
    requiredIndeces = (goodRects(:, 5) == 1);
    optionalIndeces = (goodRects(:, 5) == 0);
    goodRects = [goodRects(requiredIndeces, :); goodRects(optionalIndeces, :)];
    numVisiblePeople = sum(requiredIndeces);
    rectsFound = zeros(numVisiblePeople, 1);
    numFalsePositives = 0;
    % Add a column of zeros to the results to store whether it was a true
    % positive (1), a false positive (0), or an optional positive (-1)
    resultRects = [resultRects, zeros(size(resultRects, 1), 1)];
    for k = 1 : size(resultRects, 1)
        % Check if the result rectangle overlaps any of the good rectangles.
        % It will check the 'required' rectangles first because we sorted the rectangles.
        indeces = checkRectOverlap(resultRects(k, :), goodRects, 0.5);%threshold value for overlap
        % If we didn't find a match...
        if (isempty(indeces))
            resultRects(k, end) = 0;
            numFalsePositives = numFalsePositives + 1;
        else
                for i = 1 : length(indeces)
                    if (goodRects(indeces(i), 5) == 1)                    % Indicate it's a good result.
                        resultRects(k, end) = 1;
                        rectsFound(indeces(i)) = 1;
                    else
                        resultRects(k, end) = -1;
                    end
                end
        end
    end
    % The number of unique visible people that we found.
    totalVisibleFound = sum(rectsFound);
    % Print the results.
    fprintf('Found %d / %d people (%.2f%%), with %d false positives.\n', ...
            totalVisibleFound, numVisiblePeople, ...
            totalVisibleFound / numVisiblePeople * 100.0, ...
            numFalsePositives);
    acc(num,1)=totalVisibleFound;
    acc(num,2)=numVisiblePeople;
    acc(num,3)=totalVisibleFound/numVisiblePeople;
    acc(num,4)=numFalsePositives;
    acc(num,5)=totalWindows;

end
missrate1= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW1=sum(acc(:,4))/sum(acc(:,5));
 fprintf('\n\n 6 th This model rap_ori_C10_0.2 has the missrate at FPPW =%.5f@%f\n', missrate1,FPPW1);

 %% 7 8 9
 clear

addpath('./common/');
addpath('./svm/');
addpath('./search/');
addpath('./svm/minFunc/');

load('rap_ori_C50.mat')
hog.threshold = 0;%0.4 need to be changed when different hog.mat are used

testimgdir = 'G:\RAP-Detection\train_jpg\pre_test';
subtestimgdir  = dir( testimgdir );
 [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
BBX.id=id;
BBX.h=h;
BBX.w=w;
BBX.y=y;
BBX.x=x;
BBX.name=name;
for num = 3 : length( subtestimgdir )%subdir(1)=current path     subdir(2)=former path 
    filename=subtestimgdir(num).name;
    datpath = fullfile( testimgdir, subtestimgdir(num).name);
    img=imread(datpath);
    index=find(strcmp(name,filename));
    goodRects=[x(index) y(index)   w(index) h(index) 1];

    [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=subtestimgdir(num).name;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;

    % Column 5 indicates whether the annotated rectangle is required or 
    % optional.	Person who are in full view are required, persons who are
    % significantly occluded are optional.
    requiredIndeces = (goodRects(:, 5) == 1);
    optionalIndeces = (goodRects(:, 5) == 0);
    goodRects = [goodRects(requiredIndeces, :); goodRects(optionalIndeces, :)];
    numVisiblePeople = sum(requiredIndeces);
    rectsFound = zeros(numVisiblePeople, 1);
    numFalsePositives = 0;
    % Add a column of zeros to the results to store whether it was a true
    % positive (1), a false positive (0), or an optional positive (-1)
    resultRects = [resultRects, zeros(size(resultRects, 1), 1)];
    for k = 1 : size(resultRects, 1)
        % Check if the result rectangle overlaps any of the good rectangles.
        % It will check the 'required' rectangles first because we sorted the rectangles.
        indeces = checkRectOverlap(resultRects(k, :), goodRects, 0.5);%threshold value for overlap
        % If we didn't find a match...
        if (isempty(indeces))
            resultRects(k, end) = 0;
            numFalsePositives = numFalsePositives + 1;
        else
                for i = 1 : length(indeces)
                    if (goodRects(indeces(i), 5) == 1)                    % Indicate it's a good result.
                        resultRects(k, end) = 1;
                        rectsFound(indeces(i)) = 1;
                    else
                        resultRects(k, end) = -1;
                    end
                end
        end
    end
    % The number of unique visible people that we found.
    totalVisibleFound = sum(rectsFound);
    % Print the results.
    fprintf('Found %d / %d people (%.2f%%), with %d false positives.\n', ...
            totalVisibleFound, numVisiblePeople, ...
            totalVisibleFound / numVisiblePeople * 100.0, ...
            numFalsePositives);
    acc(num,1)=totalVisibleFound;
    acc(num,2)=numVisiblePeople;
    acc(num,3)=totalVisibleFound/numVisiblePeople;
    acc(num,4)=numFalsePositives;
    acc(num,5)=totalWindows;

end
missrate1= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW1=sum(acc(:,4))/sum(acc(:,5));

hog.threshold = 0.1;%0.4 need to be changed when different hog.mat are used

testimgdir = 'G:\RAP-Detection\train_jpg\pre_test';
subtestimgdir  = dir( testimgdir );
 [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
BBX.id=id;
BBX.h=h;
BBX.w=w;
BBX.y=y;
BBX.x=x;
BBX.name=name;
for num = 3 : length( subtestimgdir )%subdir(1)=current path     subdir(2)=former path 
    filename=subtestimgdir(num).name;
    datpath = fullfile( testimgdir, subtestimgdir(num).name);
    img=imread(datpath);
    index=find(strcmp(name,filename));
    goodRects=[x(index) y(index)   w(index) h(index) 1];

    [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=subtestimgdir(num).name;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;

    % Column 5 indicates whether the annotated rectangle is required or 
    % optional.	Person who are in full view are required, persons who are
    % significantly occluded are optional.
    requiredIndeces = (goodRects(:, 5) == 1);
    optionalIndeces = (goodRects(:, 5) == 0);
    goodRects = [goodRects(requiredIndeces, :); goodRects(optionalIndeces, :)];
    numVisiblePeople = sum(requiredIndeces);
    rectsFound = zeros(numVisiblePeople, 1);
    numFalsePositives = 0;
    % Add a column of zeros to the results to store whether it was a true
    % positive (1), a false positive (0), or an optional positive (-1)
    resultRects = [resultRects, zeros(size(resultRects, 1), 1)];
    for k = 1 : size(resultRects, 1)
        % Check if the result rectangle overlaps any of the good rectangles.
        % It will check the 'required' rectangles first because we sorted the rectangles.
        indeces = checkRectOverlap(resultRects(k, :), goodRects, 0.5);%threshold value for overlap
        % If we didn't find a match...
        if (isempty(indeces))
            resultRects(k, end) = 0;
            numFalsePositives = numFalsePositives + 1;
        else
                for i = 1 : length(indeces)
                    if (goodRects(indeces(i), 5) == 1)                    % Indicate it's a good result.
                        resultRects(k, end) = 1;
                        rectsFound(indeces(i)) = 1;
                    else
                        resultRects(k, end) = -1;
                    end
                end
        end
    end
    % The number of unique visible people that we found.
    totalVisibleFound = sum(rectsFound);
    % Print the results.
    fprintf('Found %d / %d people (%.2f%%), with %d false positives.\n', ...
            totalVisibleFound, numVisiblePeople, ...
            totalVisibleFound / numVisiblePeople * 100.0, ...
            numFalsePositives);
    acc(num,1)=totalVisibleFound;
    acc(num,2)=numVisiblePeople;
    acc(num,3)=totalVisibleFound/numVisiblePeople;
    acc(num,4)=numFalsePositives;
    acc(num,5)=totalWindows;

end
missrate2= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW2=sum(acc(:,4))/sum(acc(:,5));

hog.threshold = 0.2;%0.4 need to be changed when different hog.mat are used

testimgdir = 'G:\RAP-Detection\train_jpg\pre_test';
subtestimgdir  = dir( testimgdir );
 [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
BBX.id=id;
BBX.h=h;
BBX.w=w;
BBX.y=y;
BBX.x=x;
BBX.name=name;
for num = 3 : length( subtestimgdir )%subdir(1)=current path     subdir(2)=former path 
    filename=subtestimgdir(num).name;
    datpath = fullfile( testimgdir, subtestimgdir(num).name);
    img=imread(datpath);
    index=find(strcmp(name,filename));
    goodRects=[x(index) y(index)   w(index) h(index) 1];

    [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=subtestimgdir(num).name;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;

    % Column 5 indicates whether the annotated rectangle is required or 
    % optional.	Person who are in full view are required, persons who are
    % significantly occluded are optional.
    requiredIndeces = (goodRects(:, 5) == 1);
    optionalIndeces = (goodRects(:, 5) == 0);
    goodRects = [goodRects(requiredIndeces, :); goodRects(optionalIndeces, :)];
    numVisiblePeople = sum(requiredIndeces);
    rectsFound = zeros(numVisiblePeople, 1);
    numFalsePositives = 0;
    % Add a column of zeros to the results to store whether it was a true
    % positive (1), a false positive (0), or an optional positive (-1)
    resultRects = [resultRects, zeros(size(resultRects, 1), 1)];
    for k = 1 : size(resultRects, 1)
        % Check if the result rectangle overlaps any of the good rectangles.
        % It will check the 'required' rectangles first because we sorted the rectangles.
        indeces = checkRectOverlap(resultRects(k, :), goodRects, 0.5);%threshold value for overlap
        % If we didn't find a match...
        if (isempty(indeces))
            resultRects(k, end) = 0;
            numFalsePositives = numFalsePositives + 1;
        else
                for i = 1 : length(indeces)
                    if (goodRects(indeces(i), 5) == 1)                    % Indicate it's a good result.
                        resultRects(k, end) = 1;
                        rectsFound(indeces(i)) = 1;
                    else
                        resultRects(k, end) = -1;
                    end
                end
        end
    end
    % The number of unique visible people that we found.
    totalVisibleFound = sum(rectsFound);
    % Print the results.
    fprintf('Found %d / %d people (%.2f%%), with %d false positives.\n', ...
            totalVisibleFound, numVisiblePeople, ...
            totalVisibleFound / numVisiblePeople * 100.0, ...
            numFalsePositives);
    acc(num,1)=totalVisibleFound;
    acc(num,2)=numVisiblePeople;
    acc(num,3)=totalVisibleFound/numVisiblePeople;
    acc(num,4)=numFalsePositives;
    acc(num,5)=totalWindows;

end
missrate3= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW3=sum(acc(:,4))/sum(acc(:,5));


 fprintf('\n\n 7 th This model rap_ori_C50_0 has the missrate at FPPW =%.5f@%f\n', missrate1,FPPW1);
 fprintf('\n\n 8 th This model rap_ori_C50_0.1 has the missrate at FPPW =%.5f@%f\n', missrate2,FPPW2);
  fprintf('\n\n 9 th This model rap_ori_C50_0.2 has the missrate at FPPW =%.5f@%f\n', missrate3,FPPW3);
 
  %% 10 11 12 13
   clear

addpath('./common/');
addpath('./svm/');
addpath('./search/');
addpath('./svm/minFunc/');

load('inria_no_hard_C10.mat')
hog.threshold = 0.1;%0.4 need to be changed when different hog.mat are used

testimgdir = 'G:\RAP-Detection\train_jpg\pre_test';
subtestimgdir  = dir( testimgdir );
 [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
BBX.id=id;
BBX.h=h;
BBX.w=w;
BBX.y=y;
BBX.x=x;
BBX.name=name;
for num = 3 : length( subtestimgdir )%subdir(1)=current path     subdir(2)=former path 
    filename=subtestimgdir(num).name;
    datpath = fullfile( testimgdir, subtestimgdir(num).name);
    img=imread(datpath);
    index=find(strcmp(name,filename));
    goodRects=[x(index) y(index)   w(index) h(index) 1];

    [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=subtestimgdir(num).name;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;

    % Column 5 indicates whether the annotated rectangle is required or 
    % optional.	Person who are in full view are required, persons who are
    % significantly occluded are optional.
    requiredIndeces = (goodRects(:, 5) == 1);
    optionalIndeces = (goodRects(:, 5) == 0);
    goodRects = [goodRects(requiredIndeces, :); goodRects(optionalIndeces, :)];
    numVisiblePeople = sum(requiredIndeces);
    rectsFound = zeros(numVisiblePeople, 1);
    numFalsePositives = 0;
    % Add a column of zeros to the results to store whether it was a true
    % positive (1), a false positive (0), or an optional positive (-1)
    resultRects = [resultRects, zeros(size(resultRects, 1), 1)];
    for k = 1 : size(resultRects, 1)
        % Check if the result rectangle overlaps any of the good rectangles.
        % It will check the 'required' rectangles first because we sorted the rectangles.
        indeces = checkRectOverlap(resultRects(k, :), goodRects, 0.5);%threshold value for overlap
        % If we didn't find a match...
        if (isempty(indeces))
            resultRects(k, end) = 0;
            numFalsePositives = numFalsePositives + 1;
        else
                for i = 1 : length(indeces)
                    if (goodRects(indeces(i), 5) == 1)                    % Indicate it's a good result.
                        resultRects(k, end) = 1;
                        rectsFound(indeces(i)) = 1;
                    else
                        resultRects(k, end) = -1;
                    end
                end
        end
    end
    % The number of unique visible people that we found.
    totalVisibleFound = sum(rectsFound);
    % Print the results.
    fprintf('Found %d / %d people (%.2f%%), with %d false positives.\n', ...
            totalVisibleFound, numVisiblePeople, ...
            totalVisibleFound / numVisiblePeople * 100.0, ...
            numFalsePositives);
    acc(num,1)=totalVisibleFound;
    acc(num,2)=numVisiblePeople;
    acc(num,3)=totalVisibleFound/numVisiblePeople;
    acc(num,4)=numFalsePositives;
    acc(num,5)=totalWindows;

end
missrate1= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW1=sum(acc(:,4))/sum(acc(:,5));

hog.threshold = 0.2;%0.4 need to be changed when different hog.mat are used

testimgdir = 'G:\RAP-Detection\train_jpg\pre_test';
subtestimgdir  = dir( testimgdir );
 [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
BBX.id=id;
BBX.h=h;
BBX.w=w;
BBX.y=y;
BBX.x=x;
BBX.name=name;
for num = 3 : length( subtestimgdir )%subdir(1)=current path     subdir(2)=former path 
    filename=subtestimgdir(num).name;
    datpath = fullfile( testimgdir, subtestimgdir(num).name);
    img=imread(datpath);
    index=find(strcmp(name,filename));
    goodRects=[x(index) y(index)   w(index) h(index) 1];

    [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=subtestimgdir(num).name;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;

    % Column 5 indicates whether the annotated rectangle is required or 
    % optional.	Person who are in full view are required, persons who are
    % significantly occluded are optional.
    requiredIndeces = (goodRects(:, 5) == 1);
    optionalIndeces = (goodRects(:, 5) == 0);
    goodRects = [goodRects(requiredIndeces, :); goodRects(optionalIndeces, :)];
    numVisiblePeople = sum(requiredIndeces);
    rectsFound = zeros(numVisiblePeople, 1);
    numFalsePositives = 0;
    % Add a column of zeros to the results to store whether it was a true
    % positive (1), a false positive (0), or an optional positive (-1)
    resultRects = [resultRects, zeros(size(resultRects, 1), 1)];
    for k = 1 : size(resultRects, 1)
        % Check if the result rectangle overlaps any of the good rectangles.
        % It will check the 'required' rectangles first because we sorted the rectangles.
        indeces = checkRectOverlap(resultRects(k, :), goodRects, 0.5);%threshold value for overlap
        % If we didn't find a match...
        if (isempty(indeces))
            resultRects(k, end) = 0;
            numFalsePositives = numFalsePositives + 1;
        else
                for i = 1 : length(indeces)
                    if (goodRects(indeces(i), 5) == 1)                    % Indicate it's a good result.
                        resultRects(k, end) = 1;
                        rectsFound(indeces(i)) = 1;
                    else
                        resultRects(k, end) = -1;
                    end
                end
        end
    end
    % The number of unique visible people that we found.
    totalVisibleFound = sum(rectsFound);
    % Print the results.
    fprintf('Found %d / %d people (%.2f%%), with %d false positives.\n', ...
            totalVisibleFound, numVisiblePeople, ...
            totalVisibleFound / numVisiblePeople * 100.0, ...
            numFalsePositives);
    acc(num,1)=totalVisibleFound;
    acc(num,2)=numVisiblePeople;
    acc(num,3)=totalVisibleFound/numVisiblePeople;
    acc(num,4)=numFalsePositives;
    acc(num,5)=totalWindows;

end
missrate2= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW2=sum(acc(:,4))/sum(acc(:,5));

load('inria_hard_C10.mat')
hog.threshold = 0.1;%0.4 need to be changed when different hog.mat are used

testimgdir = 'G:\RAP-Detection\train_jpg\pre_test';
subtestimgdir  = dir( testimgdir );
 [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
BBX.id=id;
BBX.h=h;
BBX.w=w;
BBX.y=y;
BBX.x=x;
BBX.name=name;
for num = 3 : length( subtestimgdir )%subdir(1)=current path     subdir(2)=former path 
    filename=subtestimgdir(num).name;
    datpath = fullfile( testimgdir, subtestimgdir(num).name);
    img=imread(datpath);
    index=find(strcmp(name,filename));
    goodRects=[x(index) y(index)   w(index) h(index) 1];

    [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=subtestimgdir(num).name;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;

    % Column 5 indicates whether the annotated rectangle is required or 
    % optional.	Person who are in full view are required, persons who are
    % significantly occluded are optional.
    requiredIndeces = (goodRects(:, 5) == 1);
    optionalIndeces = (goodRects(:, 5) == 0);
    goodRects = [goodRects(requiredIndeces, :); goodRects(optionalIndeces, :)];
    numVisiblePeople = sum(requiredIndeces);
    rectsFound = zeros(numVisiblePeople, 1);
    numFalsePositives = 0;
    % Add a column of zeros to the results to store whether it was a true
    % positive (1), a false positive (0), or an optional positive (-1)
    resultRects = [resultRects, zeros(size(resultRects, 1), 1)];
    for k = 1 : size(resultRects, 1)
        % Check if the result rectangle overlaps any of the good rectangles.
        % It will check the 'required' rectangles first because we sorted the rectangles.
        indeces = checkRectOverlap(resultRects(k, :), goodRects, 0.5);%threshold value for overlap
        % If we didn't find a match...
        if (isempty(indeces))
            resultRects(k, end) = 0;
            numFalsePositives = numFalsePositives + 1;
        else
                for i = 1 : length(indeces)
                    if (goodRects(indeces(i), 5) == 1)                    % Indicate it's a good result.
                        resultRects(k, end) = 1;
                        rectsFound(indeces(i)) = 1;
                    else
                        resultRects(k, end) = -1;
                    end
                end
        end
    end
    % The number of unique visible people that we found.
    totalVisibleFound = sum(rectsFound);
    % Print the results.
    fprintf('Found %d / %d people (%.2f%%), with %d false positives.\n', ...
            totalVisibleFound, numVisiblePeople, ...
            totalVisibleFound / numVisiblePeople * 100.0, ...
            numFalsePositives);
    acc(num,1)=totalVisibleFound;
    acc(num,2)=numVisiblePeople;
    acc(num,3)=totalVisibleFound/numVisiblePeople;
    acc(num,4)=numFalsePositives;
    acc(num,5)=totalWindows;

end
missrate3= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW3=sum(acc(:,4))/sum(acc(:,5));


hog.threshold = 0.2;%0.4 need to be changed when different hog.mat are used

testimgdir = 'G:\RAP-Detection\train_jpg\pre_test';
subtestimgdir  = dir( testimgdir );
 [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
BBX.id=id;
BBX.h=h;
BBX.w=w;
BBX.y=y;
BBX.x=x;
BBX.name=name;
for num = 3 : length( subtestimgdir )%subdir(1)=current path     subdir(2)=former path 
    filename=subtestimgdir(num).name;
    datpath = fullfile( testimgdir, subtestimgdir(num).name);
    img=imread(datpath);
    index=find(strcmp(name,filename));
    goodRects=[x(index) y(index)   w(index) h(index) 1];

    [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=subtestimgdir(num).name;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;

    % Column 5 indicates whether the annotated rectangle is required or 
    % optional.	Person who are in full view are required, persons who are
    % significantly occluded are optional.
    requiredIndeces = (goodRects(:, 5) == 1);
    optionalIndeces = (goodRects(:, 5) == 0);
    goodRects = [goodRects(requiredIndeces, :); goodRects(optionalIndeces, :)];
    numVisiblePeople = sum(requiredIndeces);
    rectsFound = zeros(numVisiblePeople, 1);
    numFalsePositives = 0;
    % Add a column of zeros to the results to store whether it was a true
    % positive (1), a false positive (0), or an optional positive (-1)
    resultRects = [resultRects, zeros(size(resultRects, 1), 1)];
    for k = 1 : size(resultRects, 1)
        % Check if the result rectangle overlaps any of the good rectangles.
        % It will check the 'required' rectangles first because we sorted the rectangles.
        indeces = checkRectOverlap(resultRects(k, :), goodRects, 0.5);%threshold value for overlap
        % If we didn't find a match...
        if (isempty(indeces))
            resultRects(k, end) = 0;
            numFalsePositives = numFalsePositives + 1;
        else
                for i = 1 : length(indeces)
                    if (goodRects(indeces(i), 5) == 1)                    % Indicate it's a good result.
                        resultRects(k, end) = 1;
                        rectsFound(indeces(i)) = 1;
                    else
                        resultRects(k, end) = -1;
                    end
                end
        end
    end
    % The number of unique visible people that we found.
    totalVisibleFound = sum(rectsFound);
    % Print the results.
    fprintf('Found %d / %d people (%.2f%%), with %d false positives.\n', ...
            totalVisibleFound, numVisiblePeople, ...
            totalVisibleFound / numVisiblePeople * 100.0, ...
            numFalsePositives);
    acc(num,1)=totalVisibleFound;
    acc(num,2)=numVisiblePeople;
    acc(num,3)=totalVisibleFound/numVisiblePeople;
    acc(num,4)=numFalsePositives;
    acc(num,5)=totalWindows;

end
missrate4= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW4=sum(acc(:,4))/sum(acc(:,5));

 fprintf('\n\n 8 th This model inria_no_hard_C10_0.1 has the missrate at FPPW =%.5f@%f\n', missrate1,FPPW1);
 fprintf('\n\n 9 th This model inria_no_hard_C10_0.2 has the missrate at FPPW =%.5f@%f\n', missrate2,FPPW2);
  fprintf('\n\n 10 th This model inria_hard_C10_0.1 has the missrate at FPPW =%.5f@%f\n', missrate3,FPPW3);
   fprintf('\n\n 11 th This model inria_hard_C10_0.2 has the missrate at FPPW =%.5f@%f\n', missrate4,FPPW4);