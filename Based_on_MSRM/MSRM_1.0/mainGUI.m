function mainGUI(action,varargin)      
% interface of the software
% Author     Jifeng Ning, Lei Zhang, David Zhang, Chengke Wu              *
% Date    : 15th,June,2009                                                *
% Address   Department of Computing                                       *
%           Hongkong Polytechnic University                               *
%           Xidian Univeristy                                             *
%           College of information, Northwest A&F University              *
%                                                                         *
%  Copyright (c) 2009 by Jifeng Ning, Lei Zhang, David Zhang, Chengke Wu  *
% *************************************************************************
if nargin<1                            % If initilize the interface
    action='InitializeOTFig';          
end;
feval(action,varargin{:});
return;

function InitializeOTFig()
global figHandle;
callbackStr1='mainGUI(''mouseDown'');';
callbackStr2='mainGUI(''MouseMotion'');';
callbackStr3='mainGUI(''MouseUp'');';
figHandle=figure(...
    'Name','Interactive Image Segmentation by Maximal Similarity Based Region Merging',...
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
top=0.1;   % 

controlWidth=0.20;     % the width of the control
controlHeight=0.0533;  % the height of the control

btnNumber=1;
labelPos=[left top controlWidth controlHeight];
callbackStr='mainGUI(''LoadNewAVIFile'');';
hdl.btn1=uicontrol('Parent',figHandle,...
    'Style','pushbutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Open an image',...
    'FontSize',12,...
    'Interruptible','off',...
    'Callback',callbackStr);

btnNumber=2;
labelPos=[left+controlWidth+0.02 top controlWidth controlHeight];
callbackStr='mainGUI(''setMarker'',1);';
hdl.btn2=uicontrol('Parent',figHandle,...
    'Style','radiobutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Set object marker',...
    'FontSize',12,...
    'Interruptible','off',...
    'Callback',callbackStr);

btnNumber=3;
labelPos=[left+controlWidth+0.02 top-controlHeight-0.02 controlWidth controlHeight];
callbackStr='mainGUI(''setMarker'',2);';
hdl.btn3=uicontrol('Parent',figHandle,...
    'Style','radiobutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Set background marker',...
    'FontSize',12,...
    'Interruptible','off',...
    'Callback',callbackStr);

btnNumber=4;
labelPos=[left+controlWidth+controlWidth+0.04 top controlWidth controlHeight];
callbackStr='mainGUI(''reInitilizateMarker'');';
hdl.btn4=uicontrol('Parent',figHandle,...
    'Style','pushbutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Initilize Marker',...
    'FontSize',12,...
    'Interruptible','off',...
    'Callback',callbackStr);

btnNumber=5;
labelPos=[left+3*controlWidth+0.06 top controlWidth controlHeight];
callbackStr='mainGUI(''interactiveRegionProcessing'');';
hdl.btn5=uicontrol('Parent',figHandle,...
    'Style','pushbutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Interactive region merging',...
    'FontSize',12,...
    'Interruptible','off',...
    'Callback',callbackStr);

btnNumber=6;
labelPos=[left+3*controlWidth+0.06 top-controlHeight-0.02 controlWidth controlHeight];
callbackStr='mainGUI(''exitGUI'');';
hdl.btn6=uicontrol('Parent',figHandle,...
    'Style','pushbutton',...
    'Units','normalized',...
    'Position',labelPos,...
    'Horiz','left',...
    'String','Exit',...
    'FontSize',12,...
    'Interruptible','off',...
    'Callback',callbackStr);

set(figHandle,'Userdata',hdl,'visible','on'); % save figure handle
LoadNewAVIFile(figHandle);

function LoadNewAVIFile(figHandle)

if nargin==1
    isInit=1;
else    
    isInit=0;
    figHandle=gcf;    
end

if isInit                                     % Initilize
    filename='bird.bmp';                      % Load the default image
    filepath='./testImages/'; 
else                                          % Load a new image
    [filename filepath]=uigetfile('*.bmp','Load an image');
    if filename==0
        return;
    end
end

global orgImage;
global segImage;
global markerImage;
global Label;
global orgEdgeImage
global imgHeight;             
global imgWidth;
global lineHandle;

if ~isempty(lineHandle)
    set(lineHandle,'visible','off');
    lineHandle=[];
end

hdl=get(figHandle,'userdata');% 
% For an image, height shoule be less than 600 and widht should be less than 500
orgImage=imread([filepath,filename]);
% load the initial segmentation of the orginal image
segImage=imread([filepath filename(1:end-4) '_MS_bndy' '.png']);
imgHeight=size(orgImage,1);
imgWidth=size(orgImage,2);

markerImage=zeros(imgHeight,imgWidth);

if imgHeight>500 || imgWidth>600
    msgbox('the size of the image is too big!');
    exit
end
figPosition=get(gcf,'position');        
orgImgPosition=[50,figPosition(4)-imgHeight-50, imgWidth,imgHeight];

Label=setLabel(segImage);              % conver the segImage into the labelled image to region merging next.
orgEdgeImage=drawedge(orgImage,Label); % 

set(hdl.figHandle_Axes1,'xlim',[.5, imgWidth+.5],'ylim',[.5 imgHeight+.5],'position',orgImgPosition);
set(get(hdl.figHandle_Axes1, 'Title'), 'String', 'initial segmentation','visible','on');
set(hdl.segImage, 'XData',[1 imgWidth],'YData',[1 imgHeight],'Cdata',orgImage);drawnow;

segImgPosition=[imgWidth+50+50,figPosition(4)-imgHeight-50, imgWidth,imgHeight];
set(hdl.figHandle_Axes2,'xlim',[.5, imgWidth+.5],'ylim',[.5 imgHeight+.5],'position',segImgPosition,'visible','on');
set(get(hdl.figHandle_Axes2, 'Title'), 'String', 'Original image','visible','on');
set(hdl.originalImage, 'XData',[1 imgWidth],'YData',[1 imgHeight],'Cdata',orgEdgeImage);drawnow;
set(figHandle,'userData',hdl);

% Set object or background marker
function setMarker(mode)
global figHandle;
global isObjectMarker;
global isBackgroundMarker;
hdl=get(figHandle,'userdata');
isObjectMarker=0;
isBackgroundMarker=0;
set([hdl.btn2,hdl.btn3],'value',0);
if mode==1
    isObjectMarker=1;
    set(hdl.btn2,'value',1);
elseif mode==2
    isBackgroundMarker=1;
    set(hdl.btn3,'value',1);   
end
set(figHandle,'Userdata',hdl); 

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
     hdl.line1=line('Parent',hdl.figHandle_Axes1,...
         'Interruptible','off',...
         'LineStyle','-',...
         'LineWidth',3,...
         'color',[0 1 0],...
         'EraseMode','normal',...
         'Visible','off');
     hdl.line2=line('Parent',hdl.figHandle_Axes2,...
         'Interruptible','off',...
         'LineStyle','-',...
         'LineWidth',3,...
         'color',[0 1 0],...
         'EraseMode','normal',...
         'Visible','off');
     lineHandle=[lineHandle,hdl.line1,hdl.line2];
     set(figHandle,'userData',hdl);
end

function MouseMotion()
global figHandle;
global markerImage;
global isObjectMarker;
global isBackgroundMarker;
global orgImage;
global segImage;
global orgEdgeImage;
global markerPnts;
global imgHeight;             
global imgWidth;
global linePnts;
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
pt=get(hdl.figHandle_Axes1,'CurrentPoint'); % 
pt=pt(1,1:2); % 
if pt(1)>=1 & pt(1)<=imgWidth & pt(2)>=1 & pt(2)<=imgHeight
    m=size(markerPnts,2);
    markerPnts(1,m+1)=pt(1);
    markerPnts(2,m+1)=pt(2);
    if isBackgroundMarker
        set([hdl.line1,hdl.line2],'XData',markerPnts(1,:),'YData',markerPnts(2,:),'color',[0 0 1],'Visible','on');drawnow;
    else
        set([hdl.line1,hdl.line2],'XData',markerPnts(1,:),'YData',markerPnts(2,:),'color',[0 1 0],'Visible','on');drawnow;        
    end
end

    
function MouseUp()
global mouseValid;
global markerPnts;
global isObjectMarker;
global isObjectMarker;
global markerImage;

setptr(gcf,'arrow');
mouseValid=0;
m=size(markerPnts,2);
for i=1:m-1
    Pnts=DDALine(markerPnts(1,i),markerPnts(2,i),markerPnts(1,i+1),markerPnts(2,i+1));
    n=size(Pnts,2);
    if isObjectMarker==1
        for j=1:n
            col=floor(Pnts(1,j));
            row=floor(Pnts(2,j));
            markerImage(row,col)=2;
        end
    else
        for j=1:n
            col=floor(Pnts(1,j));
            row=floor(Pnts(2,j));
            markerImage(row,col)=1;
        end
    end
end
return;

function reInitilizateMarker()
global figHandle; 
global markerImage;
global orgEdgeImage;
global imgHeight;
global imgWidth;
global lineHandle;
markerImage=zeros(imgHeight,imgWidth);
hdl=get(figHandle,'Userdata');
set(lineHandle,'visible','off');
lindHandle=[];
set(hdl.originalImage,'CData',orgEdgeImage,'EraseMode','none');  drawnow;
set(figHandle,'userData',hdl);

function interactiveRegionProcessing()
global segImage;
global orgImage;
global Label;
global markerImage;
global lineHandle;
edgeImage=drawedge(orgImage,Label);
D=regionprocessing();       % all related papramenter is global parameter
set(lineHandle(2:2:end),'visible','off');
return;

function exitGUI()
global figHandle
close(figHandle);