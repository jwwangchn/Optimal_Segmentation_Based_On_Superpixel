clc
clear all
close all
image=double(imread('yaan2.tif'));

% Choose different scales
% Segmentation parameter Q; Q small few segments, Q large may segments
Qlevels=2.^(8:-1:0);
% Qlevels=2.^(2);
% This creates the following list of Qs [256 128 64 32 16 8 4 2 1]
% Creates 9 segmentations

%maps和Qs关联很强
[maps,images]=srm(image,Qlevels);
% And plot them
srm_plot_segmentation(images,maps);

for i=1:length(Qlevels)    
    image=segmentlabel2image_fun(imread('yaan2.tif'),maps{i},'SRM分割结果');
    figure(104);
    vl_tightsubplot(length(Qlevels), i) ;
    imagesc(image);
    axis off;
end
