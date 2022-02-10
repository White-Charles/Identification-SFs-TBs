function [ newIDX ] = inset2( p,setlist,setIDX,s,abc_d)
% ��setIDX=0 �������㴦���ж����Ƿ���set�ĵ�s������
% p�����е����꣬setlist�Ǽ��ϵĵ㼯��setIDX�����ڵļ��ϵ��棬abc_d����Ĳ�����
global LC
% LC = 3.6 ; % ������ lattice constant  
fir_nei = LC/(2^0.5) ; % ��һ����ԭ�Ӿ��� �ڶ����ھ���ΪLC
dis = LC/(3^0.5); % ԭ�Ӳ���
epsilon=0.8*fir_nei+0.2*LC; % �ضϾ��룬��ԭ�Ӿ���С�ڴ˾��룬����Ϊ��ԭ�ӽ���
D=pdist2(p,p);
neighbors = {};
a= abc_d(1);b= abc_d(2);c= abc_d(3);
for i = 1:size(p,1)
    Nei=find(D(i,:)<=epsilon);
    neighbors = cat(1,neighbors,{Nei});
end
newIDX = fixIDX(setIDX);
while sum(setIDX==0)~=sum(newIDX==0)
    setIDX = fixIDX(newIDX);
    newIDX = fixIDX(setIDX);
end
%%
function [ nIDX ] = fixIDX(setIDX)
% ��setIDX=0 �������㴦��
nIDX = setIDX;
for k =1:numel(nIDX)
    if nIDX(k)==0
        e = [];
        for j = 4:numel(abc_d)
            d = abc_d(j);
            error =  (-d+a*p(setlist(k),1)+b*p(setlist(k),2)+c*p(setlist(k),3))/(a^2+b^2+c^2)^0.5 ;
            e = cat(2,e,error);
        end
        error = min(abs(e));
        if isempty(error)==0 && error<0.4*dis && isempty(intersect(neighbors{setlist(k)},setlist(nIDX==s)))==0
            nIDX(k)=s;
        end
    end
end

end


end

