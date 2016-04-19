function [pd,h] = discrete_optimal_transport(cp,face,uv,sigma,delta,h,option)
% Discrete Optimal Transport
% 
% cp: convex polytope
% uv: k distinc points in R^2
% sima: source meature on uv
% delta: target measure, k positive scaler s.t. sum(delta) = \int_uv{sigma}
% h: initial translation, can be empty. useful to continue previous computing
% option: options of algorithm, can be empty
%     option.eps: 
%     option.max_iter: max number of iterations

np = size(uv,1);
if ~exist('h','var') || isempty(h)
    h = zeros(np,1);
end
if ~exist('option','var') || ~isfield(option,'max_iter') 
    option.max_iter = 100;
end
if ~exist('option','var') || ~isfield(option,'eps')
    option.eps = 1e-5;
end

pd = power_diagram(face,uv,h);
k = 1;
tic;
while k < option.max_iter
    G = calculate_gradient(cp,pd,sigma);    
    D = G - delta;
    H = calculate_hessian(cp,pd,sigma);
    
    H(1,1) = H(1,1)+1;
    dh = H\D;
    if ~all(isfinite(dh))        
        error(['ERROR: |dh| goes infinite, most probably due to convexhull '...
            'failing, which is due to some cell(s) disappear. Real reason '...
            'is mesh quality/measure is too bad']);
    end
    dh = dh - mean(dh);
    dh = dh - mean(dh);
    
    str = sprintf('#%02d: max|dh| = %.10f',k,max(abs(dh)));
    disp(str);
    if max(abs(dh)) < option.eps
        break
    end
    
    [pd,h] = power_diagram(face,uv,h,dh);
    k = k+1;
end
toc;
