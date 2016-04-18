function maxIndex=MaxSimIndex(index,SimTable,regionNum)

maxSim=-1;
for i=1:regionNum
    if i~=index                 % 
        sim=SimTable(i,index);  % 
        if maxSim<sim           % 
            maxSim=sim;         % 
            maxIndex=i;
        end
    end
end