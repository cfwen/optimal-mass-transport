% given initial voronoi diagram, map it to a new voronoi diagram with
% prescribed area. Domain is a square.

% generate some random points in square [-1 1]x[-1 1]
uv = (rand(5000,2)*2-1)*0.98; % not too close to boundary
% square = [-1 -1;1 -1;1 1;-1 1];
s = (-1:0.05:0.99)';
s2 = (1:-0.05:-0.99)';
o = ones(size(s));
square = [s,-o;o,s;s2,o;-o,s2];
uv = [uv;square];
face = delaunay(uv);
% map boundary points to square
% uv = rect_map(face,uv,[[c1;c2;c3;c4],square]);
bd = compute_bd(face);
square = uv(bd,:);
% set area to be equal in all cells
nc = size(uv,1);
% total area is 4
% area = polyarea(square(:,1),square(:,2))*ones(nc,1)/nc;
area = 4/nc*ones(nc,1);

%% initial power diagram
pd = power_diagram(face,uv);

% compute power diagram with desired area
% sigma is the soure measure, set to be constant 1
sigma = @(xy) 1; 
% pd2's cells all have equal area
[pd2,h] = discrete_optimal_transport(square,face,uv,sigma,area);

%% plot result
figure('Position',[549 346 1102 476],'Color',[1 1 1])
subplot(1,2,1)
plot_power_diagram(pd);
title('initial power diagram');
hold on
plot(square(:,1),square(:,2),'r-');
axis([-1 1 -1 1]);
axis off
subplot(1,2,2)
plot_power_diagram(pd2);
title('final power diagram');
hold on
plot(square(:,1),square(:,2),'r-');
axis([-1 1 -1 1]);
axis off