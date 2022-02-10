function [ newIDX ] = inset2( p,setlist,setIDX,s,abc_d)
% 对setIDX=0 的噪声点处理，判断其是否在set的第s个面中
% p是所有点坐标，setlist是集合的点集，setIDX点属于的集合的面，abc_d是面的参数。
global LC
% LC = 3.6 ; % 晶格常数 lattice constant  
fir_nei = LC/(2^0.5) ; % 第一近邻原子距离 第二近邻距离为LC
dis = LC/(3^0.5); % 原子层间距
epsilon=0.8*fir_nei+0.2*LC; % 截断距离，两原子距离小于此距离，则认为两原子近邻
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
% 对setIDX=0 的噪声点处理
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

