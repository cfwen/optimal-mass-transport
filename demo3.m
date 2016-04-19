% given a surface, compute a area preserving map to unit disk

[face,vertex] = read_off('data/alex.off');
uv = disk_harmonic_map(face,vertex);

% target area equal to area on original surface
area = vertex_area(face,vertex)/3;
% normalize area, total area should be total area of unit disk (may not be
% exactly pi). THIS IS IMPORTANT. This demo will fail if you remove
% following two lines.
va2 = vertex_area(face,uv)/3;
area = area/sum(area)*sum(va2);

bd = compute_bd(face);
disk = uv(bd,:);
% make sure disk is really a disk
dl = sqrt(dot(disk,disk,2));
disk = disk./[dl dl];

%% initial power diagram
pd = power_diagram(face,uv);

% compute power diagram with desired area
% sigma is the soure measure, set to be constant 1
sigma = @(xy) 1; 
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

%% save result to mfile. View data/alex.omt.m with texture to see area preserving map
uv_new = compute_centroid(disk,pd2);
write_mfile('data/alex.omt.m','Face',face,'Vertex %d %f %f %f {uv=(%f %f)}\n',[vertex,uv_new]);
% as comparision, view texture with harmonic uv
write_mfile('data/alex.harmonic.m','Face',face,'Vertex %d %f %f %f {uv=(%f %f)}\n',[vertex,uv]);
