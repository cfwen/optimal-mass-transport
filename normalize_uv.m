function uv = normalize_uv(face,vertex,uv,bp)
%% scale uv to be unit circle
if isreal(uv)
    z = uv(:,1)+1i*uv(:,2);
else
    z = uv;
end
fa = face_area(face,z);
z = z./sqrt(sum(fa)/pi);
bd = compute_bd(face);
z(bd) = z(bd)./abs(z(bd));

%% minimize area distortion by composing a mobius transformation
z = minimize_area_distortion(face,vertex,z);

%% move bp to 1
z = exp(-1i*(angle(z(bp))))*z;

if isreal(uv)
    uv = [real(z),imag(z)];
else
    uv = z;
end