function cylinder3(X1,X2,r,color)
%一个简单的例子：cylinder3([1 2 3],[7 8 9],1,'b')
length_cyl=norm(X2-X1);
[x,y,z]=cylinder(r,100);
z=z*length_cyl;
%绘制两个底面
hold on;
EndPlate1=fill3(x(1,:),y(1,:),z(1,:),'r');
EndPlate2=fill3(x(2,:),y(2,:),z(2,:),'r');
Cylinder=mesh(x,y,z);
%计算圆柱体旋转的角度
unit_V=[0 0 1];
angle_X1X2=acos(dot( unit_V,(X2-X1) )/( norm(unit_V)*norm(X2-X1)) )*180/pi;
%计算旋转轴
axis_rot=cross(unit_V,(X2-X1));
%将圆柱体旋转到期望方向
if angle_X1X2~=0 % Rotation is not needed if required direction is along X
    rotate(Cylinder,axis_rot,angle_X1X2,[0 0 0])
    rotate(EndPlate1,axis_rot,angle_X1X2,[0 0 0])
    rotate(EndPlate2,axis_rot,angle_X1X2,[0 0 0])
end
%将圆柱体和平面挪到期望的位置
set(EndPlate1,'XData',get(EndPlate1,'XData')+X1(1))
set(EndPlate1,'YData',get(EndPlate1,'YData')+X1(2))
set(EndPlate1,'ZData',get(EndPlate1,'ZData')+X1(3))
set(EndPlate2,'XData',get(EndPlate2,'XData')+X1(1))
set(EndPlate2,'YData',get(EndPlate2,'YData')+X1(2))
set(EndPlate2,'ZData',get(EndPlate2,'ZData')+X1(3))
set(Cylinder,'XData',get(Cylinder,'XData')+X1(1))
set(Cylinder,'YData',get(Cylinder,'YData')+X1(2))
set(Cylinder,'ZData',get(Cylinder,'ZData')+X1(3))
% 设置圆柱体的颜色
set(Cylinder,'FaceColor',color)
set([EndPlate1 EndPlate2],'FaceColor',color)
set(Cylinder,'EdgeAlpha',0)
set([EndPlate1 EndPlate2],'EdgeAlpha',0)
axis equal;
view(3)
end
