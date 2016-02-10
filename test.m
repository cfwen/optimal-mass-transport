% addpath(genpath('../library/geom2d/'))
% create some random points in unit circle
v = rand(5000,2)*2-1;
in = dot(v,v,2)<0.99;
uv = v(in,:);
% create unit circle
t = 0:2*pi/180:2*pi;
t(end) = [];
disk = [cos(t);sin(t)]';
uv = [uv;disk];
face = delaunay(uv);
bd = compute_bd(face);
disk = uv(bd,:);
% set area to be equal in all cells
area = polyarea(disk(:,1),disk(:,2))*ones(size(uv,1),1)/size(uv,1);

% initial power diagram
pd0 = power_diagram(face,uv,zeros(size(uv,1),1));

% compute power diagram with desired area
mu = ones(size(area,1),1);
[pd,h] = discrete_optimal_transport(disk,face,uv,mu,area);

%% plot result
figure
plot_power_diagram(pd0);
title('initial power diagram');
hold on
plot(disk(:,1),disk(:,2),'r-');
axis([-1 1 -1 1]);
figure;
plot_power_diagram(pd);
title('final power diagram');
hold on
plot(disk(:,1),disk(:,2),'r-');
axis([-1 1 -1 1]);