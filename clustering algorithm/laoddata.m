function [ box,wdata ] = laoddata( filename )
% �����ļ���filename,�����ݺ��Ӵ�Сbox��ԭ�ӵ�λ������data
data = importdata(filename);
textdata = data.textdata;
box = zeros(3,2);
for i = 1:3
    j = textscan(textdata{i+3},'%s '); 
    k = j{1,1}(1:2);
    box(i,1)=str2double(k{1});
    box(i,2)=str2double(k{2});
end
wdata = data.data;  % λ������


end

