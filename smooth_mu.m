function mu_new = smooth_mu(face,vertex,mu,K)

va = vertex_area(face,vertex);
vr = compute_vertex_ring(face,vertex);
if ~exist('K','var')
    K = 10;
end
mu_new = mu;
for k =1:K
    for i = 1:size(vertex,1)
        vri = vr{i};
        mu_new(i) = (sum(va(vri).*mu(vri)))/sum(va(vri));
    end
end