clc;clear;close all;
rgbimage=imread('boy1.jpeg');
attack_rgbimage1=imnoise(rgbimage,'salt & pepper',0.01);
attack_rgbimage2=imnoise(rgbimage,'salt & pepper',0.1);

 
%%
figure(1),
subplot(1,3,1),imshow(rgbimage);
title('原始图像');
subplot(1,3,2),imshow(attack_rgbimage1);
title('噪声攻击图像1');
subplot(1,3,3),imshow(attack_rgbimage2);
title('噪声攻击图像2');


%%
ssimval1=SSIM(rgbimage,attack_rgbimage1);% 方法一
disp('SSIM函数的结构相似性：');
disp(ssimval1);

ssimval2=ssim(rgbimage,attack_rgbimage1);% 方法二
disp('matlab内置函数的结构相似性：');
disp(ssimval2);

ssimval1=SSIM(rgbimage,attack_rgbimage2);% 方法一
disp('SSIM函数的结构相似性：');
disp(ssimval1);

ssimval2=ssim(rgbimage,attack_rgbimage2);% 方法二
disp('matlab内置函数的结构相似性：');
disp(ssimval2);

