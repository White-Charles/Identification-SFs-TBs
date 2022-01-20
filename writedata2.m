function writedata2( filename,wdata,varargin)
% WRITEDATA ����ļ�
if nargin==3
    outfile = wdata;
    wdata = varargin{1};  
else
    outfile = ['copy_' filename ];
end
% Ma=( 1:max(wdata(:,2)) )';
% Ma=num2str(Ma);
% Ma=cat(2,Ma,repmat(' 0.0',max(wdata(:,2)),1));
% Mass = {' '};
% for i =1:max(wdata(:,2))
%     Mass = cat(1,Mass,{Ma(i,:)});
% end
% Mass = cat(1,Mass,{' ';'Atoms  # atomic';' '});
% types = [num2str(max(wdata(:,2)) ) ' atom types'];
fidin=fopen(filename,'r'); % ��ԭʼ�����ļ�
message ={};
while ~feof(fidin) % �ж��Ƿ�Ϊ�ļ�ĩβ
    tline=fgetl(fidin); % ���ļ�����һ���ı��������س�����
    if contains(tline,'StructureType') % || contains(tline,'Masses')
        message=cat(1,message,{tline});
        break
    else
        message=cat(1,message,{tline});
    end
end
fclose(fidin);
% outfile = ['copy_' filename ];
% outfile ����ǰ����ǰ����
fidout=fopen(outfile,'w'); % �������������ļ�
for i = 1:numel(message)
    fprintf(fidout,'%s\n',message{i});
end
fclose(fidout);
fid=fopen(outfile,'at');%д���ļ�·��
fprintf (fid,'%1d %1d %1d %1d %1d %1d\n',wdata');
fclose(fid);

end

