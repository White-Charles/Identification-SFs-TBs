function [ a,b,c,d ] = surfaceone (set,p)
% set��ɢ�㼯�ϣ�p��ԭ������
    planeData = p(set,:);
    % Э��������SVD�任�У���С����ֵ��Ӧ��������������ƽ��ķ���
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

