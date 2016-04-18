function newRecord=MergeRecord(record,index1,index2,regionNum)

newRecord=record;                 % 
% 1.
if record(index1)==-1 & record(index2)==-1
    newRecord(index1)=-2;         % 
    newRecord(index2)=index1;    %
% 2.
elseif record(index1)==-1 & record(index2)==-2
    newRecord(index1)=-2;         % 
    newRecord(index2)=index1;     % 
    for i=1:regionNum             % 
        if record(i)==index2;
            newRecord(i)=index1;  %;
        end
    end
% 3.
elseif record(index1)==-1 & record(index2)>0
    rootNode=record(index2);      % 
    if index1>rootNode            % 
       newRecord(index1)=rootNode;% 
    elseif index1<rootNode        % 
        newRecord(index1)=-2;     % 
        newRecord(rootNode)=index1; % 
        for i=1:regionNum           %      
            if record(i)==rootNode  % 
                newRecord(i)=index1;% 
            end
        end
    end
% 4.
elseif record(index1)==-2 & record(index2)==-1
    newRecord(index2)=index1;          % 
% 5.
elseif record(index1)==-2 & record(index2)==-2
    newRecord(index2)=index1;          % 
    for i=1:regionNum
        if record(i)==index2           % 
            newRecord(i)=index1;
        end
    end
% 6.
elseif record(index1)==-2 & record(index2)>0
    rootNode=record(index2);           % 
    if index1<rootNode                 % 
        newRecord(rootNode)=index1;    % 
        for i=1:regionNum 
            if record(i)==rootNode     % 
                newRecord(i)=index1;
            end
        end
    elseif index1>rootNode;            % 
        newRecord(index1)=rootNode;    % 
        for i=1:regionNum              % 
            if record(i)==index1;      % 
                newRecord(i)=rootNode;
            end
        end
    end

%7. 
elseif record(index1)>0 & record(index2)==-2
    rootNode=record(index1);           % 
    newRecord(index2)=rootNode;        % 
    for i=1:regionNum
        if record(i)==index2           % 
            newRecord(i)=rootNode;     % 
        end
    end
%8. 
elseif record(index1)>0 & record(index2)==-1
    rootNode=record(index1);           % 
    newRecord(index2)=rootNode;        % 
%9. 
elseif record(index1)>0 & record(index2)>0
    rootNode1=record(index1);
    rootNode2=record(index2);
    if rootNode1>rootNode2             % 
        newRecord(rootNode1)=rootNode2;% 
        for i=1:regionNum         
            if record(i)==rootNode1    % 
                newRecord(i)=rootNode2;
            end
        end
    elseif rootNode1<rootNode2         %
        newRecord(rootNode2)=rootNode1;% 
        for i=1:regionNum              
            if record(i)==rootNode2    % 
                newRecord(i)=rootNode1;% 
            end
        end
    end
end