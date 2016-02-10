classdef Mesh
    %MESH Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        Face,       nFace
        Vertex,     nVertex
        Edge,       nEdge
        HalfEdge,   nHalfEdge
        Boundary,   nBoundary
        AM, AMD
        ViF
        EiF
        HEiF
        VViF
        NViF
        PViF
    end
    
    methods
        function M = Mesh(Face,Vertex)
            if nargin == 0
                error('Not enough argument!');
            end
            M.Face = Face;
            M.nFace = size(M.Face,1);
            M.Vertex = Vertex;
            M.nVertex = size(M.Vertex,1);
            M = CheckMesh(M);
            [M.AM,M.AMD] = ComputeAdjacencyMatrix(M);
            
            [M.HalfEdge,M.HEiF] = ComputeHalfEdge(M);
            M.nHalfEdge = size(M.HalfEdge,1);
            [M.Edge,M.EiF] = ComputeEdge(M);
            M.nEdge = size(M.Edge,1);
            M.Boundary = ComputeBoundary(M);
            M.nBoundary = size(M.Boundary,1);
            [M.VViF,M.NViF,M.PViF] = ComputeConnectivity(M);
        end
        function M = CheckMesh(M)
        end
        function [Edge,EiF] = ComputeEdge(M)
            [I,J,~] = find(M.AM);
            ind = I<J;
            Edge = [I(ind),J(ind)];
            
            [~,~,V] = find(M.AMD-xor(M.AMD,M.AM));
            [~,~,V2] = find((M.AMD-xor(M.AMD,M.AM))');
            EiF = [V(ind),V2(ind)];
        end
        function [HalfEdge,HEiF] = ComputeHalfEdge(M)
            HalfEdge = [reshape(M.Face',M.nFace*3,1),reshape(M.Face(:,[2 3 1])',M.nFace*3,1)];
            HEiF = reshape(repmat(1:M.nFace,[3,1]),M.nFace*3,1);
        end
        function [VViF,NViF,PViF] = ComputeConnectivity(M)
            face = M.Face;
            fi = face(:,1);
            fj = face(:,2);
            fk = face(:,3);
            ff = (1:size(face,1))';
            VViF = sparse([fi;fj;fk],[fj;fk;fi],[ff;ff;ff]);
            NViF = sparse([ff;ff;ff],[fi;fj;fk],[fj;fk;fi]);
            PViF = sparse([ff;ff;ff],[fj;fk;fi],[fi;fj;fk]);
        end
        function [AM,AMD] = ComputeAdjacencyMatrix(M)
            I = reshape(M.Face',M.nFace*3,1);
            J = reshape(M.Face(:,[2 3 1])',M.nFace*3,1);
            V = reshape(repmat(1:M.nFace,[3,1]),M.nFace*3,1);
            AMD = sparse(I,J,V);
            V(:) = 1; 
            AM = sparse([I;J],[J;I],[V;V]);
        end
        function Boundary = ComputeBoundary(M)
        % currently, do not consider multiple boundary    
            MD = M.AM - (M.AMD>0)*2;
            [I,~,~] = find(MD == -1);
            [~,Ii] = sort(I);
            Boundary = zeros(size(I));
            k = 1;
            for i = 1:size(I)
                Boundary(i) = I(k);
                k = Ii(k);
            end
        end
        function tf = IsBoundary(M,i)
        % test if a vertex i is on boundary
            tf = length(find(M.Boundary==i));
        end
        function vr = ComputeVertexRing(M,v)
            if nargin == 1
                v = 1:M.nVertex;
            end
            v = v(:);
            vr = cell(size(v));
            for i = 1:size(v,1)
                fs = M.VViF(v(i),:);
                v1 = full(find(fs,1,'first'));
                if M.IsBoundary(v(i))
                    while M.VViF(v1,v(i))
                        f2 = full(M.VViF(v1,v(i)));
                        v1 = full(M.PViF(f2,v1));
                    end
                end
                vi = v1;
                v0 = v1;
                while M.VViF(v(i),v1)
                    f1 = full(M.VViF(v(i),v1));
                    v1 = full(M.NViF(f1,v1));
                    vi = [vi,v1];
                    if v0 == v1
                        break;
                    end
                end
                vr{i} = vi;
            end
            if size(v,1) == 1
                vr = vr{1};
            end
        end
    end
end