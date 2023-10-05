% 1.读取原始数据
load fisheriris;
X = meas;

% 去原始数据的前两列 画图
% figure;
% gscatter(X(:,1),X(:,2),species);
% xlabel('PC1');
% ylabel('PC2');
% title('原始的数据画图');


% 2.中心化
X_mean = mean(X);

X_std = std(X);    %求标准差 消除量纲    

[X_row,X_col] = size(X); %求Xtrain行、列数               
xxx1=repmat(X_mean,X_row,1); %均值列矩阵
xxx2=repmat(X_std,X_row,1); % 标准差列矩阵 标准差乘以 样本列
X_center=(X- xxx1)./xxx2;   % 减去均值 消除量纲



% 3.确认协方差矩阵的特征值和特征向量
% 求协方差矩阵
cov_mat = cov(X_center);
% 求特征值和特征向量
[V,D] = eig(cov_mat);

% 取对角线值
eigenvalues = diag(D);
% 降序排列特征值
[~,idx] = sort(eigenvalues,'descend');
V_sort = V(:,idx);

% 取前两列 正常取维度应该求占整体特征值 90% 以上的
k = 2;
V_k = V_sort(:,1:k);
% 得到降维之后的矩阵
X_pca = X_center * V_k;

%图形化
figure;
gscatter(X_pca(:,1),X_pca(:,2),species);
xlabel('PC1');
ylabel('PC2');
title('PCA');