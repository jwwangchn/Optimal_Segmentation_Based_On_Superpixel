clc
clear all
close all
image=double(imread('coloredChips.png'));

% Choose different scales
% Segmentation parameter Q; Q small few segments, Q large may segments
Qlevels=2.^(8:-1:0);
% This creates the following list of Qs [256 128 64 32 16 8 4 2 1]
% Creates 9 segmentations

%maps和Qs关联很强
[maps,images]=srm(image,Qlevels);
% And plot them
srm_plot_segmentation(images,maps);

for i=1:length(Qlevels)    
    segmentlabel2image_fun(imread('coloredChips.png'),maps{i});
end
