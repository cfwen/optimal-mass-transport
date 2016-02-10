function p = line_line_intersection(lp,li)
% compute intersection of two lines, lp is represented by two points; li is
% represented in implicit form, i.e., ax+by+c=0

p1 = lp(1,:);
p2 = lp(2,:);

if numel(li) == 4
    p3 = li(1,:);
    p4 = li(2,:);
    A = [p1(2)-p2(2),p2(1)-p1(1);p3(2)-p4(2),p4(1)-p3(1)];
    b = [p2(1)*p1(2)-p1(1)*p2(2);p4(1)*p3(2)-p3(1)*p4(2)];
%     if rank(A) == 2
        p = (A\b)';
%     end
    if (norm(p-p1)/norm(p1-p2) > 1 || norm(p-p2)/norm(p1-p2) > 1) || ...
       (norm(p-p3)/norm(p3-p4) > 1 || norm(p-p4)/norm(p3-p4) > 1)
        p = [];
    end
elseif numel(li) == 3
    A = [p1(2)-p2(2),p2(1)-p1(1);li(1),li(2)];
    b = [p2(1)*p1(2)-p1(1)*p2(2);-li(3)];
%     if rank(A) == 2
        p = (A\b)';
%     end
    if (norm(p-p1)/norm(p1-p2) > 1 || norm(p-p2)/norm(p1-p2) > 1)
        p = [];
    end
end