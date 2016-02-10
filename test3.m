%% need three package
addpath(genpath('../library/geom2d/'))
addpath('../library/polybool_clipper/')
addpath(genpath('../geometry-processing-package/'))
%%
[face,vertex,extra] = read_mfile('ASD1.final_uv.m');
uv = extra.Vertex_uv;
marker = [666,1889,9682];
uv = make_face_upright(uv,marker);
uv = uv*sqrt(pi/sum(vertex_area(face,uv)/3)); % make disk area to be pi
bd = compute_bd(face);
va = vertex_area(face,vertex)/3; % vertex area of 3d surface
% va = va/sum(va)*pi; % sum(va) == pi

va0 = vertex_area(face,uv)/3;
mu = va./va0;
mu = mu/sum(va)*pi;
%%
[face2,vertex2,extra2] = read_mfile('ASD2.final_uv.m');
uv2 = extra2.Vertex_uv;
marker2 = [2760,9163,5666];
uv2 = make_face_upright(uv2,marker2);
uv2 = uv2*sqrt(pi/sum(vertex_area(face2,uv2)/3)); % make disk area to be pi
bd2 = compute_bd(face2);
va2 = vertex_area(face2,vertex2)/3; % vertex area of 3d surface
% va2 = va2/sum(va2)*pi; % sum(va) == pi

va20 = vertex_area(face2,uv2)/3;
mu2 = va2./va20;
mu2 = mu2/sum(va2)*pi;

F = scatteredInterpolant(uv2(:,1),uv2(:,2),mu2);
mu1 = F(uv(:,1),uv(:,2));
mu1 = mu1/sum(va);
mu1 = mu1/sum(mu1.*va0)*pi;

%% initial power diagram
pd0 = power_diagram(face,uv,zeros(size(uv,1),1));

% compute power diagram with desired area
% uv(bd,:) is the unit circle
disk = uv(bd,:);
mu0 = ones(size(mu));
[pd,h] = discrete_optimal_transport(disk,face,uv,mu0*0.5,ones(size(va))/size(va,1)*pi*0.5);

% centroid of power diagram cell, as new position of uv
% the boundary of uv_new has moved, so you might need to label some points
% to remember your match on original mesh
uv_new = compute_centroid(disk,pd,bd);