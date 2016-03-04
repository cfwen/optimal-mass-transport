function D = calculate_gradient(cp,pd,F)
% gradient is the area of cells, parts inside the given polygon cp
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
%     ci = flipud(ci);    
    if in(i)
        mui = (2*mean(F(ci))+F(mean(ci)))/3;
        D(i) = polyarea(ci(:,1),ci(:,2))*mui;        
    else % if cell's part outside cp
        try
            pc = polybool([cp(:,1),cp(:,2)],[ci(:,1),ci(:,2)],'and');
            xy = pc{1};
            mui = (2*mean(F(xy))+F(mean(xy)))/3;
            D(i) = polyarea(xy(:,1),xy(:,2))*mui;
        catch ex
            save gradient
%             pause
        end        
    end
end