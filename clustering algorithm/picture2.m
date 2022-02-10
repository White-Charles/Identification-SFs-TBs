function information = picture2(data,IDX,varargin)
% ��ͼ��dataԭ������m*3��IDXԭ�ӷ���m*1��
% varargin��ѡ��Ĭ�ϱ�����Ĭ��Ϊ[],��������һ��box���ڻ��ƣ��������򲻻�����
% box��3*2�ľ���,[xmin,xmax;ymin,ymax;zmin,zmax]����ʾ���ӵĴ�С
information=[];
global LC
if nargin>2
    box=varargin{1};
    if nargin==4
        SID=varargin{2};
    end
end
hFigure = figure;
% color = [7,128,207;118,80,5;250,109,29;14,44,130;
%           182,181,31;218,31,24;112,24,102;244,122,117;
%           0,157,178;2,75,81;7,128,207;118,80,5]/255;
color = [0,168,225;153,204,0;227,0,57;252,211,0;128,0,128;
          0,153,78;255,102,0;128,128,0;219,0,194;0,128,128;
          0,0,255;200,204,0]/255; % RGB��ɫֵ
hold on
for i = 1:max(IDX)
    col = color( mod(i,12)+1,:);
    pos=data( IDX==i,:);
    if isempty(pos)==0
        pic=plot3(pos(:,1),pos(:,2),pos(:,3),'ok');
        pic.MarkerFaceColor=col;
    end
end
pos=data( IDX==0,: );
plot3(pos(:,1),pos(:,2),pos(:,3),'or');
xlabel('x'); ylabel('y'); zlabel('z');
if isempty(box)==0
    t=[box(1,1) box(2,1) box(3,1);
        box(1,2) box(2,1) box(3,1);
        box(1,2) box(2,2) box(3,1);
        box(1,1) box(2,2) box(3,1);
        box(1,1) box(2,1) box(3,2);
        box(1,2) box(2,1) box(3,2);
        box(1,2) box(2,2) box(3,2);
        box(1,1) box(2,2) box(3,2);];
    t1 = [1 2 3 4 1 5 6 2 6 7 3 4 8 5 8 7];
    i1 = 1;
    x = zeros(1,16);
    y = x;
    z = x;
    for i=t1
       x(i1) = t(i,1);
       y(i1) = t(i,2);
       z(i1) = t(i,3);
       i1 = i1+1;
    end
plot3(x,y,z,'k');
%     set(gca,'XLim',[box(1,1) box(1,2)+1]);%X���������ʾ��Χ
%     set(gca,'YLim',[box(2,1) box(2,2)+1]);%Y���������ʾ��Χ
%     set(gca,'ZLim',[box(3,1) box(3,2)+1]);%Z���������ʾ��Χ
end

xlabel('x');ylabel('y');zlabel('z');
axis equal
K=0; % Ԥ��������״ֵ̬
i=0;
disp('Select a group by clicking on the atom, then press Eturn.If you want to end, just press Enter')
while nargin==4 && K==0
    i=i+1;
    datacursormode on
    dcm_obj = datacursormode(hFigure);
    % Wait while the user does this.
    pause
    c_info = getCursorInfo(dcm_obj);
    p = c_info.Position;
    id=1:size(data,1);
    id=id(sum(data==p,2)==3);
    if SID(id) ~= 0
        iddata=data(SID==SID(id),:);
    else
        iddata=p;
    end
    color = [7,128,207;118,80,5;250,109,29;14,44,130]/255;
    pic=plot3(iddata(:,1),iddata(:,2),iddata(:,3),'ok');
    pic.MarkerFaceColor=color(IDX(id)+1,:);
    type={'Nosise';'Twins boundary';'Stacking fault';'Other'};
    numid=size(iddata,1);
    disp(['The selected atomic group belongs to ',type{IDX(id)+1},', with ',num2str(numid),' atoms']);
    if IDX(id)>0 && IDX(id)<3
       area=numid/(IDX(id))*3*3^0.5/8*LC;
       disp(['and the area is ',num2str(area),' square angstroms' ]);
    else
        area = 0;
    end
    infor=table(i,categorical(type(IDX(id)+1)),numid,area,'VariableNames',{'ID','TYPE','ATOM_NUM','AREA'}) ;
    information=cat(1,information,infor);
    K = waitforbuttonpress; % ��ȡ����״̬�������Ϊ0�����̵��Ϊ1��
    disp(' ')
    disp('Select a group by clicking on the atom, then press Eturn.If you want to end, just press Enter')
end
hold off
disp(information)
end
