function arrow3(X1,X2,r1,h,r2,color)
%一个简单的实例：arrow3([1 2 3],[7 8 9],0.25,1,0.6,'b');
%箭头由圆柱体和圆锥体组成:包括圆柱体的起点和终点位置，以及半径，圆锥的半径和高度
hold on;
cylinder3(X1,X2,r1,color)
X3=(X2-X1)/norm(X2-X1)*h+X2;
cone3(X2,X3,r2,color)
end
