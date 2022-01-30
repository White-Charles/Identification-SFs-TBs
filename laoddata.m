function [ box,wdata ] = laoddata( filename )
% 依据文件名filename,读数据盒子大小box和原子点位置坐标data
delimiterIn = ' ';
headerlinesIn = 9;
data = importdata(filename,delimiterIn,headerlinesIn);
headerlinesIn2 = 5;
box = importdata(filename,delimiterIn,headerlinesIn2);

wdata = data.data;  % 位置坐标
box = box.data; % 盒子大小
end

