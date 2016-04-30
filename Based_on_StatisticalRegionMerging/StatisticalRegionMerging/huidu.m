clear 
close all
clc
for i=1:500
    for j=1:500
        if i<=100 || i>400
            image_R(i,j)=220;
        end
        if j<=100 || j>400
            image_R(i,j)=220;
        end
        
        if i>100&&i<=250&&j>100&&j<=250
            %×óÉÏ½Ç
            image_R(i,j)=72;
        end
        
        if i>250&&i<=400&&j>100&&j<=250
            %×óÏÂ½Ç
            image_R(i,j)=104;
        end
        
        if i>250&&i<=400&&j>250&&j<=400
            %ÓÒÏÂ½Ç
            image_R(i,j)=136;
        end
        
        if i>100&&i<=250&&j>250&&j<=400
            %ÓÒÉÏ½Ç
            image_R(i,j)=168;
        end
    end
end
image=zeros(500,500);
image(:,:)=image_R;
image=uint8(image);
imshow(image)
imwrite(image,'color.jpg')