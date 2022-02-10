function [ box,wdata ] = laoddata( filename )
% 依据文件名filename,读数据盒子大小box和原子点位置坐标data
data = importdata(filename);
textdata = data.textdata;
box = zeros(3,2);
for i = 1:3
    j = textscan(textdata{i+3},'%s '); 
    k = j{1,1}(1:2);
    box(i,1)=str2double(k{1});
    box(i,2)=str2double(k{2});
end
wdata = data.data;  % 位置坐标


end

