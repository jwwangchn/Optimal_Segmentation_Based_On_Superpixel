clc
clear
close all
tic()
%在MATLAB中测试GitHub
%% [0] 定义参数
T_threshold=2.3;          %阈值参数 321*421的时候,取值 2.3 效果很好,
num_clusters = 20;      %聚类数量 321*421的时候,取值 20
sigma = 100;            %可以修改，不知道物理意义
RGB_LAB_flag=0;         %选择在 LAB 空间(1)进行还是在 RGB 空间(0)进行

if RGB_LAB_flag==1
    T_threshold=0.6;
else
    T_threshold=0.6;
end
%% [1] SLIC超像素分割生成超像素块

SuperpixelsNum=500;     %超像素数量
CompactnessFactor=20;   %紧密度
image=imread('1.jpg');  %原始图像
[image_width,image_heigh,image_d]=size(image);
%segments为超像素的标签，numlabels为超像素数量
[segments, numlabels]=mex_SLIC_fun(image, SuperpixelsNum, CompactnessFactor);
segments=segments+1;    %为了方便运算和矩阵存储，故+1

%% [2] Spectral Clustering谱聚类

%constant,m估计和图片大小有关系,修改图片记得修改m
m=100;
SW=sqrt(image_width*image_heigh)/m;
image_lab=rgb2lab(image);           %色域转换RGB TO LAB
image_lab_L=image_lab(:,:,1);
image_lab_A=image_lab(:,:,2);
image_lab_B=image_lab(:,:,3);
image_R=image(:,:,1);
image_G=image(:,:,2);
image_B=image(:,:,3);
D=zeros(numlabels,numlabels);       %生成距离度量矩阵

%求解每个超像素块的 5-D 分量LABXY,超像素标签从0开始

%% [3] 求解各个超像素块的基本信息的均值,LABXY

for k=1:numlabels
    [row_superpixel,col_superpixel]=find(segments==k);     %标签为k的超像素的横纵坐标位置
    position_superpixel=[row_superpixel,col_superpixel];    %超像素块的位置信息
    mean_X(k)=mean(col_superpixel);                         %求每个超像素块的坐标平均值
    mean_Y(k)=mean(row_superpixel);
    index_L=sub2ind(size(image_lab_L),row_superpixel,col_superpixel);
    index_A=sub2ind(size(image_lab_A),row_superpixel,col_superpixel);
    index_B=sub2ind(size(image_lab_B),row_superpixel,col_superpixel);
    mean_L(k)=mean(image_lab_L(index_L));                   %求每个超像素块 LAB 三个分量的平均值
    mean_A(k)=mean(image_lab_A(index_A));
    mean_B(k)=mean(image_lab_B(index_B));
    mean_RGB_R(k)=mean(image_R(index_L));                   %求每个超像素块 LAB 三个分量的平均值
    mean_RGB_G(k)=mean(image_G(index_A));
    mean_RGB_B(k)=mean(image_B(index_B));
end

%% [4] 求解距离度量矩阵 Dij

for i=1:numlabels
    for j=1:numlabels
        Color_D=(mean_L(i)-mean_L(j)).^2+(mean_A(i)-mean_A(j)).^2+(mean_B(i)-mean_B(j)).^2;
        Distance_D=((mean_X(i)-mean_X(j))./SW).^2+((mean_Y(i)-mean_Y(j))./SW).^2;
        D(i,j)=sqrt(Color_D+Distance_D);
    end
end


%% [5] 寻找任意超像素距离最近的5个超像素块并求均值
t=5;                                                  %超像素 i 最近的几个超像素的集合的数量，论文中取5
for i=1:numlabels
    [D_sort(i,:),D_index(i,:)]=sort(D(i,:));          %对距离矩阵进行排序，取最小的5个值
    T_neighbor_index(i,:)=D_index(i,1:t+1);           %距离 i 最近的5个超像素的索引
    T_neighbor_value(i,:)=D_sort(i,1:t+1);            %距离 i 最近的5个超像素的值
    sigma_i(i)=mean(T_neighbor_value(i,:));
