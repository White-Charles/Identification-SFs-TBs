function [ abc_d, nplane, noise ] = forset( p,number )
% 对set进行处理，获得平面法向量abc和多个d，d决定了多个平行平面的的位置，d的个数是原子层数
% nplane是属于平面的的点所处的层数
% noise是噪声点，不属于平面
% abc_d中肯可能没有d
    global LC
    % LC = 3.6 ; % 晶格常数 lattice constant  
    % fir_nei = LC/(2^0.5) ; % 第一近邻原子距离 第二近邻距离为LC
    dis = LC/(3^0.5); % 原子层间距
    noise = [];
    set = p(number,:);
%     N = size(set,1)*2;
%     t = 0.4*dis;
%     T = size(set,1)*0.2;
%     [ a,b,c,~] = ransac_fitplane(set',N,t,T) ;
     [ a,b,c,~] = surfaceone(number,p);
    abc_d = [a,b,c];
    set = cat(2,set,zeros(size(set,1),1 ) );
    for i = 1:size(set,1)
        set(i,4) = set(i,1:3) * [a,b,c]'/(a^2+b^2+c^2)^0.5;
    end
    layer=ceil((max(set(:,4))-min(set(:,4)))/dis);
%     layer = round((max(set(:,4))-min(set(:,4)))/dis)+1;
    nplane=cell(layer,1);
    for i = 1:size(set,1) 
       bel = ceil((set(i,4)-min(set(:,4)))/dis);
       if bel<1
           bel = 1;
       end
       nplane{bel} = cat(2,nplane{bel},number(i));
    end
    for i = 1:layer
        if numel(nplane{i}) < 3  
            noise = cat(2,nplane{i});
            nplane{i}=[];
        else
            d = mean(set( (sum(number==nplane{i},2))>0 , 4) ); 
            abc_d =cat(2,abc_d,d);
        end
    end
end





