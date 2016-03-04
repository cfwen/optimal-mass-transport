function [pd,h] = discrete_optimal_transport(cp,face,uv,mu,F)
% Discrete Optimal Transport
% cp: convex polytope
% uv: k distinc points in R^n
% mu: target measure, k positive scaler s.t. sum(mu) = \int_uv{F}
% F: source meature on uv
np = size(uv,1);
h = zeros(np,1);
pd = power_diagram(face,uv,h);
k = 1;
tic;
while true
    G = calculate_gradient(cp,pd,F);    
    D = G-mu;
    H = calculate_hessian(cp,pd,F);
    H = (H+H')/2;
    H(1,1) = H(1,1)+1;
    dh = H\D;
    if ~all(isfinite(dh))
        save discrete_optimal_transport
%         pause
    end
    dh = dh - mean(dh);
    dh = dh - mean(dh);
    
    str = sprintf('#%02d: max|dh| = %.10f',k,max(abs(dh)));
    disp(str);
    if max(abs(dh)) < 1e-4
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