end


%% [6] 计算相似度矩阵

for i=1:numlabels
    for j=1:numlabels
        if T_neighbor_index(i,:)~=j
            S(i,j)=0;
        else
            S(i,j)=exp((-D(i,j).^2)/(2*sigma_i(i)*sigma_i(j)));
        end
    end
end

%% [7] 计算谱聚类

cluster_labels=sc(S,sigma,num_clusters);                    %返回值表示了每一个超像素标签所属的聚类标签
segments_cluster=100*(ones(size(segments)));
for i=1:numlabels
    [row_superpixel,col_superpixel]=find(segments==i);
    index_cluster=sub2ind(size(image_lab_L),row_superpixel,col_superpixel);
    segments_cluster(index_cluster)=cluster_labels(i);
end
for i=1:num_clusters
    superpixel_cluster_labels{i}=find(cluster_labels==i);   %存储每一个聚类有哪些超像素块
end
segments_cluster=int32(segments_cluster);
segmentlabel2image_fun(image,segments_cluster,'谱聚类合并结果');             %显示图像

%% [8] 得到相邻超像素块和相邻聚类的index

%相邻超像素块的index
for i=1:numlabels
    value = i;      %要判断的超像素块
    adj = [0 1 0; 1 0 1; 0 1 0];
    mask = conv2(double(segments==i),adj,'same')>0;
    temp=unique(segments(mask));
    temp_row=temp';
    %删除自身
    self_index=find(temp_row==i);
    temp_row(self_index)=[];
    %得到每个超像素的邻接超像素的index
    result_SLIC{i}=temp_row;
end
%生成超像素的邻接矩阵A
superpixel_A=zeros(numlabels,numlabels);
for i=1:numlabels
    for j=1:numlabels
        superpixel_A(i,result_SLIC{i})=1;
    end
end
%相邻聚类的index
for i=1:num_clusters
    value = i;      %要判断的超像素块
    adj = [0 1 0; 1 0 1; 0 1 0];
    mask = conv2(double(segments_cluster==i),adj,'same')>0;
    temp=unique(segments_cluster(mask));
    temp_row=temp';
    %删除自身
    self_index=find(temp_row==i);
    temp_row(self_index)=[];
    %得到每个超像素的邻接超像素的index
    result_cluster{i}=temp_row;
end
%生成聚类的邻接矩阵A
cluster_A=zeros(numlabels,numlabels);
for i=1:num_clusters
    for j=1:num_clusters
        cluster_A(i,result_cluster{i})=1;
    end
end
%% [9] 找到聚类 i 和聚类 j 相邻边界上的超像素块有哪些

for i=1:num_clusters
    for j=1:num_clusters
        if any(result_cluster{i}==j)
            %说明聚类 i 和 j 相邻,下面判断聚类 i 和 j 中的超像素是否相邻
            %首先看聚类 i 和 j 中存在哪些超像素
            cluster_i_superpixel=superpixel_cluster_labels{i};
            cluster_j_superpixel=superpixel_cluster_labels{j};
            length_i=length(cluster_i_superpixel);
            length_j=length(cluster_j_superpixel);
            k=1;
            for m=1:length_i
                for n=1:length_j
                    if superpixel_A(cluster_i_superpixel(m),cluster_j_superpixel(n))==1     %说明超像素邻接
                        cluster_i_j{i,j,k}=[cluster_i_superpixel(m),cluster_j_superpixel(n)];
                        k=k+1;  %邻接的超像素的数量
                    end
                end
            end
            %记录邻接矩阵的数量
            num_adjacent_superpixel(i,j)=k-1;
            
        end
    end
end

%% [10] 计算阈值 T

