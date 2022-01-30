function [neighbors]=neighbor_period(data,box)
% neighbor_period�������ڻ�õ�������ھӣ�ͬʱ�����˺��������ԡ�
% data��ԭʼ���������ݣ������λ�ö��ں��ӵ��ڲ�
% box��3*2�ľ���,[xmin,xmax;ymin,ymax;zmin,zmax]����ʾ���ӵĴ�С
% new_data����Ҫ���������Եĵ�
% 
global epsilon % ����ȫ�ֱ���
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
[neiIDX,Dis] = knnsearch(alldata ,data,'K',20); % �ؼ�������Ϊԭ�ӹ����ڽ�ԭ�Ӷ�Ӧ��
neiIDX(Dis>epsilon)=0;
B = num2cell(neiIDX,2);
neighbors = cellfun( @(x) setdiff(unique(x(:)),0)',B,'UniformOutput',false);% �������ڹ�ϵ
for i = 1:numel(neighbors)
    neighbors{i} = allnum(neighbors{i});
end

%
end

