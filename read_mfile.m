function [face,vertex,extra] = read_mfile(filename)

if isempty(regexp(filename,'\.m$','match'))
    filename = [filename '.m'];
end
fid = fopen(filename);
if fid<0
    error('Unable to open file.');
end

while true
    line = fgets(fid);
    if line(1) == '#'
        continue;
    end
    if ~ischar(line)
        break;
    end
    [type,sz,format] = get_format(line);
    fseek(fid,-length(line),'cof');
    A = fscanf(fid,format);
    m = uint32(sum(sz));
    n = uint32(length(A)/m);
    if m*n ~= length(A)
        error('There must be something wrong, I read incomplete mesh data.');
    end
    A = reshape(A,m,n)';
    l = 1;
    for i = 1:length(sz)
        r = sum(sz(1:i));
        extra.(type{i}) = A(:,l:r);
        l = r+1;
    end
end
face4 = extra.('Face');
face = face4(:,2:4);
vertex4 = extra.('Vertex');
vertex = vertex4(:,2:4);
% edge = compute_edges(face)';
ind(vertex4(:,1)) = (1:size(vertex4,1))';
face = ind(face);
fclose(fid);

function [type,sz,format] = get_format(str)
sn = '[\-+]?(?:\d*\.|)\d+(?:[eE][\-+]?\d+|)';
format = regexprep(str,sn,'%f');
% format = regexprep(str,'[\d\.-]*','%f');
[type,~] = regexp(str,'[a-zA-Z=]{2,}','match','split');
for i = 2:length(type)
    type{i} = [type{1} '_' type{i}(1:end-1)];
end
[~,splitstr] = regexp(str,sn,'match','split');
k = zeros(size(type));
j = 1;
for i = 1:length(splitstr)
    if sum(splitstr{i}==' ')~=length(splitstr{i})
        k(j) = i;
        j = j+1;
    end
end
sz = diff(k);