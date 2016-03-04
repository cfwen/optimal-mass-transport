function face_new = repair_mesh(face)
% repair mesh to eliminate "ear" vertices of valence 2
fring = compute_face_ring(face);
frl = sum(fring~=-1,2);
I = find(frl==1);
face_new = face;
for i = I'
    f = face(i,:);
    fri = fring(i,:);
    fri(fri==-1) = [];
    f2 = face(fri,:);
    j = setdiff(f,f2);
    l = setdiff(f2,f);
    jnd = find(f==j);
    f = f([jnd:end,1:jnd-1]);
    lnd = find(f2==l);
    f2 = f2([lnd:end,1:lnd-1]);
    f(3) = l;
    f2(3) = j;
    face_new(i,:) = f;
    face_new(fri,:) = f2;
end