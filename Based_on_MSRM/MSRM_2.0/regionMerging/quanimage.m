function indImage=quanimage(image,redBins,greenBins,blueBins)

image=double(image);     % 

M=size(image,1);
N=size(image,2);
indImage=size(M,N);      % 

red=256/redBins;         % 
green=256/greenBins;
blue=256/blueBins;

for y=1:M
    for x=1:N
        i=floor(image(y,x,1)/red)+1;
        j=floor(image(y,x,2)/green)+1;
        k=floor(image(y,x,3)/blue)+1;        
        index=red*green*(i-1)+green*(j-1)+k;  % 
        indImage(y,x)=index;
    end
end