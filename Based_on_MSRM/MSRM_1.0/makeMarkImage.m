function makeMarkImage(markerPnts,imgHeight,imgWidth)

N=size(markerPnts,2);

for i=1:N-1
    x1=markerPnts(i,1); x2=markerPnts(i,2);
    y1=markerPnts(i+1,1);y2=markerPnts(i+1,2);
    Pnts=DDALine(x1,y1,x2,y2);     % 调用DDA画线生成直线上的所有点
    
end