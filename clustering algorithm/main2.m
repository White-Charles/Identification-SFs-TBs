clc;
clear;
%% parameter
global LC  % ����ȫ�ֱ��� ������
LC = 3.6 ; % ������ lattice constant
TBs_SFs=zeros(4,2); % �Ͼ����˫�����
%% Laod Data
filename = 's.data';
[ box,wdata ] = laoddata( filename );
% save('box');save('wdata');
% laod(box.mat);load(wdata.mat);
ordata = wdata(:,3:5);
data = periodicity(ordata,box);
%% Setting
fir_nei = LC/(2^0.5) ; % ��һ����ԭ�Ӿ��� �ڶ����ھ���ΪLC
epsilon=0.6*fir_nei+0.4*LC; % �ضϾ��룬��ԭ�Ӿ���С�ڴ˾��룬����Ϊ��ԭ�ӽ���
MinPts=1; % ��Ҫ����λ����С��1 % ��һ��DBSCAN�㷨 ����ά������ξ���
IDX=DBSCAN(data,epsilon,MinPts); % ��ͬ���ŵ�ԭ�ӱ����֣�һ�����ſ��ܰ������ƽ��
p=data; 
% IDX_=DBSCAN(ordata,epsilon,MinPts);
% wdata(:,2) = IDX_;
% writedata( filename,['m_' filename ],wdata ) % д������
% wdata(:,2) = IDX; wdata(:,3:5)=data;
% writedata( filename,['p_' filename ],wdata ) % д������
%% Deal Data
set = {}; % set{i}�ǵ�i�����ŵ�ԭ�Ӽ���
for i = 1:max(IDX)
    set = cat(1,set,{find(IDX==i)});
end
clr = []; % ����ԭ����С��8�ļ��ű�ǲ����,ԭ�ӱ��Ϊ����
for i = 1:numel(set)
    if numel(set{i})<8 
        clr = cat(1,clr,i); % ���
        IDX(IDX==i)=0;
    end
end
set(clr)=[]; % ���
D=pdist2(p,p);
neighbors = {};
for i = 1:size(p,1)
    Nei=find(D(i,:)<=epsilon);
    neighbors = cat(1,neighbors,{Nei});
end % �������ڹ�ϵ
%%
I = zeros(size(p,1),2); % I(i,1)����i���������ţ�I(i,2)����i�����ԣ�1������2�Ͼ���3���
layer = zeros(size(data,1),1);
for n = 1:numel(set)
    setp=p(set{n},:);
    [ vector,slayer,level]=getvector(set{n},p,neighbors); % ���㷨����
    layer(set{n})=slayer;
    noisevector= find(prod(vector(:,:)==[0 0 0],2)==1); % �������
    normals = 5*LC/3.6*homo(vector); % ������ȡ�����ҳ���ϵ��
    setp_6d=cat(2,setp,normals,level); % setp_6d ��6ά���꣬ǰ3ά����o_xyz�ռ����꣬��3ά�Ǹõ�ĵ�λ���ȷ�����
    MinPts=6; % Ҫ����λ����С��6 % �ڶ���ʹ��DBSCAN�㷨������6ά�ռ��
    setIDX=DBSCAN(setp_6d,epsilon,MinPts); % epsilon+0.2 ����0.2�Ǿ���ֵ������������ά�Ⱥ�ĽضϿ��ݶ�
    setIDX(noisevector)=0; % ��������
    setlist = set{n};
%     picture(p(setlist,:),setIDX);
    for m = 1:max(setIDX)
        plane = set{n}(setIDX==m);
        if numel(plane)<6
            setIDX(setIDX==m)=0;        
        end
    end
    for i = 1:max(setIDX) % �м��п�ֵ������Ϊ��������
        if isempty(setIDX(setIDX==i)) == 1
            setIDX(setIDX>i) = setIDX(setIDX>i)-min(setIDX(setIDX>i))+i;
        end
    end
    %
    for m = 1:max(setIDX)
        plane = set{n}(setIDX==m);
        [ abc_d, nplane, noise ] = forset( p,plane ); % �Ż�ƽ��
        if isempty(noise) == 0
            setIDX(sum(setlist==noise,2)>0) = 0;
        end
        if numel(noise) == numel(plane)
            break
        end
        if ismember(m,setIDX) && numel(abc_d)>3
            setIDX  = inset2( p,setlist,setIDX,m,abc_d); % ��������ԭ��   
        end 
    end
    setnoise = setlist(setIDX==0); % ����ԭ��
    setIDX2=DBSCAN(p(setnoise,:),epsilon,6); % ������ʹ��DBSCAN�㷨��������
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
%% ���ӻ���� �ļ���� ���������
% picture2(data,I(:,1)-1,box); % 
information = picture2(data,I(:,2)-1,[],I(:,1)-1);
picture2(ordata,I(:,1)-1,box); 
% picture(ordata,I(:,2)-1,box);
% picture ����ʹ��ʱ��������������ԣ���Ѻ��ӻ���ȥ����
% ���ں������������һ��box����Ȼǰ���λ������ҲҪ��Ӧ

wdata(:,2) = I(:,2); % ׼������
writedata( filename,wdata ) % д������
wdata(:,2) = I(:,1); % ׼������
writedata( filename,['show_' filename ],wdata ) % д������

TBs_SFs(1,2)=sum(I(:,2)==2);
TBs_SFs(2,2)=sum(I(:,2)==3);
TBs_SFs(3,2)=sum(I(:,2)==4);
str1=['The number of TBs is ', num2str(TBs_SFs(1,1));
       'The number of SFs is ', num2str(TBs_SFs(2,1));];
str2=['The number of Atoms of TBs is ', num2str(TBs_SFs(1,2));
       'The number of Atoms of SFs is ', num2str(TBs_SFs(2,2));];
disp(str1);disp(str2);

% �����Ż���¼����Եԭ�ӷ���������ȡƽ��ֵ���Ǻܺ��ʣ�Ӧ��ȡ��Χԭ���ܷ�����չ�����������ԭ��