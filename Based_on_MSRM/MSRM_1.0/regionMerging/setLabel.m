function Label=setLabel(segImage)
imBW=im2bw(segImage);                          %
Label=bwlabel(imBW);                           %         
[H,W]=size(Label);                             % 
while 1                                        % 
    Label=fillAllZero(Label,H,W);
    if isempty(find(Label==0))==1;
        break;
    end
end