function uv = disk_authalic_map(face,vertex)
nv = size(vertex,1);
bd = compute_bd(face);
% bl is boundary edge length
db = vertex(bd,:) - vertex(bd([2:end,1]),:);
bl = sqrt(dot(db,db,2));
t = cumsum(bl)/sum(bl)*2*pi;
t = t([end,1:end-1]);
% use edge length to parameterize boundary
uvbd = [cos(t),sin(t)];
uv = zeros(nv,2);
uv(bd,:) = uvbd;
in = true(nv,1);
in(bd) = false;
A = discrete_authalic_map(face,vertex);
Ain = A(in,in);
rhs = -A(in,bd)*uvbd;
uvin = Ain\rhs;
uv(in,:) = uvin;
