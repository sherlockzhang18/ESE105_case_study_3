clc;
clearvars;
close all;
% *******************************************************************
d1 = 0.2;
f = 0.1;
d2 = f*d1/(d1-f);
n = 8;
lens_r = 0.02;

angles = linspace(pi/20,-pi/20,8);

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

for i = 1:n
    rays_in(:,i) = [0;angles(i);0;0];
end

rays_out = M_d1*rays_in;

% rays_in is a 4 x N matrix representing the rays emitted from an object
% rays_out is a 4 x N matrix representing the rays after propagating distance d
ray_z = [zeros(1,size(rays_in,2)); d1*ones(1,size(rays_in,2))];
plot(ray_z, [rays_in(1,:); rays_out(1,:)],'color',[0.9,0.5,0.4]);
hold on;

ray_z = [d1*ones(1,2); (d1+d2)*ones(1,2)];
for i = 1:n
    % check if rays goes through the lens
    if abs(rays_out(1,i)) <= lens_r
        rays_through_lens = M_f * rays_out(:,i);
        rays_after_lens = M_d2 * rays_through_lens;

        plot(ray_z, [rays_out(1,i); rays_after_lens(1)],'color',[0.9,0.5,0.4]);
    end
end

% *******************************************************************
% second set of rays
for i = 1:n
    % Set the rays_in for the green rays with origion at x = 0.01
    rays_in(:,i) = [0.01;angles(i);0;0];
end
% set rays_out and plot the first half og the rays
rays_out = M_d1 * rays_in;
ray_z = [zeros(1,size(rays_in,2)); d1*ones(1,size(rays_in,2))];
plot(ray_z, [rays_in(1,:); rays_out(1,:)],"color",[0.2,0.5,0.1]);

ray_z = [d1*ones(1,2); (d1+d2)*ones(1,2)];
for i = 1:n
    % check if rays goes through the lens
    if abs(rays_out(1,i)) <= lens_r
        rays_through_lens = M_f * rays_out(:,i);
        rays_after_lens = M_d2 * rays_through_lens;
        % We can see that these green rays starts at x= 0.01 and converges at x=-0.01 
        plot(ray_z, [rays_out(1,i); rays_after_lens(1)],'color',[0.2,0.5,0.1]);
    end
end

% *******************************************************************
% draw the little oval to represent the lens
w = 0.005;
h = 2*lens_r;
pos = [d1 - w/2, -lens_r, w, h];
rectangle('Position', pos, 'Curvature', [1,1]);
