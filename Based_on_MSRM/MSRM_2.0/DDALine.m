function Pnts=DDALine(x1,y1,x2,y2)

deltX=x1-x2;                
deltY=y1-y2;

if deltX==0                      % 如果直线是垂线
    if y1>y2
        t=y1;y1=y2;y2=t;
    end
    for i=y1:y2
        Pnts(1,i-y1+1)=x1;
        Pnts(2,i-y1+1)=i;
    end
    return;
end

if deltY==0                      % 如果直线是水平线
    if x1>x2
        t=x1;x1=x2;x2=t;
    end
    for i=x1:x2
        Pnts(1,i-x1+1)=i;
        Pnts(2,i-x1+1)=y1;
    end
    return;
end

k=deltY/deltX;                   % 直线既不是水平线也不是垂直线
if abs(k)<=1                     % 如果直线的斜率小于1
    if x1>x2
        t=x1;x1=x2;x2=t;
        t=y1;y1=y2;y2=t;
    end
    for i=x1:x2
        Pnts(1,i-x1+1)=i;
        Pnts(2,i-x1+1)=round(y1+(i-x1)*k);
    end        
elseif abs(k)>1
    if y1>y2
        t=x1;x1=x2;x2=t;
        t=y1;y1=y2;y2=t;
    end
    for i=y1:y2
        Pnts(1,i-y1+1)=round(x1+(i-y1)/k);
        Pnts(2,i-y1+1)=i;
    end           
end