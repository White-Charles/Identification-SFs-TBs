function [vector,layer2,level] = getvector( set,p,neighbors )
% set�ǵ㼯�ϣ�p�����е�����
% �ú������Եõ���ķ�����vector�͵������layer,level�ǲ������������
global LC
setmath=zeros(numel(set),4); % ��һ��Ϊԭ�ӱ�ţ�����Ϊԭ���������Ϊ�����ǣ�����ҲΪԭ�����
setmath(:,1)=set;
tongc = {};
vector = zeros(numel(set),3); % ԭ�ӷ�����
layer = cell(numel(set),1); % ԭ��λ�ò���
layer2 = zeros(numel(set),1);
for i =1:numel(set)
    [setmath(i,2),tc]= teamtype(setmath(i,1),neighbors);
    tongc = cat(1,tongc,tc);
end
for i = 1:numel(set)
    if setmath(i,2) ~= 4 % �ǵ�����ԭ�ӣ�����ͬ��ԭ�ӷ�����
        planeData = p(tongc{i},:);
        [a,b,c,~ ] = surface4(planeData);
        vector(i,:)=[a,b,c];
        setmath(i,3)=1;
    end
end
for i = 1:numel(set)
    if setmath(i,2) == 4 % ������ԭ�ӣ��Խ��ڷǵ�����ԭ�Ӽ��㷨����
        nei = neighbors{setmath(i,1)};
        nei = intersect(nei,setmath((setmath(:,2)~=4),1));
        if isempty(nei) == 0
            [~,nei]=ismember(nei,setmath(:,1));
            if numel(vector(nei,:))>3
                abc= mean(vector(nei,:),1);
            else
                abc=vector(nei,:);
            end
            vector(i,:)=abc;
            setmath(i,3)=1;
        end
    end
end
setmath(:,4)= setmath(:,2);
setmath((setmath(:,4)==4),4)=0; % ������ԭ������ 4->0
for i = 1:numel(set)
    id = sum(setmath(:,1)==neighbors{setmath(i,1)},2);
%     layer(i) =  max(setmath(id==1,4));
    layer(i) =  {setmath(id==1,4)};
    
end

for i = 1:numel(layer)
    layer2(i) = max(layer{i});
end

% for i = 1:numel(set)
%     if layer2(i)<2
%         id = sum(setmath(:,1)==neighbors{setmath(i,1)},2);
%         layer2(i) =  max(layer(id==1));
%     end
% end

% picture(p(set,:),layer2); % ԭ�Ӳ���ͼ
% picture(p(set,:),setmath(:,2)); % ԭ������ͼ

level = cat(2,layer2,zeros(numel(layer2),1));
level(level(:,1)==2,2)= 1;
level(level(:,1)==2,1)= 0;
level(level(:,1)==3,1)=-1;
level =1.5*LC/3.6*level;

function [type,tc] = teamtype(he,neighbors)
% �жϺ���ԭ��he���ࡣ�������ࡣ
team = neighbors{he};
tc = []; % �����ԭ��ͬ���ԭ��
if numel(team)==7
    kind = [];
    for j = 1:7
        neig = numel(intersect(team,neighbors{team(j)}));
        kind = cat(1,kind,neig);
    end
    if sum(kind==7)==1 && sum(kind==4)==6
        type = 1;
        tc = team(kind==4);
    else
        type = 4;
    end   
elseif numel(neighbors{he})==10
    kind = [];
    for j = 1:10
        neig = numel(intersect(team,neighbors{team(j)}));
        kind = cat(1,kind,neig);
    end
    if sum(kind==10)==1 && sum(kind==5)==6 && sum(kind==6)==3
        type = 2;
        tc = team(kind==5);
    else
        type = 4;
    end
elseif numel(neighbors{he})==13
    nhe = neighbors{he};
    nhep=p(nhe,:);
    nhep_=2*p(he,:)-nhep;
    D=pdist2(nhep,nhep_);
    mind=find(min(D)<LC/10);
    if numel(mind) == 7
        type=3;
        tc = neighbors{he}(mind);
    else
        type=4;
    end
else
    type = 4;
end
tc = cat(2,tc,he);
tc = {tc};
end


pset=p(set,:);
scatter3(pset(:,1), pset(:,2), pset(:,3),80,'g','filled');
hold on;
scatter3(pset(:,1), pset(:,2), pset(:,3),80,'k')
% scatter3(pset(:,1), pset(:,2), pset(:,3),80,'b','filled')
vector = 0.5*vector;
quiver3(pset(:,1), pset(:,2), pset(:,3), vector(:,1), vector(:,2), vector(:,3),'k','AutoScaleFactor',0.5,'LineWidth',0.5);
% for i=1:size(pset,1)
%     arrow3([1 2 3],[7 8 9],0.25,1,0.6,[0 0.4470 0.7410]);
% end

hold off

end

