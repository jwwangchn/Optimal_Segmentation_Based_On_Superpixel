function [I2,newRegionNum,Region2]=MergePostProc2(I,record,N,Region)

I2=zeros(size(I,1),size(I,2));    % 
k=0;
for i=1:N
    % 1. 
    if record(i)==-1
        k=k+1; 
        ind=find(I==i);           % 
        I2(ind)=k;                % 
        
        %
        Region2(k).rgbHistogram=Region(i).rgbHistogram;
        Region2(k).markerType=Region(i).markerType;
        Region2(k).area=Region(i).area;

    elseif record(i)==-2        % 
        k=k+1;
        ind=find(I==i);         % 
        
        I2(ind)=k;              % 
        
        % 
        Region2(k).rgbHistogram=Region(i).rgbHistogram;
        Region2(k).markerType=Region(i).markerType;
        Region2(k).area=Region(i).area;
        
        for j=1:N               % 
            if record(j)==i     % 
                ind=find(I==j);
                I2(ind)=k;
                
                % 
                Region2(k).rgbHistogram=Region2(k).rgbHistogram+Region(j).rgbHistogram;
                Region2(k).markerType=max(Region2(k).markerType,Region(j).markerType);        %
                Region2(k).area=Region2(k).area+Region(j).area;                
            end
        end
    end
    
end
newRegionNum=k;
        
    