for i=1:numlabels
    temp=result_SLIC{i};
    for j=1:length(temp)
        if RGB_LAB_flag==1
            Color_cluster_superpixel_D=(mean_L(i)-mean_L(temp(j))).^2+(mean_A(i)-mean_A(temp(j))).^2+(mean_B(i)-mean_B(temp(j))).^2;
            D_cluster(j)=sqrt(Color_cluster_superpixel_D);
        else
            Color_cluster_superpixel_D=(mean_RGB_R(i)-mean_RGB_R(temp(j))).^2+(mean_RGB_G(i)-mean_RGB_G(temp(j))).^2+(mean_RGB_B(i)-mean_RGB_B(temp(j))).^2;
            D_cluster(j)=sqrt(Color_cluster_superpixel_D);
        end
    end
    MaxEdges(i)=max(D_cluster);
end
if max(MaxEdges)>10
    T=mean(MaxEdges)-std(MaxEdges)/2;
else
    T=10;
end

%% [11] 计算邻接图的不相似度

% temp_flag=0;
% [a,b,c]=size(cluster_i_j);
% for i=1:a
%     for j=1:b
%         for k=1:c
%             temp=cluster_i_j{i,j,k};
%             if isempty(cluster_i_j{i,j,k})==0   %表明邻接了
%                 Color_cluster_superpixel_D_temp=(mean_L(temp(1))-mean_L(temp(2))).^2+(mean_A(temp(1))-mean_A(temp(2))).^2+(mean_B(temp(1))-mean_B(temp(2))).^2;
%                 E_cluster(k)=sqrt(Color_cluster_superpixel_D_temp);
%                 temp_flag=1;
%             end
%         end
%         if temp_flag==1
%             D_Ri_Rj(i,j)=mean(E_cluster);
%             temp_flag=0;
%             E_cluster=0;
%         else
%             D_Ri_Rj(i,j)=0;
%             E_cluster=0;
%             temp_flag=0;
%         end
%     end
% end
%% [10] 根据阈值更新区域邻接图矩阵 A

% A=zeros(num_clusters);
% for i=1:num_clusters
%     for j=1:num_clusters
%         if D_Ri_Rj(i,j)<T
%             A(i,j)=1;
%         else
%             A(i,j)=0;
%         end
%     end
% end

%% [11] 按照矩阵A合并区域


%% [12] 暂时跳过 11 ,直接调用 python 中的 RAG 函数进行合并运算

image_python = reshape(image,[1 numel(image)]);                 %将image矩阵转换成python能接受的类型
segments_cluster_python = reshape(segments_cluster,[1 numel(segments_cluster)]);
image_python= py.numpy.array(image_python);
segments_cluster_python= py.numpy.array(segments_cluster_python);

%尝试使用LAB颜色空间
image_lab_python = reshape(image_lab,[1 numel(image_lab)]);                 %将image矩阵转换成python能接受的类型
image_lab_python= py.numpy.array(image_lab_python);
if RGB_LAB_flag==1
    rag_cluster=py.skimage.future.graph.rag_mean_color(image_lab_python,segments_cluster_python);      %生成聚类的 RAG 图
else
    rag_cluster=py.skimage.future.graph.rag_mean_color(image_python,segments_cluster_python);      %生成聚类的 RAG 图
end
rag_segments=py.skimage.future.graph.cut_threshold(segments_cluster_python,rag_cluster,T_threshold*T);     %生成 RAG 新的segments

rag_segments_list=py.list(rag_segments);        %转换成 python 的list类型,便于索引

cP = cell(rag_segments_list);
rag_segments_int32 = cellfun(@int32,cP);     %转换成matlab的矩阵类型int32

rag_segments_int32_reshap = reshape(rag_segments_int32,[image_width image_heigh]);  %改变大小
rag_segments_int32_reshap=rag_segments_int32_reshap+1;
segmentlabel2image_fun(image,rag_segments_int32_reshap,'RAG 合并结果');

time=toc()