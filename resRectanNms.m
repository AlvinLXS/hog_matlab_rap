% this file transform the original record to be processed by nms
res=load('resultRectsrecord_RAP_rapori_C10_hard_0.mat');
for n=1:size(res.resultRectsrecord,2)-2
    imgNum=n;
    [imgname,resRectan,totalnum]=res.resultRectsrecord{:,imgNum+2};
    resRectanNmstemp=softnms(resRectan,0.5,0.5,0.1,3);
    resRectanNms=[];
    for i=1:size(resRectanNmstemp,1)
        if(resRectanNmstemp(i,5)==0)
            break
        else
            resRectanNms=[resRectanNms;resRectanNmstemp(i,:)];
        end
    end
    recRect(n).name=imgname;
    recRect(n).bbx=resRectanNms;
end
save('resRectanNms.mat','recRect')


