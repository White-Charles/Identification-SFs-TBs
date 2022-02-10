function [new_data]=periodicity(data,box)
% periodicity函数用于处理盒子周期性
% data是原始的坐标数据，坐标点位置都在盒子的内部
% box是3*2的矩阵,[xmin,xmax;ymin,ymax;zmin,zmax]，表示盒子的大小
% new_data是新的坐标数据，同一部分的坐标点将不会被盒子分隔，但是部分原子将超出盒子
% picture(data,I(:,1)-1);
trans = []; % 标记变化
new_data = data;
LC = 3.6 ; % 晶格常数 lattice constant  
fir_nei = LC/(2^0.5) ; % 第一近邻原子距离 第二近邻距离为LC
epsilon=0.8*fir_nei+0.2*LC; % 截断距离，两原子距离小于此距离，则认为两原子近邻
MinPts=1; % 仅要求配位数不小于1 
IDX=DBSCAN(data,epsilon,MinPts); % 不同集团的原子被区分，一个集团可能包括多个平面
setsize = zeros(max(IDX),6); % 计算每个集团3个方向的跨度
for i =1:max(IDX)
    setsize(i,1:3) = max(data(IDX==i,:));
    setsize(i,4:6) = min(data(IDX==i,:));
end

for face = 1:3 % box六个面中的3个正交面
    waitp = []; % 待检验点
    for i = 1:size(data,1)
        if data(i,face) < box(face,1)+epsilon
            waitp = cat(1,waitp,[i,IDX(i)]);
        end
    end
    if isempty(waitp)==0
        trys = unique(waitp(:,2)); % 待检验集合
        for j = 1:numel(trys)
            tryp = waitp(waitp(:,2)==trys(j));
            for k = 1:size(tryp,1)
                point = data(tryp(k,1),:);
                point(face) = point(face)+box(face,2)-box(face,1); % 点移动到下一个周期
                D=pdist2(point,data); % 计算新点与盒子内所有点的距离
                if min(D) < epsilon && setsize(trys(j),face)-setsize(trys(j),face+3)...
                        <box(face,2)-box(face,1)-2*epsilon
                    % 新点通过了检验，集团整体移动到下一个周期
                    [~,tra] = min(D);
                    tra = IDX(tra);
                    trans = cat(1,trans,[trys(j),tra,face]);
                    new_data(IDX==trys(j),face) = new_data(IDX==trys(j),face)+box(face,2)-box(face,1);
                    break % 只需至少一个点通过检验
                end
            end
        end
    end
end
for i = 1:size(trans,1) % 变化追随
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

