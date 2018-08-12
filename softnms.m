function bbs = softnms(recTan, overlap,sigma,threshold,method)
%%boxesΪһ��m*n�ľ�������mΪboundingbox�ĸ�����n��ǰ4��Ϊÿ��boundingbox�����꣬��ʽΪ
%%��x1,y1,x2,y2������5��Ϊ���Ŷȡ�overlapΪ�趨ֵ��0.3,0.5 .....
%methodֵΪ1�����ԣ�2����˹��Ȩ��3����ͳNMS
boxes=recTan;
if(isempty(boxes)==1)
    bbs=[];
else
    boxes(:,3)=recTan(:,1)+recTan(:,3);
    boxes(:,4)=recTan(:,2)+recTan(:,4);

    if (nargin<3)
        sigma=0.5;
        %Nt=0.8;
        threshold=0.001;
        method=2;
    end
    N=size(boxes,1);

    x1 = boxes(:,1);%����boundingbox��x1����
    y1 = boxes(:,2);%����boundingbox��y1����
    x2 = boxes(:,3);%����boundingbox��x2����
    y2 = boxes(:,4);%����boundingbox��y2����
    area = (x2-x1) .* (y2-y1); %ÿ��%����boundingbox�����

    for ib=1:N
        tBD=boxes(ib,:);
        tscore=tBD(5);
        pos=ib+1;

        [maxscore,maxpos]=max(boxes(pos:end,5));
        if tscore<maxscore
            %maxscore=score;
            boxes(ib,:)=boxes(maxpos+ib,:);
            boxes(maxpos+ib,:)=tBD;
            tBD=boxes(ib,:);
            tempAera=area(ib);
            area(ib)=area(maxpos+ib);
            area(maxpos+ib)=tempAera;
        end

        xx1=max(tBD(1),boxes(pos:end,1));
        yy1=max(tBD(2),boxes(pos:end,2));
        xx2=min(tBD(3),boxes(pos:end,3));
        yy2=min(tBD(4),boxes(pos:end,4));

        tarea=area(ib);
        w = max(0.0, xx2-xx1);
        h = max(0.0, yy2-yy1);

        inter = w.*h;
        o = inter ./ (tarea + area(pos:end) - inter);%����÷���ߵ��Ǹ�boundingbox�������boundingbox�Ľ������

        if method==1    %linear
            weight=ones(size(o));
            weight(o>overlap)=1-o;
        end
        if method==2    %guassian
            weight=exp((-o.*o)./sigma);
        end
        if method==3   %original NMS
            weight=ones(size(o));
            weight(o>overlap)=0;
        end
        boxes(pos:end,5)=boxes(pos:end,5).*weight;
    end
    %bbs=boxes(boxes(:,5)>threshold,:);
    maximum=min(15000,size(boxes,1));
    bbs=boxes(1:maximum,:);
    bbs(:,3)=bbs(:,3)-bbs(:,1);
    bbs(:,4)=bbs(:,4)-bbs(:,2);
end
end