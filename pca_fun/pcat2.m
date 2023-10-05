close all;
clear;
clc;
%% 产生训练数据
m=500;
% 产生500行3列的数据
s=10*randn(m,1);
q=4*randn(m,1);
r=2*randn(m,1);
t=randn(m,1);
e=0.01*randn(m,1);
a=sqrt(2)/2;

x1=a*(s+r)+t+e;
x2=a*(s-r)+t+e;
x3=x1+q;
x4=t;
x=[x1,x2,x3,x4];
Xtrain =x;

%% 标准化处理训练数据：
X_mean=mean(Xtrain);
st=std(Xtrain);
n=size(Xtrain,2);
for i=1:n
    Xtrain(:,i)=(Xtrain(:,i)-X_mean(i)) ./ st(i);
end
figure(1);
subplot(1,3,1);
plot3(Xtrain(:,1),Xtrain(:,2),Xtrain(:,3),'ko')
axis equal;
xlabel('X_1'),
ylabel('X_2'),
zlabel('X_3');


%% 求训练数据 T2统计量
[coeff, score, latent, tsquared, explained]=pca(Xtrain);

figure(2);
bar(latent);
title('特征值');
T=score;

figure(1)
subplot(1,3,2);
plot3(T(:,1),T(:,2),T(:,3),'ko');
axis equal;
xlabel('X_1'),
ylabel('X_2'),
zlabel('X_3');
%% 置信度为95%的t2 
T2UCL1=ksdensity(tsquared,0.95,'Function','icdf');

num=1;
while sum(latent(1:num))/sum(latent) < 0.95
    num=num+1;
end

Tx=T(:,1:num);

figure(1)
subplot(1,3,3)
plot3(Tx(:,1),Tx(:,2),Tx(:,3),'k.')
xlabel('PC1 or t_1'); ylabel('PC2 or T_2'); zlabel('PC3 or T_3')
axis equal
hold on;
%% 

C=diag(latent(1:num));
INVC=inv(C);
for i=1:500
    T2(i)=Tx(i,:)*INVC*Tx(i,:)';
end

figure(3)
plot([1,500]',[T2UCL1,T2UCL1],'r-','Linewidth',2)
hold on
plot(T2,'k-.')
legend('0.95Control limit of T^2','T^2 of training samples')
xlabel('samples');ylabel('T^2')


%% 画椭球
a=sqrt(latent(1,:)*T2UCL1);
b=sqrt(latent(2,:)*T2UCL1);
c=sqrt(latent(3,:)*T2UCL1);

% thita=0:0.01:2*pi;
% t1=a*cos(thita);
% t2=b*sin(thita);

t = linspace(0,2*pi,66);
p = linspace(0,pi,50);
[T,P] = meshgrid(t,p);

x = a*cos(T).*cos(P);
y = b*cos(T).*sin(P);
z = c*sin(T);

% x = a*sin(T).*cos(P);
% y = b*sin(T).*sin(P);
% z = c*cos(T);


figure(1);
subplot(1,3,3);
plot3(x,y,z,'r-.','Linewidth',1)
legend('score','t2');
