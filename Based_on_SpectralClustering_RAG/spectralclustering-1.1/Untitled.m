clc
clear
close all
 
% 构造原始数据
ang = 0:pi/200:pi/2*3;
x1 = sin(ang) + randn(size(ang))*0.1;
y1 = cos(ang) + randn(size(ang))*0.1;
x2 = 2.3*sin(ang+pi) + randn(size(ang))*0.1;
y2 = 2.3*cos(ang) + randn(size(ang))*0.1;
x3 = 6*sin(ang+pi/2*3+pi/6) + randn(size(ang))*0.1;
y3 = 5*cos(ang+pi/2*3) + randn(size(ang))*0.1;
 
X = [x1, x2, x3; y1, y2, y3]';
figure
plot(X(:, 1), X(:, 2), '.')
axis equal
 
% 谱聚类
num_neighbors = 20;
block_size = 5;
gen_nn_distance(X, num_neighbors, block_size, 0); % 计算相似矩阵，保存到NN_sym_distance.mat文件中
 
filename = [num2str(num_neighbors), '_NN_sym_distance'];
load(filename)
 
num_clusters = 3;
sigma = 10;
cluster_labels = sc(A, sigma, num_clusters); % 谱聚类
 
figure
plot(X(cluster_labels == 1, 1), X(cluster_labels == 1, 2), 'r.', ...
    X(cluster_labels == 2, 1), X(cluster_labels == 2, 2), 'b.', ...
    X(cluster_labels == 3, 1), X(cluster_labels == 3, 2), 'g.')
% axis equal