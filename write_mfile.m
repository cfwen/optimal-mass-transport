function write_mfile(filename,varargin)
mode = 'w';
for i = 1:length(varargin)
    if  strcmp(varargin{i}, 'mode')
        mode = varargin{i+1};
        break;
    end
end
if isempty(regexp(filename,'\.m$','match'))
    filename = [filename '.m'];
end
fid = fopen(filename,mode);
face = [];
vertex = [];
edge = [];
for i = 1:length(varargin)
    if isa(varargin{i},'double') 
        continue;
    end
    if ~isempty(regexp(varargin{i},'^[Vv]ertex','match'))
        vertex = varargin{i+1};
        vertex_format = varargin{i};
        if strcmp(varargin{i},'Vertex')
            vertex_format = 'Vertex %d %.10f %.10f %.10f\n';
        end
    end
    if ~isempty(regexp(varargin{i},'[Ff]ace','match'))
        face = varargin{i+1};
        face_format = varargin{i};
        if strcmp(varargin{i}, 'Face')
            face_format = 'Face %d %d %d %d\n';
        end
    end
    if ~isempty(regexp(varargin{i},'[Ee]dge','match'))
        edge = varargin{i+1};
        edge_format = varargin{i};
        if strcmp(varargin{i}, 'Edge')
            edge_format = 'Edge %d %d {sharp}\n';
        end
    end
end
vertex_index = (1:size(vertex,1))';
face_index = (1:size(face,1))';
if ~isempty(vertex)
    fprintf(fid,vertex_format,[vertex_index,vertex]');
end
if ~isempty(face) 
    fprintf(fid,face_format,[face_index,face]');
end
if ~isempty(edge)
    fprintf(fid,edge_format,edge');
end
fclose(fid);