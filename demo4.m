% given two surfaces, map source measure to target measure. This is the 
% most general application of optimal mass transport. In this demo, we use
% conformal factor as source measure, target measure is target surface's 
% area. So essentially we map source surface's area to target's surface's 
% area. 
% 
% Make sure uv of two meshes are properly aligned. Conformal
% parameterization can be up to a Mobius transformation. Hence even two
% meshes are aligned in 3D space, uv can be very different. Use unaligned
% uv may produce some result, but it can be meaningless, especially the
% wasserstein distance is not correct. This is the problem of conformal
% parameterization (non unique). You need to specific three corresponding
% points on surface to eliminate this ambiguity.

% need comformal parameterization
[face,vertex,extra] = read_mfile('data/alex.idrf.uv.m');
uv = extra.Vertex_uv;

va0 = vertex_area(face,uv)/3;
uv = uv*sqrt(pi/sum(va0)); % make disk area to be pi
va0 = vertex_area(face,uv)/3;
va = vertex_area(face,vertex)/3; % vertex area of 3d surface
va = va/sum(va)*pi; % sum(va) == pi
sigma = scatteredInterpolant(uv,va./va0);

[face2,vertex2,extra2] = read_mfile('data/sophie.idrf.uv.m');
uv2 = extra2.Vertex_uv;

va20 = vertex_area(face2,uv2)/3;
uv2 = uv2*sqrt(pi/sum(va20));
va20 = vertex_area(face2,uv2)/3;
va2 = vertex_area(face2,vertex2)/3; % vertex area of 3d surface
va2 = va2/sum(va2)*pi; % sum(va) == pi
delta = va2;

bd2 = compute_bd(face2);
disk2 = uv2(bd2,:);
%%
% initial power diagram
pd = power_diagram(face2,uv2);

% we work on target, source mesh only provides a background measure. OMT maps
% this source measure to target discrete measure.
[pd2,h] = discrete_optimal_transport(disk2,face2,uv2,sigma,delta);

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
