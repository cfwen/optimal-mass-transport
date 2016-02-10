function pd = power_diagram(point,h)

% lift point to a higher dim hyperbola
pl = [point,dot(point,point,2)-h];

face = convhull(pl);
% use face normal to filter out "upper" face, to get so-called upper
% envelop 
[fn,fa] = calculate_face_normal(face,pl);
ind = fn(:,3)<0;
face = face(ind,:);

M = Mesh(face,pl);
% vfr = compute_vertex_face_ring(face);
vr = M.ComputeVertexRing();
% pd = cell(size(p,1),1);
ind = false(size(point,1),1);
pd.point = point;
pd.dp = zeros(size(face,1),2);
pd.cell = cell(size(pl,1),1);
for i = 1:size(face,1)
    dp = face_dual_point(pl(face(i,:),:));
    pd.dp(i,:) = dp;
end
K = convhull(point);
vb = zeros(size(K,1)-1,2);
mindp = min(pd.dual_point)-1;
maxdp = max(pd.dual_point)+1;
minx = mindp(1);
miny = mindp(2);
maxx = maxdp(1);
maxy = maxdp(2);
box = [minx,miny;maxx,miny;maxx,maxy;minx,maxy;minx,miny];
% box = [min(pd.dp)-1,max(pd.dp)+1];
for i = 1:size(K,1)-1
    i1 = K(i);
    i2 = K(i+1);
    vec = point(i1,:)-point(i2,:);
    ip = polygon_line_intersection(box,[vec,dot(point(i2,:),point(i2,:))/2-dot(point(i1,:),point(i1,:))/2]);
    if det([1,point(i1,:);1,point(i2,:);1,ip(1,:)])<0
        vb(i,:) = ip(1,:);
    else
        vb(i,:) = ip(2,:);
    end
end
pd.dpe = [pd.dp;vb;];
for i = 1:size(point,1)
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
            fr(j+1) = M.VViF(i,vri(j));
        end
    else
        fr = zeros(size(vri));
        for j = 1:length(vri)
            fr(j) = M.VViF(i,vri(j));
        end
    end
    pd.cell{i} = fr(end:-1:1);
end
return
% for i = 1:size(p,1)
%         if ~ind(i)
%             ind(i) = true;
%         end
% %         vfi = vfr{i};
%         vri = vr{i};
%         pi = [];
%         last = NaN;
%         dd = [1 1];
%         for j = 1:length(vri)
%             fj = M.VViF(i,vri(j));
%             if fj == 0
%                 break;
%             end
%             dp = face_dual_point(pl(face(fj,:),:));
% %             dp = face_dual_point(pl([i,vri(j:j+1)],:));
% 
%             if ~isnan(last)
%                 dd = last - dp;
%             end
%             if norm(dd) > eps
%                 pi = [pi;dp];
%                 last = dp;
%             end
%         end
% 	pd{i} = pi;
% end

function dp = face_dual_point(p)
% dual point of a triangle face
a=p(1,2)*(p(2,3)-p(3,3))+p(2,2)*(p(3,3)-p(1,3))+p(3,2)*(p(1,3)-p(2,3));
b=p(1,3)*(p(2,1)-p(3,1))+p(2,3)*(p(3,1)-p(1,1))+p(3,3)*(p(1,1)-p(2,1));
c=p(1,1)*(p(2,2)-p(3,2))+p(2,1)*(p(3,2)-p(1,2))+p(3,1)*(p(1,2)-p(2,2));
% d=-1*(p(1,1)*(p(2,2)*p(3,3)-p(3,2)*p(2,3))+p(2,1)*(p(3,2)*p(1,3)-p(1,2)*p(3,3))+p(3,1)*(p(1,2)*p(2,3)-p(2,2)*p(1,3)));	
dp = [-a/c/2, -b/c/2];

function p = rect_line_intersection(rect,line)
% calculate the intersection of a rectangle and a line
% rectangle is represented as [minx,miny,maxx,maxy]
% line is represented as [a,b,c], which is ax+by+c=0
% there are two intersection points returned
a = line(1);
b = line(2);
c = line(3);
x1 = rect(1);
y1 = rect(2);
x2 = rect(3);
y2 = rect(4);
if a == 0
    p = [x1,-c/b;x2,-c/b];
    return
end
if b == 0
    p = [-c/a,y1;-c/a,y2];
    return
end
y = -(a*x1+c)/b;
if y>y2
    y = y2;
elseif y<y1
    y = y1;
end
p1 = [-(b*y+c)/a,y];
y = -(a*x2+c)/b;
if y>y2
    y = y2;
elseif y<y1
    y = y1;
end
p2 = [-(b*y+c)/a,y];
p = [p1;p2];



% function p = line_line_intersection(l1,l2)
% p1 = l1(1,:);
% p2 = l1(2,:);
% p3 = l2(1,:);
% p4 = l2(2,:);
% A = [y1-y2,x2-x1;y3-y4,x4-x3];
% b = [x2*y1-x1*y2;x4*y3-x3*y4];
% if rank(A) == 2
%     p = (A\b)';
% end
% if (norm(p-p1)/norm(p1-p2) > 1 || norm(p-p2)/norm(p1-p2) > 1) || ...
%    (norm(p-p3)/norm(p3-p4) > 1 || norm(p-p4)/norm(p3-p4) > 1)
%     p = [];
% end

