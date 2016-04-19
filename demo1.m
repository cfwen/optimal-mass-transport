% given initial voronoi diagram, map it to a new voronoi diagram with
% prescribed area

% generate some random points in unit circle
v = rand(5000,2)*2-1;
in = dot(v,v,2)<0.99;
uv = v(in,:);
% create unit circle
t = 0:2*pi/180:2*pi;
t(end) = [];
disk = [cos(t);sin(t)]';
% initial uv and face
uv = [uv;disk];
face = delaunay(uv);
% unit disk, as the boundary
bd = compute_bd(face);
disk = uv(bd,:);

% set area to be equal in all cells
nc = size(uv,1);
% target measure(area). Theorecticly it can be anything as long as the
% total measure/area is equal to source's total measure. However we live in
% discrete space, badly distributed target measure can be a problem:
% convergence rate decreased or even algorithm fail. Use meaningful measure.
% 
% area of unit circle is pi, however, since we approximate boundary with
% piecewise segments, its total area may be slightly less than pi, so we
% compute the area directly.
area = polyarea(disk(:,1),disk(:,2))*ones(nc,1)/nc;

%% initial power diagram
pd = power_diagram(face,uv);

% compute power diagram with desired area
% sigma is the soure measure, set to be constant 1
sigma = @(xy) 1; 
% pd2's cells all have equal area
[pd2,h] = discrete_optimal_transport(disk,face,uv,sigma,area);

%% plot result
figure
plot_power_diagram(pd);
title('initial power diagram');
hold on
plot(disk(:,1),disk(:,2),'r-');
axis([-1 1 -1 1]);
figure;
plot_power_diagram(pd2);
title('final power diagram');
hold on
plot(disk(:,1),disk(:,2),'r-');
axis([-1 1 -1 1]);