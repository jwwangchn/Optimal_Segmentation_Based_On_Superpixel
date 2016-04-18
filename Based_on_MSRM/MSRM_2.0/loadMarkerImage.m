function markerImage=loadImageMarker(filename)

Im=imread(filename);
height=size(Im,1);
width=size(Im,2);
markerImage=zeros(height,width);
for i=1:height
    for j=1:width
        if Im(i,j,2)==255
            markerImage(i,j)=2;
        end
        if Im(i,j,3)==255
            markerImage(i,j)=1;
        end
    end
end