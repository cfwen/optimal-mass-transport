function mu = compute_measure(face,vertex,uv,type)
if exist('type','var') && strcmpi(type,'continuous') % continuous measure
    va = vertex_area(face,vertex)/3; % vertex area of 3d surface
    va = va/sum(va); % sum(va) == pi

    va2 = vertex_area(face,uv)/3;
    uv = uv*sqrt(pi/sum(va2)); % make disk area to be pi
    va2 = vertex_area(face,uv)/3;
    mu = va./va2;
    mu = scatteredInterpolant(uv,mu,'linear');
else % discrete measure
    va = vertex_area(face,vertex)/3; % vertex area of 3d surface
    va = va/sum(va); % sum(va) == pi
    mu = va;
end
