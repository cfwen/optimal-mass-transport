function [face_new,uv_new,pd] = area_preserving_map(face,uv,area,corner)

bd = compute_bd(face);
va = vertex_area(face,uv)/3;
if abs(sum(area)-sum(va))>1e-3 
    error('target area sum must equal to source area sum')
end
cp = uv(bd,:);
sigma = scatteredInterpolant(uv,ones(size(uv,1),1));
delta = area/sum(area)*sum(va);
pd = discrete_optimal_transport(cp,face,uv,delta,sigma);
face_new = pd.face(:,[2 1 3]);
uv_new = compute_centroid(cp,pd);
if exist('corner','var')
    bd = compute_bd(face_new);
    i1 = find(bd == corner(1),1,'first');
    bd = bd([i1:end,1:i1]);
    i1 = find(bd == corner(1),1,'first');
    i2 = find(bd == corner(2),1,'first');
    i3 = find(bd == corner(3),1,'first');
    i4 = find(bd == corner(4),1,'first');
    i0 = find(bd == corner(1),1,'last');
    uv_new(bd(i1:i2),2) = -1;
    uv_new(bd(i2:i3),1) = 1;
    uv_new(bd(i3:i4),2) = 1;
    uv_new(bd(i4:i0),1) = -1;
else
    cbl = sqrt(dot(uv_new(bd,:),uv_new(bd,:),2));
    uv_new(bd,:) = uv_new(bd,:)./[cbl,cbl];
end