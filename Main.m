% This script aims at demonstrating the efficiency of the method
clc
clear
close all

% Parameters
path = 'Img/';
image_background = imread(strcat(path,'Field.jpg'));
image_element = imread(strcat(path,'Horses.jpg'));
image_omega = imread(strcat(path,'Mask_Horses.jpg'));
image_omega(image_omega>0) = 1;
x0 = 586;
y0 = 656;

% Solving Poisson equation for seamless cloning
resulting_image = seamless_cloning(image_background,image_element,...
    image_omega,x0,y0);
figure
imshow(resulting_image)
imwrite(resulting_image,strcat(path,'Cloning_Horses.jpg'))