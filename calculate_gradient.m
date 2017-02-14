function D = calculate_gradient(cp,pd,sigma,more_accurate)
% gradient is the area of cells, parts inside the given polygon cp

% if need more accurate, cell area will be calculated triangle by triangle,
% otherwise a approximation method will be used
if ~exist('more_accurate','var')
    more_accurate = false;
end

nc = size(pd.cell,1);
D = zeros(nc,1);

in = true(nc,1);
in2 = inpolygon(pd.dpe(:,1),pd.dpe(:,2),cp(:,1),cp(:,2));
% find out cells not in cp completely
for i = 1:nc
    ci = pd.cell{i};
    if ~all(in2(ci))
        in(i) = false;
    end
end
cp(end,:) = [];
for i = 1:nc
    ci = pd.dpe(pd.cell{i},:);
    
    if more_accurate
        if ~in(i)
            pc = polybool([cp(:,1),cp(:,2)],[ci(:,1),ci(:,2)],'and');
            ci = pc{1};
            ci = ci([1:end,1],:);
        end
        
        p0 = mean(ci(1:end-1,:));
        for j = 1:length(ci)-1
            p1 = ci(j,:);
            p2 = ci(j+1,:);
            D(i) = D(i) + face_area([1,2,3],[p0;p1;p2])*sigma(mean([p0;p1;p2]));
        end
    end
    
    if in(i)
        ci = ci(1:end-1,:);
        mui = (2*mean(sigma(ci))+sigma(mean(ci)))/3;
        D(i) = polyarea({ci})*mui;
    else % if cell's part outside cp
        try
            pc = polybool([cp(:,1),cp(:,2)],[ci(:,1),ci(:,2)],'and');
            xy = pc{1};
            mui = (2*mean(sigma(xy))+sigma(mean(xy)))/3;
            D(i) = polyarea({xy})*mui;
        catch ex
            D(i) = 0;
            warning('occured when computing polygon intersection, most probably this cell went out of prescibed boundary')
        end        
    end
end