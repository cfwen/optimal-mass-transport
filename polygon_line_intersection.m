function p = polygon_line_intersection(poly,li)
% detect the intersection of a polygon and a line
% polygon is represented as [x1,y1;x2,y2;...,xn,yn] in ccw order
% line is represented as [x1,y1;x2,y2] which determines a line by two
% points (x1,y1) and (x2,y2), at least one of which is assumed inside the
% polygon. If both inside the polygon, return empty
p = [];
k = 0;
for i = 1:size(poly,1)-1
    p1 = line_line_intersection(poly(i:i+1,:),li);
    if ~isempty(p1)
        p = [p;p1];
        k = k+1;
        if k == 2
            return;
        end
    end
end