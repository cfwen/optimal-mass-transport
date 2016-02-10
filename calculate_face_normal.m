function [fn,fa] = calculate_face_normal(face,vertex)
x = vertex(face(:,2),:)-vertex(face(:,1),:);
y = vertex(face(:,3),:)-vertex(face(:,1),:);
fn = cross(x,y,2);
fa = sqrt(dot(fn,fn,2));
fn(:,1) = fn(:,1)./fa;
fn(:,2) = fn(:,2)./fa;
fn(:,3) = fn(:,3)./fa;