function vk = compute_vertex_curvature(face,vertex)
% calculate vertex curvature
bd = compute_bd(face);
nv = size(vertex,1);
vk = ones(nv,1)*pi*2;
vk(bd) = pi;
ca = calculate_corner_angle(face,vertex);
vk = vk - accumarray(face(:),ca(:));

function ca = calculate_corner_angle(face,vertex)
ca = zeros(size(face));
dei = vertex(face(:,2),:) - vertex(face(:,3),:);
dej = vertex(face(:,3),:) - vertex(face(:,1),:);
dek = vertex(face(:,1),:) - vertex(face(:,2),:);
eli = sqrt(dot(dei,dei,2));
elj = sqrt(dot(dej,dej,2));
elk = sqrt(dot(dek,dek,2));
ca(:,1) = cosine_law(eli, elj, elk);
ca(:,2) = cosine_law(elj, elk, eli);
ca(:,3) = cosine_law(elk, eli, elj);

function cs = cosine_law(li, lj, lk)
cs = (lj.*lj+lk.*lk-li.*li)./(2*lj.*lk);
cs = acos(cs);
