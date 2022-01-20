% 本例用于区分分子动力学模型中的层错和孪晶
% 2021.1 by Bai Zhiwen
clc;
clear;
%% Setting
global LC fir_nei epsilon % 设置全局变量 晶格常数(这个参数需要主动设置)
LC = 3.6 ; % 晶格常数 lattice constant
fir_nei = LC/(2^0.5); % 第一近邻原子距离 第二近邻距离为LC
epsilon=0.6*fir_nei+0.4*LC; % 截断距离，两原子距离小于此距离，则认为两原子近邻
%% Laod Data
filename = 'test.data';
[ box,wdata ] = laoddata2( filename );
ordata = wdata(wdata(:,5)==2,2:4);
neighbors = neighbor_period(ordata,box); % 为原子构建邻近原子对应表，考虑周期性
[layer,setmath] = getlayer(neighbors); % 区分结构
%% Output data
% picture(ordata,layer+1); % 可视化输出
% picture(ordata,setmath(:,2)+1); % 可视化输出
% wdata=wdata(wdata(:,5)==2,:);
% owdata=wdata;
layer(layer>0) = layer(layer>0)+1; 
wdata(wdata(:,5)>2,5)=0;
wdata(wdata(:,5)==2,5) = layer; % 准备数据
wdata(:,6) = wdata(:,5)-1; % 调整
wdata(wdata(:,6)<0,6)=4;
writedata2(filename,wdata) % 写入数据






