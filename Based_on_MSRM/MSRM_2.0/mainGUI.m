function mainGUI(action,varargin)      
% interface of the software
% Author  ：Jifeng Ning，Lei Zhang, David Zhang, Chengke Wu               *
% Date    : 15th,June,2009                                                *
% Address ：Department of Computing, Biometric Research Center,           *
%           Hongkong polytechnic university                               *
%           Xidian Univeristy                                             *
%           College of information, Northwest A&F University              *
%                                                                         *
%  Copyright (c) 2009 by Jifeng Ning, Lei Zhang, David Zhang, Chengke Wu  *
%  last update: 10th,July,2010                                            % 
% *************************************************************************
if nargin<1                            % If initilize the interface
    action='InitializeMSRMFig';          
end;
feval(action,varargin{:});             % call function
return;

function InitializeMSRMFig()
global figHandle;
callbackStr1='mainGUI(''mouseDown'');';
callbackStr2='mainGUI(''MouseMotion'');';
callbackStr3='mainGUI(''MouseUp'');';
figHandle=figure(...
    'Name','Maximal Similarity Based Region Merging Demo (Ver2.0)',...
    'NumberTitle','off',...
    'HandleVisibility','on',...
    'tag','Object Tracking',...
    'Visible','on',...
    'Resize','off',...
    'BusyAction','Queue',...
    'Interruptible','off',...
    'IntegerHandle','off',...
    'WindowButtonDownFcn',callbackStr1,...
    'WindowButtonMotionFcn',callbackStr2,...    
    'WindowButtonUpFcn',callbackStr3,...   
    'doublebuffer','on');

% put the window in the center of screen
figPos(3:4)=[1000,700];
set(0,'Units','Pixels');
screenSize=get(0,'ScreenSize');
figPos(1)=(screenSize(3)-figPos(3))*0.5;
figPos(2)=(screenSize(4)-figPos(4))*0.5;
row=figPos(4);col=figPos(3); 
set(figHandle,'position',figPos);

hdl.figHandle_Axes1=axes('Parent',figHandle,...
    'Units','Pixels',...
    'Interruptible','off',...
    'ydir','reverse',...
    'xlim',[.5 256.5],...
    'ylim',[.5 256.5],...
    'XTick',[],...
    'YTick',[],...
    'Position',[20,310 400 400],...   
    'Visible','on');

hdl.originalImage=image('Parent',hdl.figHandle_Axes1,...    
    'CDATA',[],...
    'Interruptible','off',...
    'CDataMapping','scaled',...
    'EraseMode','normal');

hdl.figHandle_Axes2=axes('Parent',figHandle,...
   'Units','Pixels',...
    'Interruptible','off',...
    'ydir','reverse',...
    'xlim',[.5 256.5],...
    'ylim',[.5 256.5],...
    'XTick',[],...
    'YTick',[],...
    'Position',[325,310 450 500],...    
    'Visible','off');
% 
hdl.segImage=image('Parent',hdl.figHandle_Axes2,...    
    'CDATA',[],...
    'Interruptible','off',...
    'CDataMapping','scaled',...
    'EraseMode','normal');

left=0.05; % 
top=0.15;   % 
figBackColor=get(figHandle,'color');

controlWidth=0.18;     % the width of the control
controlHeight=0.05;  % the height of the control

btnNumber=1;
labelPos=[left top controlWidth controlHeight-0.005];
callbackStr='mainGUI(''LoadNewAVIFile'');';
hdl.btn_OpenImage=uicontrol('Parent',figHandle,...
    'Style','pushbutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Open an image',...
    'FontSize',8,...
    'Interruptible','off',...
    'Callback',callbackStr);

btnNumber=2;
labelPos=[left top-controlHeight controlWidth controlHeight-0.005];
callbackStr='mainGUI(''exitGUI'');';
hdl.btn_ExitGUI=uicontrol('Parent',figHandle,...
    'Style','pushbutton',... 
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Exit program',...
    'FontSize',8,...
    'Interruptible','off',...
    'backgroundcolor',figBackColor,...    
    'Callback',callbackStr);

btnNumber=3;
labelPos=[left+controlWidth+0.02 top controlWidth controlHeight];
callbackStr='mainGUI(''setMarker'',1);';
hdl.btn_FgMarker=uicontrol('Parent',figHandle,...
    'Style','radiobutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Set object marker',...
    'FontSize',8,...
    'Interruptible','off',...
    'backgroundcolor',figBackColor,...    
    'Callback',callbackStr);

btnNumber=4;
labelPos=[left+controlWidth+0.02 top-controlHeight controlWidth controlHeight];
callbackStr='mainGUI(''setMarker'',2);';
hdl.btn_BgMarker=uicontrol('Parent',figHandle,...
    'Style','radiobutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Set background marker',...
    'FontSize',8,...
    'Interruptible','off',...
    'backgroundcolor',figBackColor,...    
    'Callback',callbackStr);

btnNumber=5;
labelPos=[left+controlWidth+0.02 top-2*controlHeight controlWidth controlHeight];
callbackStr='mainGUI(''defaultBackgruondMarker'');';
hdl.btn_DefBgMarker=uicontrol('Parent',figHandle,...
    'Style','checkbox',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Auto background marker',...
    'FontSize',8,...
    'Interruptible','off',...
    'backgroundcolor',figBackColor,...    
    'Callback',callbackStr);

btnNumber=6;
labelPos=[left+2*controlWidth+0.04 top controlWidth controlHeight-0.005];
callbackStr='mainGUI(''loadMarker'');';
hdl.btn_LoadMarker=uicontrol('Parent',figHandle,...
    'Style','pushbutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Load marker',...
    'FontSize',8,...
    'Interruptible','off',...
    'backgroundcolor',figBackColor,...    
    'Callback',callbackStr);

btnNumber=7;
labelPos=[left+2*controlWidth+0.04 top-controlHeight controlWidth controlHeight-0.005];
callbackStr='mainGUI(''saveMarker'');';
hdl.btn_SaveMarker=uicontrol('Parent',figHandle,...
    'Style','pushbutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Save marker',...
    'FontSize',8,...
    'Interruptible','off',...
    'backgroundcolor',figBackColor,...    
    'Callback',callbackStr);

btnNumber=8;
labelPos=[left+2*controlWidth+0.04 top-2*controlHeight controlWidth controlHeight-0.005];
callbackStr='mainGUI(''reInitilizateMarker'');';
hdl.btn_ReInitMarker=uicontrol('Parent',figHandle,...
    'Style','pushbutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Reinitialize marker',...
    'FontSize',8,...
    'Interruptible','off',...
    'backgroundcolor',figBackColor,...    
    'Callback',callbackStr);

btnNumber=9;
% [left+2*controlWidth+0.04 top controlWidth controlHeight-0.005];
labelPos=[left+3*controlWidth+0.06 top controlWidth+0.08 controlHeight-0.005];
callbackStr='mainGUI(''MSRM_Segment'');';
hdl.btn_Lambda=uicontrol('Parent',figHandle,...
    'Style','pushbutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Maximal Similarity Based Region Merging',...
    'FontSize',8,...
    'backgroundcolor',figBackColor,...
    'Callback',callbackStr,...
    'Interruptible','off');

btnNumber=10;
% [left+2*controlWidth+0.04 top controlWidth controlHeight-0.005];
labelPos=[left+3*controlWidth+0.06 top-controlHeight controlWidth+0.08 controlHeight-0.005];
callbackStr='mainGUI(''SaveSegmentationResult'');';
hdl.btn_Lambda=uicontrol('Parent',figHandle,...
    'Style','pushbutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Save segmentation result',...
    'FontSize',8,...
    'backgroundcolor',figBackColor,...
    'Callback',callbackStr,...
    'Interruptible','off');

set(figHandle,'Userdata',hdl,'visible','on'); % save figure handle
LoadNewAVIFile(figHandle);

% 载入新的文件
function LoadNewAVIFile(figHandle)

global orgImage;
global iniSegImage;
global bwMarkerImage;
global Label;
global orgEdgeImage
global imgHeight;             
global imgWidth;
global filename0;             % orginal filename
global filepath0;             % filepath for filename

if nargin==1
    isInit=1;
else    
    isInit=0;
    figHandle=gcf;    
end

if isInit                                     % Initilize
    filename='bird.bmp';                      % Load the default image
    filepath='./testImages/'; 
    
    filename0=filename;
    filepath0=filepath;
else                                          % Load a new image
    cd('.\testimages');
    [filename filepath]=uigetfile('*.bmp','Load an image');
    cd('..');
    filename0=filename;
    filepath0=filepath;
    if filename==0
        return;
    end
end

hdl=get(figHandle,'userdata');% 
% For an image, height and width shoule be less than 600 and 500,respectively
orgImage=imread([filepath,filename]);
% load the initial segmentation of the orginal image
iniSegImage=imread([filepath filename(1:end-4) '_IniSeg' '.png']);
imgHeight=size(orgImage,1);
imgWidth=size(orgImage,2);

% initialize the marker image with foreground and background
bwMarkerImage=zeros(imgHeight,imgWidth);

if imgHeight>500 || imgWidth>600
    msgbox('Size of the image is too big!');
    exit
end

figPosition=get(gcf,'position');        
orgImgPosition=[50,figPosition(4)-imgHeight-50, imgWidth,imgHeight];

% conver the iniSegImage into the labelled image to next region merging
Label=setLabel(iniSegImage);              

orgEdgeImage=drawedge(orgImage,Label); % 

set(hdl.figHandle_Axes1,'xlim',[.5, imgWidth+.5],'ylim',[.5 imgHeight+.5],'position',orgImgPosition);
set(get(hdl.figHandle_Axes1, 'Title'), 'String', 'Initial segmentation','visible','on');
set(hdl.segImage, 'XData',[1 imgWidth],'YData',[1 imgHeight],'CData',orgImage);drawnow;

segImgPosition=[imgWidth+50+50,figPosition(4)-imgHeight-50, imgWidth,imgHeight];
set(hdl.figHandle_Axes2,'xlim',[.5, imgWidth+.5],'ylim',[.5 imgHeight+.5],'position',segImgPosition,'visible','on');
set(get(hdl.figHandle_Axes2, 'Title'), 'String', 'Original image','visible','on');
set(hdl.originalImage, 'XData',[1 imgWidth],'YData',[1 imgHeight],'Cdata',orgEdgeImage);drawnow;
set(figHandle,'userData',hdl);

% Set foreground and background marker
function setMarker(mode)
global figHandle;
global isObjectMarker;
global isBackgroundMarker;
hdl=get(figHandle,'userdata');
isObjectMarker=0;
isBackgroundMarker=0;

% initialize the foreground and background value
set([hdl.btn_FgMarker,hdl.btn_BgMarker],'value',0);

if mode==1
    isObjectMarker=1;
    set(hdl.btn_FgMarker,'value',1);
elseif mode==2
    isBackgroundMarker=1;
    set(hdl.btn_BgMarker,'value',1);   
end
set(figHandle,'Userdata',hdl); 

% OnMouseDown
function mouseDown()
global figHandle;
global isObjectMarker;
global isBackgroundMarker;
global markerPnts;
global mouseValid;
global lineHandle;

markerPnts=[];
linePnts=[];
s=get(gcf,'SelectionType');
if isObjectMarker==0 && isBackgroundMarker==0
    return;
end
if s=='normal'
     hdl=get(figHandle,'UserData');
     if hdl.figHandle_Axes1~=gca 
        return;
     end
     pt=get(hdl.figHandle_Axes1,'CurrentPoint'); % get current position
     pt=pt(1,1:2); 
     markerPnts(1,1)=pt(1);
     markerPnts(2,1)=pt(2);
     mouseValid=1;
     setptr(gcf,'fleur');     % 
     set(figHandle,'userData',hdl);
end

% on move mouse
function MouseMotion()

global figHandle;
global bwMarkerImage;
global isObjectMarker;
global isBackgroundMarker;
global orgImage;
global iniSegImage;
global orgEdgeImage;
global markerPnts;
global imgHeight;             
global imgWidth;
global mouseValid;
global imgHeight;             
global imgWidth;

if mouseValid==0
    return;
end
hdl=get(figHandle,'UserData');

if hdl.figHandle_Axes1~=gca
    return;
