function res_com = OverlapCom(inRect, thresh)
    len=size(inRect,1);
    inRect=[inRect,ones(len,1)];
    i=1;
    while(i<=len-1)
        if(inRect(i,end)==0)
            i=i+1;
        else
            a1x = inRect(i, 1);
            a1y = inRect(i, 2);
            a2x = a1x + inRect(i, 3);
            a2y = a1y + inRect(i, 4);
            aArea = inRect(i, 3) * inRect(i, 4);
                        for j=i+1:len
                                    b1x = inRect(j, 1);
                                    b1y = inRect(j, 2);
                                    b2x = b1x + inRect(j, 3);
                                    b2y = b1y + inRect(j, 4);
                                    bArea = inRect(i, 3) * inRect(i, 4);

                                    x_overlap = max(0, min(a2x, b2x) - max(a1x, b1x));
                                    y_overlap = max(0, min(a2y, b2y) - max(a1y, b1y));
                                    intersectArea = x_overlap * y_overlap;
                                    unionArea = aArea + bArea - intersectArea;
                                    if ((intersectArea / unionArea) > thresh)
                                                if(inRect(i,5)>inRect(j,5))
                                                    %inRect(i,end)=1;
                                                    inRect(j,end)=0;
                                                else
                                                    inRect(i,end)=0;
                                                    %compRects(j,end)=1;
                                                end
                                    else
                                        %inRect(i,end)=1;
                                        inRect(j,end)=1;
                                    end		
                        end
            i=i+1;
        end
    res_com=inRect;
end