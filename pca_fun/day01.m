x = 0:0.01:2*pi; %定义x的范围，第二个参数表示步长
y = sin(x);
figure %建立一个幕布
plot(x,y) %绘制当前二维平面图
title('y = sin(x)') %标题
xlabel('x') %x轴
ylabel('sin(x)') %y轴
xlim([0 2*pi]) % x坐标值的范围