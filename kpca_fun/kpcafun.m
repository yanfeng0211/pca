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
