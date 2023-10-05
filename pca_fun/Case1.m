clc
close all;
clear
%% pca 和 T2样例 以及如何画椭圆
%% 
m=1000; % the number of samples
alpha1=0.95;
alpha2=0.99;
%% data set
x1=-5+10*randn(m,1);
x2=5*x1.^1+1*randn(m,1);
x3=0.01*randn(m,1);
% x4=3*x3.^1;
% x5=5*x3;
% x=[x1,x2,x3,x4,x5];
x=[x1,x2,x3];
%% sdandardized
miu=mean(x);st=std(x);
n=size(x,2);
for i=1:n
x(:,i)=(x(:,i)-miu(i))./st(i);
end
figure(1)
subplot(1,3,1)
plot3(x(:,1),x(:,2),x(:,3),'k.')
axis equal
xlabel('x_1');ylabel('x_2'),zlabel('x_3')
%% PCA
[coeff, score, latent, tsquared, explained] = pca(x); % score
figure(2)
bar(latent)
title('Eigenvalue chart')
for i=1:m
  T(i,:)=x(i,:)*coeff;      %T=score
end

figure(1)
subplot(1,3,2)
plot3(T(:,1),T(:,2),T(:,3),'k.')
xlabel('t_1');ylabel('t_2');zlabel('t_3')
axis equal
% according to CPV PCS=2;
PCS=2;
% the retained PCS 
  Tx=T(:,1:PCS);

figure(1)
subplot(1,3,3)
plot(Tx(:,1),Tx(:,2),'k.')
xlabel('PC1 or t_1'); ylabel('PC2 or T_2')
axis equal
% T2
C=diag(latent(1:PCS,:));
INVC=inv(C);
for i=1:m
   T2(i)=Tx(i,:)*INVC*Tx(i,:)';
end
% control limit
T2CL1=quantile(T2,alpha1);
T2CL2=quantile(T2,alpha2);
% control chart
figure(4)
plot([1,m]',[T2CL1,T2CL1],'k-','Linewidth',2)
hold on
plot([1,m]',[T2CL2,T2CL2],'r-.','Linewidth',2)
plot(T2,'k-.')
legend('0.95Control limit of T^2','0.99Control limit of T^2','T^2 of training samples')
xlabel('samples');ylabel('T^2')
%% ellipse
a=sqrt(latent(1,:)*T2CL1);
b=sqrt(latent(2,:)*T2CL1);
thita=0:0.01:2*pi;
t1=a*cos(thita);
t2=b*sin(thita);

a=sqrt(latent(1,:)*T2CL2);
b=sqrt(latent(2,:)*T2CL2);
thita=0:0.01:2*pi;
s1=a*cos(thita);
s2=b*sin(thita);
figure(1)
subplot(1,3,3)
hold on
plot(t1,t2,'k-.','Linewidth',1)
plot(s1,s2,'r-s','Linewidth',1)
legend('Score of samples','0.95 Control limit of T^2','0.99 Control limit of T^2')





