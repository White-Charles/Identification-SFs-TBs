function [new_data]=periodicity(data,box)
% periodicity�������ڴ������������
% data��ԭʼ���������ݣ������λ�ö��ں��ӵ��ڲ�
% box��3*2�ľ���,[xmin,xmax;ymin,ymax;zmin,zmax]����ʾ���ӵĴ�С
% new_data���µ��������ݣ�ͬһ���ֵ�����㽫���ᱻ���ӷָ������ǲ���ԭ�ӽ���������
% picture(data,I(:,1)-1);
trans = []; % ��Ǳ仯
new_data = data;
LC = 3.6 ; % ������ lattice constant  
fir_nei = LC/(2^0.5) ; % ��һ����ԭ�Ӿ��� �ڶ����ھ���ΪLC
epsilon=0.8*fir_nei+0.2*LC; % �ضϾ��룬��ԭ�Ӿ���С�ڴ˾��룬����Ϊ��ԭ�ӽ���
MinPts=1; % ��Ҫ����λ����С��1 
IDX=DBSCAN(data,epsilon,MinPts); % ��ͬ���ŵ�ԭ�ӱ����֣�һ�����ſ��ܰ������ƽ��
setsize = zeros(max(IDX),6); % ����ÿ������3������Ŀ��
for i =1:max(IDX)
    setsize(i,1:3) = max(data(IDX==i,:));
    setsize(i,4:6) = min(data(IDX==i,:));
end

for face = 1:3 % box�������е�3��������
    waitp = []; % �������
    for i = 1:size(data,1)
        if data(i,face) < box(face,1)+epsilon
            waitp = cat(1,waitp,[i,IDX(i)]);
        end
    end
    if isempty(waitp)==0
        trys = unique(waitp(:,2)); % �����鼯��
        for j = 1:numel(trys)
            tryp = waitp(waitp(:,2)==trys(j));
            for k = 1:size(tryp,1)
                point = data(tryp(k,1),:);
                point(face) = point(face)+box(face,2)-box(face,1); % ���ƶ�����һ������
                D=pdist2(point,data); % �����µ�����������е�ľ���
                if min(D) < epsilon && setsize(trys(j),face)-setsize(trys(j),face+3)...
                        <box(face,2)-box(face,1)-2*epsilon
                    % �µ�ͨ���˼��飬���������ƶ�����һ������
                    [~,tra] = min(D);
                    tra = IDX(tra);
                    trans = cat(1,trans,[trys(j),tra,face]);
                    new_data(IDX==trys(j),face) = new_data(IDX==trys(j),face)+box(face,2)-box(face,1);
                    break % ֻ������һ����ͨ������
                end
            end
        end
    end
end
for i = 1:size(trans,1) % �仯׷��
    if isempty(intersect(trans(:,1),trans(i,2)) )==0
        move=trans(trans(:,1)==trans(i,2),:);
        for j = size(move,1)
            if isempty(intersect(trans(trans(:,1)==trans(i,1),3),move(j,3)))==1
                new_data(IDX==trans(i,1),move(j,3)) = new_data(IDX==trans(i,1),move(j,3))...
                +box(move(j,3),2)-box(move(j,3),1);
            end
        end
    end
end

end

