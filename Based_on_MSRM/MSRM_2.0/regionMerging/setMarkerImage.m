function Image=setMarkerImage(Image,imMask)
% Image: original image
% imMask: Mask

[indy,indx]=find(imMask);               
N=size(indy,1);                         

for i=1:N
    row=indy(i);
    col=indx(i);
    if imMask(row,col)==1 
        Image(row,col,:)=0;
        Image(row,col,3)=255; 
    elseif imMask(row,col)==2
        Image(row,col,:)=0;
        Image(row,col,2)=255;
    end
end