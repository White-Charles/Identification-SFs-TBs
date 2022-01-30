function [neighbors]=neighbor_period(data,box)
% neighbor_period函数用于获得点坐标的邻居，同时处理了盒子周期性。
% data是原始的坐标数据，坐标点位置都在盒子的内部
% box是3*2的矩阵,[xmin,xmax;ymin,ymax;zmin,zmax]，表示盒子的大小
% new_data是需要考虑周期性的点
% 
global epsilon % 调用全局变量
all = size(data,1);
num = (1:all);
length = box(:,2)-box(:,1);
alldata = [];
allnum = [];
for i = -1:1
    for j = -1:1
        for k =-1:1
            data2 = data + length'.*[i,j,k];
            alldata = cat(1,alldata,data2);
            allnum = cat(2,allnum,num);
        end
    end
end
for i =1:3
    allnum(alldata(:,i)<box(i,1)-epsilon)=[];
    alldata(alldata(:,i)<box(i,1)-epsilon,:)=[];
    allnum(alldata(:,i)>box(i,2)+epsilon)=[];
    alldata(alldata(:,i)>box(i,2)+epsilon,:)=[]; 
end
[neiIDX,Dis] = knnsearch(alldata ,data,'K',20); % 关键函数，为原子构建邻近原子对应表
neiIDX(Dis>epsilon)=0;
B = num2cell(neiIDX,2);
neighbors = cellfun( @(x) setdiff(unique(x(:)),0)',B,'UniformOutput',false);% 构建近邻关系
for i = 1:numel(neighbors)
    neighbors{i} = allnum(neighbors{i});
end

%
end

