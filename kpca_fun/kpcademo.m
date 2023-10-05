clc;
oridata=load('iris.data');
data=oridata(:,1:4);
coldata=oridata(:,1);%先把第一列取出来
sigma=[3 3.5 4 4.5 5 5.5 5 10 100];%设置不同的σ的值

%利用不同的sigma值，绘制9个小图，在同一个figure里面
figure();
for i =1:9
    data_new=kpcafun(data,sigma(i));
    data_dif=[coldata,data_new(:,1:4)];
    %可选择性注释以下两行
    data_new=kpcafun(data_dif,sigma(i));
    data_dif=[coldata,data_new(:,1:4)];
    %可选择性注释以下两行
    data_new=kpcafun(data_dif,sigma(i));
    data_dif=[coldata,data_new(:,1:2)];
    
    hold on
    subplot(3,3,i)
    plottitle=['sigma=',num2str(sigma(i))];
    title(plottitle); 
    xlabel('X');
    ylabel('Y');

    paint(data_dif);
end

%绘制图表
function []=paint(data_dif)
[a b]=size(data_dif);
for i=1:a
    hold on
    if data_dif(i,1)==0
        plot(data_dif(i,2),data_dif(i,3),'r.','markersize',7);
    elseif data_dif(i,1)==1
        plot(data_dif(i,2),data_dif(i,3),'g.','markersize',7);
    elseif data_dif(i,1)==2
        plot(data_dif(i,2),data_dif(i,3),'b.','markersize',7);
    end
end
end

function [data_new]=kpcafun(data,sigma)
[a b]=size(data);
k=ones(a,a);
zero_m=ones(a,a)/a;%用于中心化

%求出核矩阵
for i=1:a
    x=data(i,:);
    for j=1:a
        y=data(j,:);
        k(i,j)=exp(-norm(x-y)^2 / (2*sigma^2));
    end
end

%核矩阵中心化得到新的矩阵
zero_k=k-zero_m*k-k*zero_m+zero_m*k*zero_m;

% 计算特征值与特征向量  data_v特征向量 data_e特征值
[data_v,data_e]=eig(zero_k); %data_e是一个对角阵
data_e=diag(data_e);

%排序
[dump,index]=sort(data_e,'descend');
data_e=data_e(index);
v=data_v(:,index);
% v=fliplr(data_v);%这种写法是不对的，当时因为这种写法使得结果异常

%取第一第二主成分
for i=1:a
    v(:,i)=v(:,i)/sqrt(data_e(i));
end
% data_all=v'*zero_k;
data_all=zero_k*v;
% data_all=data_all';
data_new=data_all;

end
