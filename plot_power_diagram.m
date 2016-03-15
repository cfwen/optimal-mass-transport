function plot_power_diagram(pd)
gca;
hold on
bd = compute_bd(pd.face);
disk = pd.uv(bd,:);
% uv = compute_centroid(disk,pd,bd);
% [vx,vy] = voronoi(uv(:,1),uv(:,2));
% plot(vx,vy,'b-');
plot(disk(:,1),disk(:,2),'r.-')
for i = 1:length(pd.cell)
    pi = pd.dpe(pd.cell{i},:);
%     plot3(pi(:,1),pi(:,2),-ones(size(pi(:,1))),'r-')
    plot(pi(:,1),pi(:,2),'b-');
end
% plot(pd.uv(:,1),pd.uv(:,2),'r.')
box = [min(pd.uv(:,1)),max(pd.uv(:,1)),min(pd.uv(:,2)),max(pd.uv(:,2))];
axis equal
axis(box);