end
tempImage=zeros(size(bwMarkerImage));
pt=get(hdl.figHandle_Axes1,'CurrentPoint'); % get current position of mouse
pt=pt(1,1:2);                               % 
if pt(1)>=1 & pt(1)<=imgWidth & pt(2)>=1 & pt(2)<=imgHeight   % is posiotin out?
    m=size(markerPnts,2);
    markerPnts(1,m+1)=pt(1);
    markerPnts(2,m+1)=pt(2);

    Pnts=DDALine(markerPnts(1,m),markerPnts(2,m),markerPnts(1,m+1),markerPnts(2,m+1));
    n=size(Pnts,2);
    for j=1:n
        col=floor(Pnts(1,j));
        row=floor(Pnts(2,j));
        tempImage(row,col)=1;
    end
    SE=strel('disk',2);
    tempImage=imdilate(tempImage,SE);
    Ind=find(tempImage);
    if isObjectMarker==1
        bwMarkerImage(Ind)=2;
    else
        bwMarkerImage(Ind)=1;
    end
    ImageAndMarker=setMarkerImage(orgEdgeImage,bwMarkerImage);
    set(hdl.originalImage,'CData',ImageAndMarker);  drawnow; 
end
   
% on mouse up
function MouseUp()
global mouseValid;
setptr(gcf,'arrow');
mouseValid=0;
return;

% set default background marker
function defaultBackgruondMarker()
global figHandle              
global bwMarkerImage
global orgEdgeImage
global imgHeight;
global imgWidth;

hdl=get(figHandle,'Userdata'); % 
value=get(hdl.btn_DefBgMarker,'value');
bwMarkerImage(:,[1:3,imgWidth-2:imgWidth])=value;
bwMarkerImage([1:3,imgHeight-2:imgHeight],:)=value;
ImageAndMarker=setMarkerImage(orgEdgeImage,bwMarkerImage); 
set(hdl.originalImage,'CData',ImageAndMarker);  drawnow;

% Reinitialize marker
function reInitilizateMarker()
global figHandle; 
global bwMarkerImage;
global orgEdgeImage;
global imgHeight;
global imgWidth;
global lineHandle;
bwMarkerImage=zeros(imgHeight,imgWidth);
hdl=get(figHandle,'Userdata');
set(lineHandle,'visible','off');
lindHandle=[];
set(hdl.btn_ReInitMarker,'value',0);     % 
set(hdl.originalImage,'CData',orgEdgeImage,'EraseMode','none');  drawnow;
set(figHandle,'userData',hdl);

% Segment image by proposed maximal similarity based region region
function MSRM_Segment()

global figHandle; 
global orgImage;
global Label;
global bwMarkerImage;
global iniSegImage;              % segmentation result of the image

maxSimRegionMerging();

% load the existing marker image with foregrond and background
function loadMarker()
global figHandle;
global bwMarkerImage;
global orgEdgeImage;
hdl=get(figHandle,'Userdata');
cd('.\markerImage');
[filename filepath]=uigetfile('*.bmp','Load an image');
cd('..');
if filename==0
    return;
end
bwMarkerImage=loadMarkerImage([filepath,filename]);
ImageAndMarker=setMarkerImage(orgEdgeImage,double(bwMarkerImage(:,:,1))); 
set(hdl.originalImage,'CData',ImageAndMarker,'EraseMode','none');  drawnow;

% save current marker image with foreground and background
function saveMarker()
global bwMarkerImage;
global orgEdgeImage;
global imgHeight;
global imgWidth;
global filename0;             % orginal filename

cd('.\markerImage');
markerFilename=[filename0(1:end-4),'_marker','.bmp'];
[filename filepath]=uiputfile(markerFilename,'Save current foreground and background marker');
cd('..');
if filename(1)
    ImageAddMarker=setMarkerImage(orgEdgeImage,bwMarkerImage);
    colorMarkerImage=zeros(imgHeight,imgWidth,3);
    for i=1:imgHeight
        for j=1:imgWidth
            if bwMarkerImage(i,j)==1
                colorMarkerImage(i,j,3)=255;
            end
            if bwMarkerImage(i,j)==2
                colorMarkerImage(i,j,2)=255;
            end
        end
    end
    imwrite(uint8(colorMarkerImage),[filepath,filename]);
    imwrite(ImageAddMarker,[filepath,filename(1:end-4),'ImageAddMarker','.bmp']);    
end

% save segmentation result
function SaveSegmentationResult()
global bwSegmentResultImage;
global filename0;             % orginal filename
cd('.\segmentation results\');
segResultFilename=[filename0(1:end-4),'_segmentationResult','.bmp'];
[filename filepath]=uiputfile(segResultFilename,'Save segmentation result');
if filename(1) & ~isempty(bwSegmentResultImage)    
    imwrite(bwSegmentResultImage,[filepath,filename]);
end
cd('..');
return;


% exit program
function exitGUI()
global figHandle
close(figHandle);