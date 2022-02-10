clc;
clear;
%% parameter
global LC  % 设置全局变量 晶格常数
LC = 3.6 ; % 晶格常数 lattice constant
TBs_SFs=zeros(4,2); % 孪晶层错双相计数
%% Laod Data
filename = 's.data';
[ box,wdata ] = laoddata( filename );
% save('box');save('wdata');
% laod(box.mat);load(wdata.mat);
ordata = wdata(:,3:5);
data = periodicity(ordata,box);
%% Setting
fir_nei = LC/(2^0.5) ; % 第一近邻原子距离 第二近邻距离为LC
epsilon=0.6*fir_nei+0.4*LC; % 截断距离，两原子距离小于此距离，则认为两原子近邻
MinPts=1; % 仅要求配位数不小于1 % 第一次DBSCAN算法 对三维坐标初次聚类
IDX=DBSCAN(data,epsilon,MinPts); % 不同集团的原子被区分，一个集团可能包括多个平面
p=data; 
% IDX_=DBSCAN(ordata,epsilon,MinPts);
% wdata(:,2) = IDX_;
% writedata( filename,['m_' filename ],wdata ) % 写入数据
% wdata(:,2) = IDX; wdata(:,3:5)=data;
% writedata( filename,['p_' filename ],wdata ) % 写入数据
%% Deal Data
set = {}; % set{i}是第i个集团的原子集合
for i = 1:max(IDX)
    set = cat(1,set,{find(IDX==i)});
end
clr = []; % 对总原子数小于8的集团标记并清除,原子标记为噪声
for i = 1:numel(set)
    if numel(set{i})<8 
        clr = cat(1,clr,i); % 标记
        IDX(IDX==i)=0;
    end
end
set(clr)=[]; % 清除
D=pdist2(p,p);
neighbors = {};
for i = 1:size(p,1)
    Nei=find(D(i,:)<=epsilon);
    neighbors = cat(1,neighbors,{Nei});
end % 构建近邻关系
%%
I = zeros(size(p,1),2); % I(i,1)储存i的所属集团，I(i,2)储存i的属性，1噪声，2孪晶，3层错。
layer = zeros(size(data,1),1);
for n = 1:numel(set)
    setp=p(set{n},:);
    [ vector,slayer,level]=getvector(set{n},p,neighbors); % 计算法向量
    layer(set{n})=slayer;
    noisevector= find(prod(vector(:,:)==[0 0 0],2)==1); % 标记噪声
    normals = 5*LC/3.6*homo(vector); % 法向量取正向，且乘以系数
    setp_6d=cat(2,setp,normals,level); % setp_6d 是6维坐标，前3维度是o_xyz空间坐标，后3维是该点的单位长度法向量
    MinPts=6; % 要求配位数不小于6 % 第二次使用DBSCAN算法，处理6维空间点
    setIDX=DBSCAN(setp_6d,epsilon,MinPts); % epsilon+0.2 其中0.2是经验值，是引入三个维度后的截断宽容度
    setIDX(noisevector)=0; % 噪声置零
    setlist = set{n};
%     picture(p(setlist,:),setIDX);
    for m = 1:max(setIDX)
        plane = set{n}(setIDX==m);
        if numel(plane)<6
            setIDX(setIDX==m)=0;        
        end
    end
    for i = 1:max(setIDX) % 中间有空值，调整为紧密排列
        if isempty(setIDX(setIDX==i)) == 1
            setIDX(setIDX>i) = setIDX(setIDX>i)-min(setIDX(setIDX>i))+i;
        end
    end
    %
    for m = 1:max(setIDX)
        plane = set{n}(setIDX==m);
        [ abc_d, nplane, noise ] = forset( p,plane ); % 优化平面
        if isempty(noise) == 0
            setIDX(sum(setlist==noise,2)>0) = 0;
        end
        if numel(noise) == numel(plane)
            break
        end
        if ismember(m,setIDX) && numel(abc_d)>3
            setIDX  = inset2( p,setlist,setIDX,m,abc_d); % 处理噪声原子   
        end 
    end
    setnoise = setlist(setIDX==0); % 噪声原子
    setIDX2=DBSCAN(p(setnoise,:),epsilon,6); % 第三次使用DBSCAN算法处理噪声
    setIDX2(setIDX2>0)=setIDX2(setIDX2>0)+max(setIDX);
    setIDX(setIDX==0)=setIDX2;
    for m = 1:max(setIDX)
        if isempty(intersect(setIDX,m))==0
            plane = set{n}(setIDX==m);        
            I(plane,1) = max(I(:,1))+1;
            I2=max(layer(plane));
            if I2>0
                I(plane,2)=I2;
            else
                [ abc_d, nplane, ~ ] = forset( p,plane );
                I2= numel(abc_d)-3;
                I(plane,2) = I2;
            end
            if I2==1
               TBs_SFs(1,1)=TBs_SFs(1,1)+1;
            elseif I2==2
               TBs_SFs(2,1)=TBs_SFs(2,1)+1;
            elseif I2>2
               TBs_SFs(3,1)=TBs_SFs(3,1)+1;
            end
        end
    end
end
for i=1:size(I,1)
    if size(I(I(:,1)==i),1)<6
        I(I(:,1)==i,:)=zeros(size(I(I(:,1)==i),1),2);
    end
end
I= I+1;
% for i=1:size(I,1)
%     if I(i,2)>4
%        I(i,2) = 4;
%     end
% end
%% 可视化输出 文件输出 命令行输出
% picture2(data,I(:,1)-1,box); % 
information = picture2(data,I(:,2)-1,[],I(:,1)-1);
picture2(ordata,I(:,1)-1,box); 
% picture(ordata,I(:,2)-1,box);
% picture 函数使用时，如果考虑周期性（想把盒子画上去），
% 就在函数后面多输入一个box，当然前面的位置坐标也要对应

wdata(:,2) = I(:,2); % 准备数据
writedata( filename,wdata ) % 写入数据
wdata(:,2) = I(:,1); % 准备数据
writedata( filename,['show_' filename ],wdata ) % 写入数据

TBs_SFs(1,2)=sum(I(:,2)==2);
TBs_SFs(2,2)=sum(I(:,2)==3);
TBs_SFs(3,2)=sum(I(:,2)==4);
str1=['The number of TBs is ', num2str(TBs_SFs(1,1));
       'The number of SFs is ', num2str(TBs_SFs(2,1));];
str2=['The number of Atoms of TBs is ', num2str(TBs_SFs(1,2));
       'The number of Atoms of SFs is ', num2str(TBs_SFs(2,2));];
disp(str1);disp(str2);

% 程序优化记录，边缘原子法向量计算取平均值不是很合适，应该取周围原子能方向延展能遇到更多的原子