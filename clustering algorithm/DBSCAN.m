%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPML110
% Project Title: Implementation of DBSCAN Clustering in MATLAB
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

% �����ܶȾ��෨��DBSCAN����ԭ�ӽ��о��ࡣ
% IDX=DBSCAN(X,epsilon,MinPts);
% ��1��X:����ԭ�ӵ����꣬M*D�ľ���D�ǿռ�ά��
% ��2��epsilon:��һ������Χ�ڽ�����İ뾶
% ��3��minPts:�ڽ����������ٰ�����ĸ���
% ���������������������epsilon-neighborhood�����������԰������еĵ�ֳ����ࣺ
% �˵㣨core point��������NBHD(p,epsilon)>=minPts����Ϊ��������
% ��Ե�㣨border point����NBHD(p,epsilon)<minPts�����Ǹõ����һЩ�˵��ã�density-reachable����directly-reachable��
% ��Ⱥ��/�����㣨Outlier�����Ȳ��Ǻ˵�Ҳ���Ǳ�Ե�㣬���ǲ�������һ��ĵ�
function [IDX, isnoise]=DBSCAN(X,epsilon,MinPts)

    C=0;
    
    n=size(X,1);
    IDX=zeros(n,1);
    
    D=pdist2(X,X);
    
    visited=false(n,1);
    isnoise=false(n,1);
    
    for i=1:n
        if ~visited(i)
            visited(i)=true;
            
            Neighbors=RegionQuery(i);
            if numel(Neighbors)<MinPts
                % X(i,:) is NOISE
                isnoise(i)=true;
            else
                C=C+1;
                ExpandCluster(i,Neighbors,C);
            end
            
        end
    
    end
    
    function ExpandCluster(i,Neighbors,C)
        IDX(i)=C;
        
        k = 1;
        while true
            j  = Neighbors(k);
            
            if ~visited(j)
                visited(j)=true;
                Neighbors2=RegionQuery(j);
                if numel(Neighbors2)>=MinPts
                    if numel(Neighbors2)==MinPts
                        neighbor_pos = X(Neighbors2,:);
                        center = sum(neighbor_pos)/MinPts;
                        error = (center(1)-X(j,1))^2+(center(2)-X(j,2))^2+(center(3)-X(j,3))^2 ;
                    end
                    if numel(Neighbors2)>MinPts || error < 0.1
                        Neighbors=cat(2,Neighbors,Neighbors2);   %ok
%                         Neighbors=[Neighbors Neighbors2];   %ok
                    end
                end
            end
            if IDX(j)==0
                IDX(j)=C;
            end
            
            k = k + 1;
            if k > numel(Neighbors)
                break;
            end
        end
    end
    
    function Neighbors=RegionQuery(i)
        Neighbors=find(D(i,:)<=epsilon);
    end

end



