function [layer,setmath] = getlayer( neighbors )
% set�ǵ㼯�ϣ�p�����е�����
% �ú������Եõ���ķ�����vector�͵������layer,level�ǲ������������
n=numel(neighbors);
setmath=zeros(n,2); % ��һ��Ϊԭ�ӱ�ţ�����Ϊԭ�����
setmath(:,1)=1:n;
layer1 = cell(n,1); % ԭ��λ�ò���
layer = zeros(n,1);
for i =1:n
    setmath(i,2)= teamtype(setmath(i,1));
end
for i = 1:n
    id = sum(setmath(:,1)==neighbors{setmath(i,1)},2);
    layer1(i) =  {setmath(id==1,2)};
    layer(i) = max(layer1{i});
end
layer2=layer;
for i = setmath(setmath(:,2)==0,1)'
    id = sum(setmath(:,1)==neighbors{setmath(i,1)},2);
    layer1(i) =  {layer2(id==1)};
    layer(i) = max(layer1{i});
end

    function type = teamtype(he)
        % �жϺ���ԭ��he���ࡣ�������ࡣ
        team = neighbors{he};
        if numel(team)==7
            kind = [];
            for j = 1:7
                neig = numel(intersect(team,neighbors{team(j)}));
                kind = cat(1,kind,neig);
            end
            if sum(kind==7)==1 && sum(kind==4)==6
                type = 1;
            else
                type = 0;
            end
        elseif numel(neighbors{he})==10
            kind = [];
            for j = 1:10
                neig = numel(intersect(team,neighbors{team(j)}));
                kind = cat(1,kind,neig);
            end
            if sum(kind==10)==1 && sum(kind==5)==6 && sum(kind==6)==3
                type = 2;
            else
                type = 0;
            end
        elseif numel(neighbors{he})==13
            type=3;
            
        else
            type = 0;
        end
        
    end

end

