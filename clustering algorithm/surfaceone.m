function [ a,b,c,d ] = surfaceone (set,p)
% set是散点集合，p是原子坐标
    planeData = p(set,:);
    % 协方差矩阵的SVD变换中，最小奇异值对应的奇异向量就是平面的方向
    xyz0=mean(planeData,1);
    centeredPlane=bsxfun(@minus,planeData,xyz0);
    A=centeredPlane'*planeData;
    [~,~,V]=svd(A);
    a=V(1,3);
    b=V(2,3);
    c=V(3,3);
    d=-dot([a b c],xyz0);
    % d + a * XFIT + b * YFIT + c * ZFIT = 0

end

