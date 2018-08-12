%%The Experiment steps from get original image to test the model on the
%%test set
% [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
% BBX.id=id;
% BBX.h=h;
% BBX.w=w;
% BBX.y=y;
% BBX.y=x;
% BBX.name=name;
% size(BBX.name)
% for i=1:size(BBX.name,1)-1
%     bbx=[BBX.h(i) BBX.w(i) BBX.y(i) BBX.x(i) ];
%     for j=i+1:size(BBX.name,1)
%         if(BBX.name(i)==BBX.name(j))
%             bbx=[bbx;[BBX.h(j) BBX.w(j) BBX.y(j) BBX.x(j) ]];
%             BBX.id(j)=[];
%             BBX.h(j)=[];
%             BBX.w(j)=[];
%             BBX.y(j)=[];
%             BBX.y(j)=[];
%             BBX.name(j)=[];
%             j=j-1;
%         end
%     end
% end
% tic();
% [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
% BBX.id=id;
% BBX.h=h;
% BBX.w=w;
% BBX.y=y;
% BBX.y=x;
% BBX.name=name;
% size(BBX.name)
% index=[];
%  i=1;
% for j=2:size(BBX.name,1)
%     if(strcmp(BBX.name{i,1},BBX.name{j,1})==1)
%         j;
%         index=[index;[i,j]];
%     end
% end
% for i=2:size(BBX.name,1)-1
%     for j=[1:i-1,i+1:size(BBX.name,1)]
%     if(strcmp(BBX.name{i,1},BBX.name{j,1})==1)
% 
%         index=[index;[i,j]];
%     end
% end
% end
%  i=size(BBX.name,1);
% for j=1:size(BBX.name,1)-1
%     if(strcmp(BBX.name{i,1},BBX.name{j,1})==1)
%        index=[index;[i,j]];
%     end
% end
% elapsed = toc();
% fprintf(' search took %.5f seconds\n', elapsed);

%% test the performance of the pretrained model in the inria without train in the RAP
addpath('./common/');
addpath('./svm/');
addpath('./svm/minFunc/');
addpath('./search/')
hog.numBins = 9;
hog.numHorizCells = 8;
hog.numVertCells = 16;
hog.cellSize = 8;
hog.winSize = [(hog.numVertCells * hog.cellSize + 2), ...
               (hog.numHorizCells * hog.cellSize + 2)];
           
           
load('inria_no_hard.mat')
hog.threshold = 0.1;
imgdir='G:\RAP-Detection\test_jpg\test_jpg'
testimgdir = dir(imgdir);
acc=zeros(length(testimgdir),5);
for num = 3 : length( testimgdir )
    filename=testimgdir(num).name;
    imgpath=fullfile(imgdir,filename);
    img=imread(imgpath);
     %tic();
     [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=filename;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;
    %elapsed = toc();
    fprintf('Finish %dth image in 17212 images',num-2);
   % fprintf('Image search took %.2f seconds\n', elapsed);
end
save('resultRectsrecord_RAP_inrianohard.mat','resultRectsrecord');

%% get the pos set
% oridir='G:\RAP-Detection\train_jpg\train_jpg';
% 
% outdir='G:\RAP-Detection\train_jpg\POS\';
% trainoridir=dir(oridir);
% [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
% BBX.id=id;
% BBX.h=h;
% BBX.w=w;
% BBX.y=y;
% BBX.y=x;
% BBX.name=name;
% for num=3:length(trainoridir)
%     filename=trainoridir(num).name;
%     imgpath=fullfile(oridir,trainoridir(num).name);
%     img=imread(imgpath);
%     index=find(strcmp(name,filename));
%     if(size(index,1)>=2||size(index,2)>=2)
%         continue
%     end
%     xstart=x(index);
%     ystart=y(index);
%     height=h(index);
%     width=w(index);
%     new=imcrop(img,[xstart,ystart,width-1,height-1]);
%     imggray=rgb2gray(new);
%     imgfit=imresize(imggray,[130,66]);  
%     imwrite(imgfit,[outdir,num2str(num-2,'%06d'),'.png']);  
% end
%% get the NEG set
% oridir1='G:\RAP-Detection\train_jpg\neg_ori';
% outdir1='G:\RAP-Detection\train_jpg\NEG\';
% trainoridir1=dir(oridir1);
%     count=0;
% for num=3:length(trainoridir1)
%     filename1=trainoridir1(num).name;
%     imgpath1=fullfile(oridir1,trainoridir1(num).name);
%     img=imread(imgpath1);
%     imggray=rgb2gray(img);
%     [bottomRightRow,bottomRightCol,d] = size(imggray);
%     width=66-1;
%     height=130-1;
%     ymax = bottomRightCol - 66;
%     xmax = bottomRightRow - 130;
%     a=0;b=0;c=0;
%     if(bottomRightRow*bottomRightCol<=2*66*130)
%         for j=1:3
%             count=count+1;
%             y = randi(ymax,1);%随机左上角y坐标
%             x = randi(xmax,1);%随机左上角x坐标
%             imgfit= imcrop(imggray,[y,x,width,height]);%裁剪
%             imwrite(imgfit,[outdir1,num2str(count,'%06d'),'.png']);
%         end
%     end
%     if((bottomRightRow*bottomRightCol<10*66*130)&&(bottomRightRow*bottomRightCol>=3*66*130))
%     for j=1:10
%         count=count+1;
%         y = randi(ymax,1);%随机左上角y坐标
%         x = randi(xmax,1);%随机左上角x坐标
%         imgfit= imcrop(imggray,[y,x,width,height]);%裁剪
%         imwrite(imgfit,[outdir1,num2str(count,'%06d'),'.png']);
%     end
%     end
%     if(bottomRightRow*bottomRightCol>=10*66*130)
%         for j=1:30
%             count=count+1;
%             y = randi(ymax,1);%随机左上角y坐标
%             x = randi(xmax,1);%随机左上角x坐标
%             imgfit= imcrop(imggray,[y,x,width,height]);%裁剪
%             imwrite(imgfit,[outdir1,num2str(count,'%06d'),'.png']);
%         end
%     end
% end

%% train the SVM for RAP
% addpath('./common/');
% addpath('./svm/');
% addpath('./svm/minFunc/');
% hog.numBins = 9;
% hog.numHorizCells = 8;
% hog.numVertCells = 16;
% hog.cellSize = 8;
% hog.winSize = [(hog.numVertCells * hog.cellSize + 2), ...
%                (hog.numHorizCells * hog.cellSize + 2)];
%            
% posFiles = getImagesInDir('G:\RAP-Detection\train_jpg\POS\', true);
% negFiles = getImagesInDir('G:\RAP-Detection\train_jpg\NEG\', true);
% hardFiles= getImagesInDir('G:\INIRADATA_CROP\train\NEG\', true);
% y_train = [ones(length(posFiles), 1); zeros(length(negFiles), 1);zeros(length(hardFiles), 1)];
% fileList = [posFiles, negFiles,hardFiles];
% X_train = zeros(length(fileList), 3780);%3780=36*7*15
% fprintf('Computing descriptors for %d training windows: ', length(fileList));
% 		
% % For all training window images...
% for i = 1 : length(fileList)
%     imgFile = char(fileList(i));
%     img = imread(imgFile);
%     H = getHOGDescriptor(hog, img);
%     X_train(i, :) = H';
% end
% fprintf('\n');
% 
% % Train the SVM for the  second time.
% fprintf('\nTraining linear SVM classifier for the first time ...\n');
% C=10;%软间隔SVM的系数C，
% hog.theta = train_svm(X_train, y_train, C);
% save('rap_ori.mat', 'hog');
% p = X_train *hog.theta;
% numRight = sum((p > 0) == y_train);
% fprintf('\nTraining accuracy : (%d / %d) %.2f%%\n', numRight, length(y_train), numRight / length(y_train) * 100.0);

%% test the rap_ori model 
addpath('./common/');
addpath('./svm/');
addpath('./svm/minFunc/');
addpath('./search/')
hog.numBins = 9;
hog.numHorizCells = 8;
hog.numVertCells = 16;
hog.cellSize = 8;
hog.winSize = [(hog.numVertCells * hog.cellSize + 2), ...
               (hog.numHorizCells * hog.cellSize + 2)];
                  
% load('rap_ori.mat')
% hog.threshold = 0.1;
% imgdir='G:\RAP-Detection\test_jpg\test_jpg';
% testimgdir = dir(imgdir);
% acc=zeros(length(testimgdir),5);
% for num = 3 : length( testimgdir )
%     filename=testimgdir(num).name;
%     imgpath=fullfile(imgdir,filename);
%     img=imread(imgpath);
%     % tic();
%      [resultRects,totalWindows] = searchImage(hog, img); 
%     %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
%     resultRectsrecord{1,num}=filename;
%     resultRectsrecord{2,num}=resultRects;
%      resultRectsrecord{3,num}=totalWindows;
%    % elapsed = toc();
%     fprintf('Finish %dth image in 17212 images',num-2);
%    % fprintf('Image search took %.2f seconds\n', elapsed);
% end
% save('resultRectsrecord_RAP_rapori.mat','resultRectsrecord');

%% get the pre_test set
% oridir='G:\RAP-Detection\train_jpg\train_jpg';
% outdir='G:\RAP-Detection\train_jpg\pre_test\';
% trainoridir=dir(oridir);
% 
% [id,h,w,y,x,name]=textread('G:\RAP-Detection\annotations.txt','%f%f %f %f%f%s');
% BBX.id=id;
% BBX.h=h;
% BBX.w=w;
% BBX.y=y;
% BBX.x=x;
% BBX.name=name;
% 
% for num=3:200:length(trainoridir)
%     filename=trainoridir(num).name;
%     imgpath=fullfile(oridir,trainoridir(num).name);
%     img=imread(imgpath);
%     index=find(strcmp(name,filename));
%     if(size(index,1)>=2||size(index,2)>=2)
%         continue
%     end
%     imggray=rgb2gray(img);  
%     imwrite(imggray,[outdir,filename]);  
% end

%% train different svm(C=50) for rap set
addpath('./common/');
addpath('./svm/');
addpath('./svm/minFunc/');
hog.numBins = 9;
hog.numHorizCells = 8;
hog.numVertCells = 16;
hog.cellSize = 8;
hog.winSize = [(hog.numVertCells * hog.cellSize + 2), ...
               (hog.numHorizCells * hog.cellSize + 2)];
           
posFiles = getImagesInDir('G:\RAP-Detection\train_jpg\POS\', true);
negFiles = getImagesInDir('G:\RAP-Detection\train_jpg\NEG\', true);
hardFiles= getImagesInDir('G:\INIRADATA_CROP\train\NEG\', true);
y_train = [ones(length(posFiles), 1); zeros(length(negFiles), 1);zeros(length(hardFiles), 1)];
fileList = [posFiles, negFiles,hardFiles];
X_train = zeros(length(fileList), 3780);%3780=36*7*15
fprintf('Computing descriptors for %d training windows: ', length(fileList));
		
% For all training window images...
for i = 1 : length(fileList)
    imgFile = char(fileList(i));
    img = imread(imgFile);
    H = getHOGDescriptor(hog, img);
    X_train(i, :) = H';
end
fprintf('\n');

fprintf('\nTraining linear SVM classifier for the first time ...\n');
C=50;%软间隔SVM的系数C，
hog.theta = train_svm(X_train, y_train, C);
save('rap_ori_C50.mat', 'hog');
p = X_train *hog.theta;
numRight = sum((p > 0) == y_train);
fprintf('\nTraining accuracy : (%d / %d) %.2f%%\n', numRight, length(y_train), numRight / length(y_train) * 100.0);

%% GET HARD EXAMPLE FOR RAP
load('rap_ori_C50.mat')
hog.threshold = 0.1;
negFiles = getImagesInDir('G:\RAP-Detection\train_jpg\neg_ori\', true);
fileList=[negFiles];
OutputDirhard='G:\RAP-Detection\train_jpg\HARD\';
namedir=dir('G:\RAP-Detection\train_jpg\neg_ori\');

numHardimg=0;
for i = 3 : length(fileList)
    % Get the next filename.
    imgFile = char(fileList(i));
    img = imread(imgFile);
    imggray=rgb2gray(img);
    [bottomRightRow,bottomRightCol,d] = size(imggray);
    width=66-1;
    height=130-1;
    ymax = bottomRightCol - 66;
    xmax = bottomRightRow - 130;
    numhardwin=0;
    count=0;
    for j=1:8:xmax
        for k =1:8:ymax
            x= imcrop(imggray,[k,j,width,height]);%裁剪
            H = getHOGDescriptor(hog, x);
            des = H';
            p = des *hog.theta;
            if p>0.45
                count=count+1;
                if count==1
                    numHardimg=numHardimg+1;
                end
                numhardwin=numhardwin+1;
               imwrite(x,[OutputDirhard,num2str(numHardimg,'%06d'),'_',num2str(numhardwin,'%06d'),'.jpg']);
               hardexample{1,numHardimg}=namedir(i).name;
                hardexample{numhardwin+1,numHardimg}=[k,j,width,height];
            end 
        end
    end
end 
fprintf('\n hard example search finished')
save('hardforRap.mat','hardexample')

%% train rap model with hard example
addpath('./common/');
addpath('./svm/');
addpath('./svm/minFunc/');
hog.numBins = 9;
hog.numHorizCells = 8;
hog.numVertCells = 16;
hog.cellSize = 8;
hog.winSize = [(hog.numVertCells * hog.cellSize + 2), ...
               (hog.numHorizCells * hog.cellSize + 2)];
           
posFiles = getImagesInDir('G:\RAP-Detection\train_jpg\POS\', true);
negFiles = getImagesInDir('G:\RAP-Detection\train_jpg\NEG\', true);
hardFiles= getImagesInDir('G:\INIRADATA_CROP\train\NEG\', true);
hardFiles2=getImagesInDir('G:\RAP-Detection\train_jpg\HARD\', true);
y_train = [ones(length(posFiles), 1); zeros(length(negFiles), 1);zeros(length(hardFiles), 1);zeros(length(hardFiles2), 1)];
fileList = [posFiles, negFiles,hardFiles,hardFiles2];
X_train = zeros(length(fileList), 3780);%3780=36*7*15
fprintf('Computing descriptors for %d training windows: ', length(fileList));
		
% For all training window images...
for i = 1 : length(fileList)
    imgFile = char(fileList(i));
    img = imread(imgFile);
    H = getHOGDescriptor(hog, img);
    X_train(i, :) = H';
end
fprintf('\n');

fprintf('\nTraining linear SVM classifier for the first time ...\n');
C=10;%软间隔SVM的系数C，
hog.theta = train_svm(X_train, y_train, C);
save('rap_ori_C10_hard.mat', 'hog');
p = X_train *hog.theta;
numRight = sum((p > 0) == y_train);
fprintf('\nTraining accuracy : (%d / %d) %.2f%%\n', numRight, length(y_train), numRight / length(y_train) * 100.0);

%% test the rap_ori_C10_hard model in the pre_test
clear

addpath('./common/');
addpath('./svm/');
addpath('./search/');
addpath('./svm/minFunc/');

load('rap_ori_C10_hard.mat')
 %===================================================
 %===================================================
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
 fprintf('This model has the missrate at FPPW =%.5f@%f\n', missrate1,FPPW1);
 
 %%   test the rap_ori_C10_hard model in the pre_test
 % hog.threshold is different here
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
 fprintf('This model has the missrate at FPPW =%.5f@%f\n', missrate1,FPPW1);
 fprintf('This model has the missrate at FPPW =%.5f@%f\n', missrate2,FPPW2);

%% choose the model rap_ori_C10_hard and run the  rap test set
clear
tic();
addpath('./common/');
addpath('./svm/');
addpath('./svm/minFunc/');
addpath('./search/')
hog.numBins = 9;
hog.numHorizCells = 8;
hog.numVertCells = 16;
hog.cellSize = 8;
hog.winSize = [(hog.numVertCells * hog.cellSize + 2), ...
               (hog.numHorizCells * hog.cellSize + 2)];
                  
load('rap_ori_C10_hard.mat');
hog.threshold = 0.1;
imgdir='G:\RAP-Detection\test_jpg\test_jpg';
testimgdir = dir(imgdir);
for num = 3 : length( testimgdir )
    filename=testimgdir(num).name;
    imgpath=fullfile(imgdir,filename);
    img=imread(imgpath);
    % tic();
     [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=filename;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;
   % elapsed = toc();
    fprintf('Finish %d th image in 17212 images',num-2);
   % fprintf('Image search took %.2f seconds\n', elapsed);
end
save('resultRectsrecord_RAP_rapori_C10_hard_0.1.mat','resultRectsrecord');
 elapsed = toc();
 fprintf('test took %.2f hours\n', elapsed/3600);
%%   test the rap_ori_C10_hard model in the pre_test with  hog.threshold=0.05
 % hog.threshold is different here
clear
tic();
addpath('./common/');
addpath('./svm/');
addpath('./svm/minFunc/');
addpath('./search/')
hog.numBins = 9;
hog.numHorizCells = 8;
hog.numVertCells = 16;
hog.cellSize = 8;
hog.winSize = [(hog.numVertCells * hog.cellSize + 2), ...
               (hog.numHorizCells * hog.cellSize + 2)];
                  
load('rap_ori_C10_hard.mat');
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
missrate2= sum(acc(:,2)-acc(:,1))/sum(acc(:,2));
FPPW2=sum(acc(:,4))/sum(acc(:,5));
 fprintf('This model rap_ori_C10_hard, hog.threshold = 0\n');
 fprintf('This model has the missrate= %.5f@ FPPW =%.5f\n', missrate2,FPPW2);

 %% 0417 record the resultRects 
 %choose the model rap_ori_C10_hard and run the  rap test set
 clear
tic();
addpath('./common/');
addpath('./svm/');
addpath('./svm/minFunc/');
addpath('./search/')
hog.numBins = 9;
hog.numHorizCells = 8;
hog.numVertCells = 16;
hog.cellSize = 8;
hog.winSize = [(hog.numVertCells * hog.cellSize + 2), ...
               (hog.numHorizCells * hog.cellSize + 2)];
                  
load('rap_ori_C10_hard.mat');
hog.threshold = 0.2;
imgdir='G:\RAP-Detection\test_jpg\test_jpg';
testimgdir = dir(imgdir);
for num = 3 : length( testimgdir )
    filename=testimgdir(num).name;
    imgpath=fullfile(imgdir,filename);
    img=imread(imgpath);
    % tic();
     [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=filename;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;
   % elapsed = toc();
    fprintf('Finish %d th image in 17212 images',num-2);
   % fprintf('Image search took %.2f seconds\n', elapsed);
end
save('resultRectsrecord_RAP_rapori_C10_hard_0.2.mat','resultRectsrecord');
 elapsed = toc();
 fprintf('test took %.2f hours\n', elapsed/3600);
 
 %% change the hog.threshold=0
  clear
tic();
addpath('./common/');
addpath('./svm/');
addpath('./svm/minFunc/');
addpath('./search/')
hog.numBins = 9;
hog.numHorizCells = 8;
hog.numVertCells = 16;
hog.cellSize = 8;
hog.winSize = [(hog.numVertCells * hog.cellSize + 2), ...
               (hog.numHorizCells * hog.cellSize + 2)];
                  
load('rap_ori_C10_hard.mat');
hog.threshold = 0;
imgdir='G:\RAP-Detection\test_jpg\test_jpg';
testimgdir = dir(imgdir);
for num = 3 : length( testimgdir )
    filename=testimgdir(num).name;
    imgpath=fullfile(imgdir,filename);
    img=imread(imgpath);
    % tic();
     [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=filename;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;
   % elapsed = toc();
    fprintf('Finish %d th image in 17212 images',num-2);
   % fprintf('Image search took %.2f seconds\n', elapsed);
end
save('resultRectsrecord_RAP_rapori_C10_hard_0.mat','resultRectsrecord');
 elapsed = toc();
 fprintf('test took %.2f hours\n', elapsed/3600);
 fprintf('3scale,rap_ori_hrad_c10_0');
 
 
 
 
 %%%%%%%%%%%%%%%%%%%%%%%%
 clear
tic();
addpath('./common/');
addpath('./svm/');
addpath('./svm/minFunc/');
addpath('./search/')
hog.numBins = 9;
hog.numHorizCells = 8;
hog.numVertCells = 16;
hog.cellSize = 8;
hog.winSize = [(hog.numVertCells * hog.cellSize + 2), ...
               (hog.numHorizCells * hog.cellSize + 2)];
                  
load('inria_no_hard_C10.mat')
hog.threshold = 0.1;
imgdir='G:\RAP-Detection\test_jpg\test_jpg';
testimgdir = dir(imgdir);
for num = 3 : 5length( testimgdir )
    filename=testimgdir(num).name;
    imgpath=fullfile(imgdir,filename);
    img=imread(imgpath);
    % tic();
     [resultRects,totalWindows] = searchImage(hog, img); 
    %resultRects are all the rectangulars which p = H * hog.theta>hog.threshold
    resultRectsrecord{1,num}=filename;
    resultRectsrecord{2,num}=resultRects;
     resultRectsrecord{3,num}=totalWindows;
   % elapsed = toc();
    fprintf('Finish %d th image in 17212 images',num-2);
   % fprintf('Image search took %.2f seconds\n', elapsed);
end
save('resultRectsrecord_RAP_inria_nohard_C10_0.1.mat','resultRectsrecord');
 elapsed = toc();
 fprintf('test took %.2f hours\n', elapsed/3600);
 