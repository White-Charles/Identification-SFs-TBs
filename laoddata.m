function [ box,wdata ] = laoddata( filename )
% �����ļ���filename,�����ݺ��Ӵ�Сbox��ԭ�ӵ�λ������data
delimiterIn = ' ';
headerlinesIn = 9;
data = importdata(filename,delimiterIn,headerlinesIn);
headerlinesIn2 = 5;
box = importdata(filename,delimiterIn,headerlinesIn2);

wdata = data.data;  % λ������
box = box.data; % ���Ӵ�С
end

