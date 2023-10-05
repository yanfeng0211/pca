clc;clear;close all;
rgbimage=imread('boy1.jpeg');
figure(1),
subplot(1,3,1),imshow(rgbimage);
title('原始图像');
 
I = rgb2gray(rgbimage);
figure(1)
subplot(1,3,2),imshow(I);