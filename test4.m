%% need three package
addpath(genpath('../library/geom2d/'))
addpath('../library/polybool_clipper/')
addpath(genpath('../geometry-processing-package/'))
%%
[face,vertex,extra] = read_mfile('data\n1.uv.m');
% [face,vertex,extra] = read_mfile('test_source-2.idrf.uv.m');
uv = extra.Vertex_uv;
% uv must be in unit cicle, center at (0,0), radius 1
% [face,vertex,extra] = read_mfile('Gorilla.uv.mobius.m');
% [face,vertex,extra] = read_mfile('Armadillo.uv.mobius.m');
% uv = extra.Vertex_uv;
% uv = disk_authalic_map(face,vertex);
% [face,vertex] = read_off('Armadillo.off');
% uv = disk_harmonic_map(face,vertex);


va = vertex_area(face,vertex)/3; % vertex area of 3d surface
va = va/sum(va)*pi; % sum(va) == pi

va0 = vertex_area(face,uv)/3;
uv = uv*sqrt(pi/sum(va0)); % make disk area to be pi
va0 = vertex_area(face,uv)/3;
mu = va./va0;
% F = scatteredInterpolant(uv,ones(size(mu)),'natural');
sigma = scatteredInterpolant(uv,mu,'natural');

[face2,vertex2,extra2] = read_mfile('data\e2.uv.m');
% [face2,vertex2,extra2] = read_mfile('test_target.idrf.uv.m');
uv2 = extra2.Vertex_uv;

va20 = vertex_area(face2,uv2)/3;
uv2 = uv2*sqrt(pi/sum(va20));
% z2 = uv2(:,1)+1i*uv2(:,2);
% p0 = z2(365);
% z2 = z2*exp(-1i*angle(p0));
% z2 = (z2+0.2)./(1+0.2*z2);
% z2 = z2*exp(-1i*pi/4);
% uv2 = [real(z2),imag(z2)];
va20 = vertex_area(face2,uv2)/3;
va2 = vertex_area(face2,vertex2)/3; % vertex area of 3d surface
va2 = va2/sum(va2)*pi; % sum(va) == pi
% F = scatteredInterpolant(uv2,va2);
% mu2 = F(uv);
% mu2 = mu2/sum(mu2);
delta2 = va2;

bd2 = compute_bd(face2);
disk2 = uv2(bd2,:);
%%
% initial power diagram
% pd0 = power_diagram(face,uv,zeros(size(uv,1),1));

% compute power diagram with desired area
% uv(bd,:) is the unit circle

% mu3 = ones(size(mu2))/size(mu2,1);
[pd,h] = discrete_optimal_transport(disk2,face2,uv2,delta2,sigma);

% centroid of power diagram cell, as new position of uv
% the boundary of uv_new has moved, so you might need to label some points
% to remember your match on original mesh
% uv_new = compute_centroid(disk,pd,bd);
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