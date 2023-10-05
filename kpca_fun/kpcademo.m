clc;
oridata=load('iris.data');
data=oridata(:,2:5);
coldata=oridata(:,1);%先把第一列取出来
sigma=[3 3.5 4 4.5 5 5.5 5 10 100];%设置不同的σ的值

%利用不同的sigma值，绘制9个小图，在同一个figure里面
figure();
for i =1:9
    data_new=kpcafun(data,sigma(i));
    data_dif=[coldata,data_new(:,1:4)];
    %可选择性注释以下两行
%     data_new=kpcafun(data_dif,sigma(i));
%     data_dif=[coldata,data_new(:,1:4)];
%     %可选择性注释以下两行
%     data_new=kpcafun(data_dif,sigma(i));
%     data_dif=[coldata,data_new(:,1:2)];
    
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

