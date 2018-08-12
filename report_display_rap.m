% this file is designed for the report and focus on the example to display
%clear

clc
close all
addpath('./graphics/');


%% show Rectans
%% 1
imgNum=20;
figure()
subplot(1,2,1);
res=load('resultRectsrecord_RAP_rapori_C10_hard_0.mat');
[imgname,resRectan,totalnum]=res.resultRectsrecord{:,imgNum+2};

img=imread(imgname);
imagesc(img);
title(imgname);
hold on
res_com = softnms(resRectan, 0.3,0.5,0.1,3);
for i=1:size(res_com,1)
    if(res_com(i,end)>0)
        drawRectangle(res_com(i, :), 'b');
    end
end

%% 2
imgNum=2000;
subplot(1,2,2);
res=load('resultRectsrecord_RAP_rapori_C10_hard_0.mat');
[imgname,resRectan,totalnum]=res.resultRectsrecord{:,imgNum+2};

img=imread(imgname);
imagesc(img);
title(imgname);
hold on
res_com = softnms(resRectan, 0.3,0.5,0.1,3);
for i=1:size(res_com,1)
    if(res_com(i,end)>0)
        drawRectangle(res_com(i, :), 'b');
    end
end

%% show hard example
hardexample= load('hardforRap.mat');

figure();
subplot(2,2,1);
hardNum=100;
hardexampleName=hardexample.hardexample(1,hardNum);
hardexampleRects=hardexample.hardexample(2:end,hardNum);

img=imread(hardexampleName{1});

imagesc(img);
title('Hard Example 1')
hold on
for i=1:size(hardexampleRects,1)
    if(~isempty(hardexampleRects{i}))
        drawRectangle(hardexampleRects{i}, 'r');
    else
        break;
    end
end

subplot(2,2,2);
hardNum=4;
hardexampleName=hardexample.hardexample(1,hardNum);
hardexampleRects=hardexample.hardexample(2:end,hardNum);

img=imread(hardexampleName{1});
imagesc(img);
title('Hard Example 2')
hold on
for i=1:size(hardexampleRects,1)
    if(~isempty(hardexampleRects{i}))
        drawRectangle(hardexampleRects{i}, 'r');
    else
        break;
    end
end

subplot(2,2,3);
hardNum=69;
hardexampleName=hardexample.hardexample(1,hardNum);
hardexampleRects=hardexample.hardexample(2:end,hardNum);

img=imread(hardexampleName{1});
imagesc(img);
title('Hard Example 3')
hold on
for i=1:size(hardexampleRects,1)
    if(~isempty(hardexampleRects{i}))
        drawRectangle(hardexampleRects{i}, 'r');
    else
        break;
    end
end

subplot(2,2,4);
hardNum=15;
hardexampleName=hardexample.hardexample(1,hardNum);
hardexampleRects=hardexample.hardexample(2:end,hardNum);

img=imread(hardexampleName{1});
imagesc(img);
title('Hard Example 4')
hold on
for i=1:size(hardexampleRects,1)
    if(~isempty(hardexampleRects{i}))
        drawRectangle(hardexampleRects{i}, 'r');
    else
        break;
    end
end