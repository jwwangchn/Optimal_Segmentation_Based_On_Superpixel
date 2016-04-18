% *************************************************************************
% Filename: Demo.m                                    *
% Function: Implement the algorithm described in "Interactive Image       *
%           Segmentation by Maximal Similarity Based Region Merging,"     *
%           Pattern Recognition 2009, in press.                           *
% Author    Jifeng Ning£¬Lei Zhang, David Zhang, Chengke Wu               *
% Date    : 15th,June,2009                                                *
% Address   Department of Computing,                                      *
%           The Hongkong Polytechnic University                           *
%           Xidian Univeristy                                             *
%           College of Information, Northwest A&F University              *
%                                                                         *
%  Copyright (c) 2009 by Jifeng Ning, Lei Zhang, David Zhang, Chengke Wu  *
% *************************************************************************

clc
clear all;
global figHandle              % the handle of the interface
global orgImage;              % original image
global segImage;              % segmentation result of the image
global markerImage;           % the image with the object and backgrond marker
global orgEdgeImage           
global Label;                 % 
global isObjectMarker;        % boolean variable for the object marker
global isBackgroundMarker;    % boolean variable for the backgroud marker
global imgHeight;             
global imgWidth;
global markerPnts;            %
global mouseValid;
global lineHandle;

lineHandle=[];
mouseValid=0;
isObjectMarker=0;             % the default value is 0
isBackgroundMarker=0;         % the default value is 0

path(path,'./testimages');
path(path,'./regionMerging'); 
mainGUI;                      % start the inferfacte