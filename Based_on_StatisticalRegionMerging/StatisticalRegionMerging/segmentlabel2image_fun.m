function [image]=segmentlabel2image_fun(image,segments,figure_name)
[a,b,h]=size(image);
for m=1:a
    for n=1:b
        if (m==1)||(n==1)||(m==a)||(n==b)
            image(m,n)=image(m,n);
        elseif (segments(m,n)~=segments(m-1,n)||segments(m,n)~=segments(m+1,n)||segments(m,n)~=segments(m,n-1)||segments(m,n)~=segments(m,n+1))
            image(m,n,1)=255;
            image(m,n,2)=0;
            image(m,n,3)=0;
        end
    end
end

image=segment_line_red2other(image);

% imwrite(image,[figure_name '1' '.bmp']);

% numlabels=max(max(segments));
% image_R=image(:,:,1);
% image_G=image(:,:,2);
% image_B=image(:,:,3);
% 
% for k=1:numlabels
%     [row_superpixel,col_superpixel]=find(segments==k);     %标签为k的超像素的横纵坐标位置
% 
%     index_R=sub2ind(size(image_R),row_superpixel,col_superpixel);
%     index_G=sub2ind(size(image_G),row_superpixel,col_superpixel);
%     index_B=sub2ind(size(image_B),row_superpixel,col_superpixel);
% %     mean_R(k)=mean(image_R(index_R));                   %求每个超像素块 LAB 三个分量的平均值
% %     mean_G(k)=mean(image_G(index_G));
% %     mean_B(k)=mean(image_B(index_B));
%     image_R(index_R)=mean(image_R(index_R));
%     image_G(index_G)=mean(image_G(index_G));
%     image_B(index_B)=mean(image_B(index_B));
% end
% image(:,:,1)=image_R;
% image(:,:,2)=image_G;
% image(:,:,3)=image_B;
% figure
% imshow(image);
% title(figure_name)
% imwrite(image,[figure_name '2' '.bmp']);