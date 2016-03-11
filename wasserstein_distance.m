function wd = wasserstein_distance(cp,pd,sigma)

T = pd.uv;
nc = size(pd.cell,1);
wd = zeros(nc,1);

in = true(nc,1);
in2 = inpolygon(pd.dpe(:,1),pd.dpe(:,2),cp(:,1),cp(:,2));
% find out cells not in cp completely
for i = 1:nc
    ci = pd.cell{i};
    if ~all(in2(ci))
        in(i) = false;
    end
end
cp(end,:) = [];
dpe = pd.dpe;
pdc = pd.cell;
for i = 1:nc
    ci = dpe(pdc{i},:);
    if ~in(i)
        pc = polybool([cp(:,1),cp(:,2)],[ci(:,1),ci(:,2)],'and');
        ci = pc{1};
        ci = ci([1:end,1],:);
    end
    p0 = mean(ci(1:end-1,:));    
    for j = 1:length(ci)-1        
        wd(i) = wd(i) + wdt(p0,ci(j,:),ci(j+1,:),T(i,:),sigma);
    end      
end
wd = sqrt(sum(wd));

function d = wdt(p1,p2,p3,pt,sigma)
% integration on triangle (p1,p2,p3), target position is pt, source measure
% is sigma
f = @(x) sum((x-pt).*(x-pt));
fl = @(l1,l2,l3) f(l1.*p1+l2.*p2+l3.*p3);
S = face_area([1 2 3],[p1;p2;p3]);
sp = sigma([p1;p2;p3]);
d = fl(2/3,1/6,1/6).*dot([2/3,1/6,1/6],sp) + fl(1/6,2/3,1/6).*dot([1/6,2/3,1/6],sp) + fl(1/6,1/6,2/3).*dot([1/6,1/6,2/3],sp);
d = d*S/3;