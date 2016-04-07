function [pd,h] = power_diagram(face,uv,h,dh)
if ~exist('dh','var')
    dh = h*0;
end
% lift uv to a higher dim hyperbola
nf = size(face,1);
c = 1;
while true
    h = h - c*dh;
    pl = [uv,dot(uv,uv,2)-h];
    K = convhull(pl);
    fn = calculate_face_normal(K,pl);
    ind = fn(:,3)<0;
    if sum(ind) < nf
        h = h + c*dh;
        c = c/2;
    else
        break;
    end    
end
face = convhull(pl);
% use face normal to remove "upper" face, to get so-called upper
% envelop
fn = calculate_face_normal(face,pl);
ind = fn(:,3)<0;
face = face(ind,:);
pd.face = face;
vr = compute_vertex_ring(face,uv,[],true);
pd.uv = uv;
pd.dp = zeros(size(face,1),2);
pd.cell = cell(size(pl,1),1);
for i = 1:size(face,1)
    dp = face_dual_uv(pl(face(i,:),:));
    pd.dp(i,:) = dp;
end
K = convhull(uv);
vb = zeros(size(K,1)-1,2);
mindp = min(pd.dp)-1;
maxdp = max(pd.dp)+1;
minx = mindp(1);
miny = mindp(2);
maxx = maxdp(1);
maxy = maxdp(2);
box = [minx,miny;maxx,miny;maxx,maxy;minx,maxy;minx,miny];

for i = 1:size(K,1)-1
    i1 = K(i);
    i2 = K(i+1);
    vec = uv(i2,:) - uv(i1,:);
    vec = [vec(2), -vec(1)];
    mid = (uv(i2,:) + uv(i1,:))/2;
    intersects = intersectRayPolygon([mid,vec], box);
    vb(i,:) = intersects(1,:);
end
pd.dpe = [pd.dp;vb];
vvif = compute_connectivity(face);
for i = 1:size(uv,1)
    vri = vr{i};
    pb = find(K==i,1,'first');
    if pb
        fr = zeros(1,length(vri)+1);
        fr(end) = size(face,1)+pb;
        if pb == 1
            fr(1) = size(face,1)+size(K,1)-1;
        else
            fr(1) = size(face,1)+pb-1;
        end
        for j = 1:length(vri)-1
            fr(j+1) = vvif(i,vri(j));
        end
    else
        fr = zeros(size(vri));
        for j = 1:length(vri)
            fr(j) = vvif(i,vri(j));
        end
    end
    pd.cell{i} = fr(end:-1:1);
end


function dp = face_dual_uv(p)
% dual uv of a triangle face
a=p(1,2)*(p(2,3)-p(3,3))+p(2,2)*(p(3,3)-p(1,3))+p(3,2)*(p(1,3)-p(2,3));
b=p(1,3)*(p(2,1)-p(3,1))+p(2,3)*(p(3,1)-p(1,1))+p(3,3)*(p(1,1)-p(2,1));
c=p(1,1)*(p(2,2)-p(3,2))+p(2,1)*(p(3,2)-p(1,2))+p(3,1)*(p(1,2)-p(2,2));
% d=-1*(p(1,1)*(p(2,2)*p(3,3)-p(3,2)*p(2,3))+p(2,1)*(p(3,2)*p(1,3)-p(1,2)*p(3,3))+p(3,1)*(p(1,2)*p(2,3)-p(2,2)*p(1,3)));
dp = [-a/c/2, -b/c/2];