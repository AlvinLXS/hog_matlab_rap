%% this demo program to test one picture which is chosen from the test set
clear
tic();
addpath('./common/');
addpath('./svm/');
addpath('./svm/minFunc/');
addpath('./search/')
addpath('./graphics/')
hog.numBins = 9;
hog.numHorizCells = 8;
hog.numVertCells = 16;
hog.cellSize = 8;
hog.winSize = [(hog.numVertCells * hog.cellSize + 2), ...
               (hog.numHorizCells * hog.cellSize + 2)];
              
%% choose model,threshold  to run the demo program
 %=============================================================          
load('rap_ori_C10_hard.mat');
hog.threshold = 0;
 %=============================================================
 %%
img=imread('CAM01-2014-02-15-20140215161032-20140215162620-frame6614.jpg');
 tic();

 [resultRects,totalWindows] = searchImage(hog, img); 
elapsed = toc();
fprintf('Searching this image took about %.2f seconds',elapsed);

imagesc(img);
hold on
res_com = softnms(resultRects, 0.2,0.5,0.1,3);
for i=1:size(res_com,1)
    if(res_com(i,end)>0)
        drawRectangle(res_com(i, :), 'b');
    end
end


