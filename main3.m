% �����������ַ��Ӷ���ѧģ���еĲ����Ͼ�
% 2021.1 by Bai Zhiwen
clc;
clear;
%% Setting
global LC fir_nei epsilon % ����ȫ�ֱ��� ������(���������Ҫ��������)
LC = 3.6 ; % ������ lattice constant
fir_nei = LC/(2^0.5); % ��һ����ԭ�Ӿ��� �ڶ����ھ���ΪLC
epsilon=0.6*fir_nei+0.4*LC; % �ضϾ��룬��ԭ�Ӿ���С�ڴ˾��룬����Ϊ��ԭ�ӽ���
%% Laod Data
filename = 'test.data';
[ box,wdata ] = laoddata2( filename );
ordata = wdata(wdata(:,5)==2,2:4);
neighbors = neighbor_period(ordata,box); % Ϊԭ�ӹ����ڽ�ԭ�Ӷ�Ӧ������������
[layer,setmath] = getlayer(neighbors); % ���ֽṹ
%% Output data
% picture(ordata,layer+1); % ���ӻ����
% picture(ordata,setmath(:,2)+1); % ���ӻ����
% wdata=wdata(wdata(:,5)==2,:);
% owdata=wdata;
layer(layer>0) = layer(layer>0)+1; 
wdata(wdata(:,5)>2,5)=0;
wdata(wdata(:,5)==2,5) = layer; % ׼������
wdata(:,6) = wdata(:,5)-1; % ����
wdata(wdata(:,6)<0,6)=4;
writedata2(filename,wdata) % д������






