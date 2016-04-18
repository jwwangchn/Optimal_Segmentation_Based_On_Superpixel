function SimTable=CompSim(I,height,width,Region)

RegionNum=max(I(:));                  % 
SimTable=zeros(RegionNum,RegionNum);  % 

for i=1:height
    for j=1:width
        index=I(i,j);                 % 
        SimTable(index,index)=1;      % 
        for k=-1:1                    % 
            for l=-1:1                % 
                row=i+k;              % 
                col=j+l;
                if (row>0 & row<=height & col>0 & col<=width)
                    if index~=I(row,col)
                        SimTable(index,I(row,col))=1;
                    end
                end
            end
        end
    end
end

for i=1:RegionNum
    for j=1:RegionNum
        if i~=j & SimTable(i,j)>0    % 
            H1=sqrt(Region(i).rgbHistogram/Region(i).area);
            H2=sqrt(Region(j).rgbHistogram/Region(j).area);            
            SimTable(i,j)=H1*H2'+0.000001;   % 
        end
    end
end