function Region=InitRegion(I,indImage,Mask,height,width)
% initialize region information and calcluate the area, markerType and
% rgbHistogram

RegionNum=max(I(:));            
for i=1:RegionNum                
    Region(i).area=0;
    Region(i).markerType=0;      
    Region(i).rgbHistogram=zeros(1,max(indImage(:)));
end

for i=1:height
    for j=1:width
        index=I(i,j);            
        Region(index).area=Region(index).area+1;  
        % 
        Region(index).rgbHistogram(1,indImage(i,j))=Region(index).rgbHistogram(1,indImage(i,j))+1;        
        % 
        Region(index).markerType=max(Region(index).markerType,Mask(i,j));        
    end
end


