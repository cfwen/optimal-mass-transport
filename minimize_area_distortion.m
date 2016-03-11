function uv = minimize_area_distortion(face,vertex,uv)
nv = size(vertex,1);
if isreal(uv)
    z = uv(:,1)+1i*uv(:,2);
else
    z = uv;
end
fa = face_area(face,vertex);
fa = fa/sum(fa)*pi;
bd = compute_bd(face);
in = true(nv,1);
in(bd) = false;
in(abs(z)>0.9) = false;

phi = @(z,z0) (z-z0)./(1-conj(z0)*z);
da = ones(nv,1);
parfor i = 1:nv
    if in(i)
        fa1 = face_area(face,phi(z,z(i)));
        da(i) = dot(fa1-fa,fa1-fa);
    end
end
[m,i] = min(da);
z = phi(z,z(i));
if isreal(uv)
    uv = [real(z),imag(z)];
else
    uv = z;
end