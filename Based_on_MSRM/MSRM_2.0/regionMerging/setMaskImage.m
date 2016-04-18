function markerImage=setMaskImage(markerImage,imMask,isObjectMarker,isBackgroundMarker)
index=find(imMask==1);
if isObjectMarker==1
    markerImage(index)=2;         % 
elseif isBackgroundMarker==1
    markerImage(index)=1;         % 
end