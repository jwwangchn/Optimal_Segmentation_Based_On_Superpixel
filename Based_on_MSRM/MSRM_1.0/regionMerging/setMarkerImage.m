function Image=setMarkerImage(Image,imMask)

Height=size(Image,1);
Width=size(Image,2);
imMask2=imMask~=0;
Se=strel('disk',3);
imMask2=imMask2-imerode(imMask2,Se);
[indy,indx]=find(imMask);
N=size(indy,1);

for i=1:N
    row=indy(i);
    col=indx(i);
    if imMask(row,col)==1 & imMask2(row,col)==1    % 1 
        Image(row,col,:)=0;
        Image(row,col,1)=255; 
    elseif imMask(row,col)==2 & imMask2(row,col)==1 % 2 
        Image(row,col,:)=0;
        Image(row,col,2)=255;
    end
end