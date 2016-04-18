% *************************************************************************
% Filename: interactiveRegionMerging.m                                    *
% Function: Implement the algorithm described in Interactive Image        *
%           Segmentation by Maximal Similarity Based Region Merging       *
%           Pattern Recognition 2009, in press.                           *
% Author  ：Jifeng Ning，Lei Zhang, David Zhang, Chengke Wu               *
% Date    : 15th,June,2009                                                *
% last update:11th, July,2010
% Address ：Department of Computing, Biometric Research Center,           *
%           Hongkong polytechnic university                               *
%           Xidian Univeristy                                             *
%           College of information, Northwest A&F University              *
%                                                                         *
%  Software: MSRM Version 2.0
%  Copyright (c) 2009 by Jifeng Ning, Lei Zhang, David Zhang, Chengke Wu  *
% *************************************************************************

clc
clear all;

currentPath=cd;
% 添加路径
path(path,currentPath);
path(path,'./testimages');
path(path,'./regionMerging'); 

% 定义部分全局变量
global figHandle              % handle of main interface
global orgImage;              % original image
global iniSegImage;           % initial segment result by mean shift
global bwSegmentResultImage   % binary segmentation result by proposed MSRM
global bwMarkerImage;         % Image with foreground and background marker
global orgEdgeImage           % original edge of image
global Label;                 % 
global isObjectMarker;        % boolean value，1: set foreground marker
global isBackgroundMarker;    % boolean value, 1: set background marker
global imgHeight;             % height of image
global imgWidth;              % width of image
global markerPnts;            % coordinate of mouse
global mouseValid;            % is mouse valide? 1, valid
global redBins;               % color quantization schemes
global greenBins;             % 
global blueBins;              % 
global totalBins;             % total bins
global filename0;             % orginal filename
global filepath0;             % filepath for filename

% initialize data
mouseValid=0;
isObjectMarker=0;             % the default value is 0
isBackgroundMarker=0;         % the default value is 0

redBins=16;
greenBins=16;
blueBins=32;
totalBins=redBins*greenBins*blueBins;

mainGUI;                      % start the inferfacte