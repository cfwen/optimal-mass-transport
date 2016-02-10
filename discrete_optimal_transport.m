function [pd,h] = discrete_optimal_transport(cp,face,uv,mu,area)
% Discrete Optimal Transport
% cp: convex polytope
% uv: k distinc points in R^n
% area: k positive scaler s.t. sum(area) = vol(cp)

np = size(uv,1);
h = zeros(np,1);
pd = power_diagram(face,uv,h);
k = 1;
tic;
while true
    G = calculate_gradient(cp,pd,mu);
    G = G/sum(G)*sum(area);
    D = G-area;
    H = calculate_hessian(cp,pd,mu);
%     H(1,1) = H(1,1)+1;
    dh = H\D;
    if ~all(isfinite(dh))
        save discrete_optimal_transport
%         pause
    end
    dh = dh - mean(dh);
    
    str = sprintf('#%02d: max|D| = %.16f',k,max(abs(D)));
    disp(str);
    if max(abs(D)) < 1e-5
        break
    end
    
%     cla
%     plot_power_diagram(pd);
%     hold on
%     plot(cp(:,1),cp(:,2),'r-');
%     pause(0.1)
    
    [pd,h] = power_diagram(face,uv,h,dh);
    k = k+1;
end
toc;