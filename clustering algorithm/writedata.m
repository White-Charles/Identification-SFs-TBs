function writedata( filename,wdata,varargin)
%WRITEDATA 此处显示有关此函数的摘要
%   此处显示详细说明
if nargin==3
    outfile = wdata;
    wdata = varargin{1};  
else
    outfile = ['copy_' filename ];
end
Ma=( 1:max(wdata(:,2)) )';
Ma=num2str(Ma);
Ma=cat(2,Ma,repmat(' 0.0',max(wdata(:,2)),1));
Mass = {' '};
for i =1:max(wdata(:,2))
    Mass = cat(1,Mass,{Ma(i,:)});
end
Mass = cat(1,Mass,{' ';'Atoms  # atomic';' '});
types = [num2str(max(wdata(:,2)) ) ' atom types'];
fidin=fopen(filename,'r'); % 打开原始数据文件  
message ={};
while ~feof(fidin) % 判断是否为文件末尾
  tline=fgetl(fidin); % 从文件读入一行文本（不含回车键）
  message=cat(1,message,{tline});
  if numel(tline)==6 && sum(tline=='Masses')==6
      break
  end
end
fclose(fidin);
message = cat(1,message,Mass);
message{3}=types;
% outfile = ['copy_' filename ];
% outfile 在最前面提前定义
fidout=fopen(outfile,'w'); % 创建保存数据文件
for i = 1:numel(message)
    fprintf(fidout,'%s\n',message{i});
end
fclose(fidout);
fid=fopen(outfile,'at');%写入文件路径
[m,n]=size(wdata);
for i=1:1:m
    for j=1:1:n
        if j==n
            fprintf(fid,'%g\n',wdata(i,j));
        else
            fprintf(fid,'%g\t',wdata(i,j));
        end
    end
end
fclose(fid);

end

