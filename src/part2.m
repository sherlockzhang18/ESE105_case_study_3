clc;
clearvars;
close all;
% *******************************************************************
load("lightField.mat");

d1 = 0.4;
f = 0.2;
d2 = f*d1/(d1-f);



M_d1 = [1, d1, 0, 0;
        0, 1,  0, 0;
        0, 0,  1, d1;
        0, 0,  0, 1];

M_d2 = [1, d2, 0, 0;
        0, 1,  0, 0;
        0, 0,  1, d2;
        0, 0,  0, 1];

M_f = [1,    0, 0,    0;
       -1/f, 1, 0,    0;
       0,    0, 1,    0;
       0,    0, -1/f, 1];
% *******************************************************************
rays2 = M_d2*(M_f*rays);
rays_x = rays2(1, :);
rays_y = rays2(3, :);
img = rays2img(rays_x, rays_y, 0.005, 200);
imshow(img);

figure;
histogram(rays(2, :));  % Histogram for x-direction angles
title('Distribution of Propagation Angles in X-Direction');
figure;
histogram(rays(4, :));  % Histogram for y-direction angles
title('Distribution of Propagation Angles in Y-Direction');

% Assuming the angles are in the 2nd and 4th rows
x_angles = rays(2, :);
y_angles = rays(4, :);

% Define angle ranges for segregation
angle_range1 = [-0.2, -0.05];  % define the angle range for object 1
angle_range2 = [-0.05, 0.05];  % define the angle range for object 2
angle_range3 = [0.05, 0.2];  % define the angle range for object 3

% Filter rays based on angle ranges
rays_obj1 = rays(:, (x_angles >= angle_range1(1) & x_angles <= angle_range1(2)));

rays_obj2 = rays(:, (x_angles >= angle_range2(1) & x_angles <= angle_range2(2)));

rays_obj3 = rays(:, (x_angles >= angle_range3(1) & x_angles <= angle_range3(2)));

rays_obj1 = M_d2*(M_f*rays_obj1);
rays_x = rays_obj1(1, :);
rays_y = rays_obj1(3, :);
img = rays2img(rays_x, rays_y, 0.005, 200);
figure;
imshow(img);

rays_obj2 = M_d2*(M_f*rays_obj2);
rays_x = rays_obj2(1, :);
rays_y = rays_obj2(3, :);
img = rays2img(rays_x, rays_y, 0.005, 200);
figure;
imshow(img);

rays_obj3 = M_d2*(M_f*rays_obj3);
rays_x = rays_obj3(1, :);
rays_y = rays_obj3(3, :);
img = rays2img(rays_x, rays_y, 0.005, 200);
figure;
imshow(img);

% rays_x = rays(1, :);
% rays_y = rays(3, :);
% img = rays2img(rays_x, rays_y, 0.005, 200);
% figure;
% imshow(img);

% figure;
% img = rays2img(rays_x, rays_y, 0.01, 200);
% imshow(img);
% 
% figure;
% img = rays2img(rays_x, rays_y, 0.001, 200);
% imshow(img);
% 
% figure;
% img = rays2img(rays_x, rays_y, 0.005, 1000);
% imshow(img);
% 
% figure;
% img = rays2img(rays_x, rays_y, 0.005, 50);
% imshow(img);




% *******************************************************************
% *******************************************************************
function [img,x,y] = rays2img(rays_x,rays_y,width,Npixels)
% rays2img - Simulates the operation of a camera sensor, where each pixel
% simply collects (i.e., counts) all of the rays that intersect it. The
% image sensor is assumed to be square with 100% fill factor (no dead
% areas) and 100% quantum efficiency (each ray intersecting the sensor is
% collected).
%
% inputs:
% rays_x: A 1 x N vector representing the x position of each ray in meters.
% rays_y: A 1 x N vector representing the y position of each ray in meters.
% width: A scalar that specifies the total width of the image sensor in 
%   meters.
% Npixels: A scalar that specifies the number of pixels along one side of 
%   the square image sensor.
%
% outputs:
% img: An Npixels x Npixels matrix representing a grayscale image captured 
%   by an image sensor with a total Npixels^2 pixels.
% x: A 1 x 2 vector that specifies the x positions of the left and right 
%   edges of the imaging sensor in meters.
% y: A 1 x 2 vector that specifies the y positions of the bottom and top 
%   edges of the imaging sensor in meters.
%
% Matthew Lew 11/27/2018
% 11/26/2021 - edited to create grayscale images from a rays_x, rays_y
% vectors
% 11/9/2022 - updated to fix axis flipping created by histcounts2()

% eliminate rays that are off screen
onScreen = abs(rays_x)<width/2 & abs(rays_y)<width/2;
x_in = rays_x(onScreen);
y_in = rays_y(onScreen);

% separate screen into pixels, calculate coordinates of each pixel's edges
mPerPx = width/Npixels;
Xedges = ((1:Npixels+1)-(1+Npixels+1)/2)*mPerPx;
Yedges = ((1:Npixels+1)-(1+Npixels+1)/2)*mPerPx;

% count rays at each pixel within the image
img = histcounts2(y_in,x_in,Yedges,Xedges);    % histcounts2 for some reason assigns x to rows, y to columns


% rescale img to uint8 dynamic range
img = uint8(round(img/max(img(:)) * 255));
x = Xedges([1 end]);
y = Yedges([1 end]);

% figure;
% image(x_edges([1 end]),y_edges([1 end]),img); axis image xy;
end