function [pd,h] = discrete_optimal_transport(cp,face,uv,delta,sigma,h,K)
% Discrete Optimal Transport
% cp: convex polytope
% uv: k distinc points in R^n
% delta: target measure, k positive scaler s.t. sum(delta) = \int_uv{sigma}
% sima: source meature on uv
np = size(uv,1);
if ~exist('h','var') || isempty(h)
    h = zeros(np,1);
end
pd = power_diagram(face,uv,h);
k = 1;
if ~exist('K','var')
    K = 100;
end
tic;
while k<K
    G = calculate_gradient(cp,pd,sigma);    
    D = G - delta;
    H = calculate_hessian(cp,pd,sigma);
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
    if max(abs(dh)) < 1e-5
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
