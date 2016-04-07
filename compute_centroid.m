function cc = compute_centroid(cp,pd)
cc = zeros(length(pd.cell),2);
for i = 1:length(pd.cell)
    ci = pd.cell{i};
    di = pd.dpe(ci,:);
    if ci(1) == ci(end)      
        di = di(1:end-1,:);
    end
    pc = polybool([cp(:,1),cp(:,2)],[di(:,1),di(:,2)],'and',[],[],10^10);
    if length(pc) ~= 1
        pause
    end        
    cc(i,:) = centroid(pc{1});
end
