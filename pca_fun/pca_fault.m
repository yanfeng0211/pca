close all;
clear all;
clc;
%% 产生训练数据
num_sample=500;
% 产生500行1列的数据
s=6*randn(num_sample,1);
r=2*randn(num_sample,1);
t=randn(num_sample,1);
a=sqrt(2)/2;

x1=a*(s+r)+t;
x2=a*(s-r)+t;
x3=t;
x=[x1,x2,x3];
Xtrain =x;

scatter3(x1,x2,x3,'o','k');
hold on;



%% 产生校验数据
num_sample=100;
% 产生500行1列的数据
s=6*randn(num_sample,1);
r=2*randn(num_sample,1);
t=randn(num_sample,1);
a=sqrt(2)/2;

x1=a*(s+r)+t;
x2=a*(s-r)+t;
x3=t;

Xtest =[x1,x2,x3];
scatter3(x1,x2,x3,'*','blue');
hold on;

%% 产生误差数据
num_sample=3;
% 产生500行1列的数据
s=6*randn(num_sample,1);
s1=5*s;
r=2*randn(num_sample,1);
t=randn(num_sample,1);
a=sqrt(2)/2;

x1=a*(s1+r)+t;
x2=a*(s1-r)+t;
x3=t;

Xtest1 =[x1,x2,x3];
scatter3(x1,x2,x3,'filled','red');


%% 标准化处理训练数据：
X_mean = mean(Xtrain);  %按列求Xtrain平均值    
m = size(Xtrain,1);
X_std = std(Xtrain);    %求标准差 消除量纲                     
[X_row,X_col] = size(Xtrain); %求Xtrain行、列数               
xxx1=repmat(X_mean,X_row,1); %均值列矩阵
xxx2=repmat(X_std,X_row,1); % 标准差列矩阵 标准差乘以 样本列
Xtrain=(Xtrain- xxx1)./xxx2;   % 减去均值 消除量纲

%% 求得分矩阵
%求协方差矩阵
sigmaXtrain = cov(Xtrain);

%对协方差矩阵进行特征分解，lamda为特征值构成的对角阵，T的列为单位特征向量，且与lamda中的特征值一一对应：
% eig 对对称矩阵回自动排序
[T,lamda] = eig(sigmaXtrain);    

%取对角元素(结果为一列向量)，即lamda值，并上下反转使其从大到小排列，主元个数初值为1，若累计贡献率小于90%则增加主元个数
% 获取特征维数
[~,idx] = sort(diag(lamda),'descend');
T = T(:,idx);  

D=sort(diag(lamda),'descend');

num_pc = 1;                                         
while sum(D(1:num_pc))/sum(D) < 0.9   
num_pc = num_pc +1;
end                         


%取与lamda相对应的特征向量
P = T(:,1:num_pc);   

% T 为特征向量 TT为新坐标基上的矩阵
TT=Xtrain*T;


% T_score 为主元空间上的矩阵 得分矩阵
T_score=Xtrain*P;

% 降维之后的数据
figure;
scatter(T_score(:,1),T_score(:,2),'o','k');
xlabel('PC1');
ylabel('PC2');
title('PCA');
hold on;

%% 标准化处理测试数据
n = size(Xtest,1);
Xtest=(Xtest-repmat(X_mean,n,1))./repmat(X_std,n,1);
TT2=Xtest*P;

%降维之后的测试数据
scatter(TT2(:,1),TT2(:,2),'*','blue');
xlabel('PC1');
ylabel('PC2');
title('PCA');
hold on;

%% 标准化处理误差数据
q = size(Xtest1,1);
Xtest1=(Xtest1-repmat(X_mean,q,1))./repmat(X_std,q,1);
TT3=Xtest1*P;

%降维之后的测试数据
scatter(TT3(:,1),TT3(:,2),'filled','red');
xlabel('PC1');
ylabel('PC2');
title('PCA');

%% 求训练数据 T2统计量，Q统计量
[r,y] = size(P*P');
I = eye(r,y);

T20 = zeros(m,1);
Q20 = zeros(m,1);
for i = 1:m
    T20(i)=Xtrain(i,:)*P*pinv(lamda(1:num_pc,1:num_pc))*P'*Xtrain(i,:)';  
    Q20(i) = Xtrain(i,:)*(I - P*P')*(I - P*P')'*Xtrain(i,:)';                                                                                    
end


%% 置信度为95%的t2 和Q统计控制限   
T2UCL1=ksdensity(T20,0.95,'Function','icdf');

for i = 1:3
    theta(i) = sum((D(1:num_pc)).^i);
end
h0 = 1 - 2*theta(1)*theta(3)/(3*theta(2)^2);
ca = norminv(0.95,0,1);
QUCL = theta(1)*(h0*ca*sqrt(2*theta(2))/theta(1) + 1 + theta(2)*h0*(h0 - 1)/theta(1)^2)^(1/h0);


%% 求测试数据的t2    Q 统计量
T2 = zeros(n,1);
Q = zeros(n,1);

for i = 1:n
    T2(i)=Xtest(i,:)*P*pinv(lamda(1:num_pc,1:num_pc))*P'*Xtest(i,:)';  
    Q(i) = Xtest(i,:)*(I - P*P')*(I - P*P')'*Xtest(i,:)';                                                                                    
end

%% 求误差数据的t2    Q 统计量
T22 = zeros(q,1);
Q22 = zeros(q,1);
for i = 1:q
    T22(i)=Xtest1(i,:)*P*pinv(lamda(1:num_pc,1:num_pc))*P'*Xtest1(i,:)';  
    Q22(i) = Xtest1(i,:)*(I - P*P')*(I - P*P')'*Xtest1(i,:)';                                                                                    
end


%% 画图
    figure
    subplot(2,1,1);
    scatter(1:m,T20,'o','k');                                    
    title('主元分析统计量变化图');
    xlabel('采样数');
    ylabel('T^2');
    hold on;
    
    scatter(m+1:m+n,T2,'*','blue');   
    hold on;
    
    scatter(m+n+1:m+n+q,T22,'filled','red');   
    hold on;
    
    line([0,m+n],[T2UCL1,T2UCL1],'LineStyle','--','Color','r');
    
    subplot(2,1,2);
    
    scatter(1:m,Q20,'o','k');
    xlabel('采样数');
    ylabel('SPE');
    hold on;
    scatter(m+1:m+n,Q,'*','blue');
    hold on;
    scatter(m+n+1:m+n+q,Q22,'filled','red');   
    hold on;
    line([0,m+n],[QUCL,QUCL],'LineStyle','--','Color','r');

