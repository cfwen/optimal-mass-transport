%% need three package
addpath(genpath('../library/geom2d/'))
addpath('../library/polybool_clipper/')
addpath(genpath('../geometry-processing-package/'))
%%
[face,vertex,extra] = read_mfile('alex.idrf.uv.m');
uv = extra.Vertex_uv;
% uv must be in unit cicle, center at (0,0), radius 1
% [face,vertex,extra] = read_mfile('Gorilla.uv.mobius.m');
% [face,vertex,extra] = read_mfile('Armadillo.uv.mobius.m');
% uv = extra.Vertex_uv;
% uv = disk_authalic_map(face,vertex);
% [face,vertex] = read_off('Armadillo.off');
% uv = disk_harmonic_map(face,vertex);
uv = uv*sqrt(pi/sum(vertex_area(face,uv)/3)); % make disk area to be 1
bd = compute_bd(face);
va = vertex_area(face,vertex)/3; % vertex area of 3d surface
va = va/sum(va)*pi; % sum(va) == pi

va0 = vertex_area(face,uv)/3;
va0 = va0/sum(va0)*pi;
% initial power diagram
pd0 = power_diagram(face,uv,zeros(size(uv,1),1));

% compute power diagram with desired area
% uv(bd,:) is the unit circle
disk = uv(bd,:);
mu = ones(size(va,1),1);
[pd,h] = discrete_optimal_transport(disk,face,uv,mu,va);

% centroid of power diagram cell, as new position of uv
% the boundary of uv_new has moved, so you might need to label some points
% to remember your match on original mesh
uv_new = compute_centroid(disk,pd,bd);
% write uv_new to mfile
% write_mfile('Armadillo.omt.uv.m','Face',face,'Vertex %d %f %f %f {uv=(%f %f) }\n',[vertex,uv_new])

%% plot mesh
figure
plot_mesh(face,uv)
title('conformal map from surface to unit disk')
figure
plot_mesh(face,uv_new)
title('area preserving map from surface to unit disk')
%% plot power diagram
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
%%
% figure
% hold on
% for i = 1:length(PD1)
%     pi = PD1{i};
%     pi = [pi;pi(1,:)];
% %     plot3(pi(:,1),pi(:,2),-ones(size(pi(:,1))),'r-')
%     plot(pi(:,1),pi(:,2),'b-');
% end
% axis equal