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

% 采用密度聚类法，DBSCAN，对原子进行聚类。
% IDX=DBSCAN(X,epsilon,MinPts);
% （1）X:所有原子的坐标，M*D的矩阵，D是空间维度
% （2）epsilon:在一个点周围邻近区域的半径
% （3）minPts:邻近区域内至少包含点的个数
% 根据以上两个参数，结合epsilon-neighborhood的特征，可以把样本中的点分成三类：
% 核点（core point）：满足NBHD(p,epsilon)>=minPts，则为核样本点
% 边缘点（border point）：NBHD(p,epsilon)<minPts，但是该点可由一些核点获得（density-reachable或者directly-reachable）
% 离群点/噪声点（Outlier）：既不是核点也不是边缘点，则是不属于这一类的点
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



