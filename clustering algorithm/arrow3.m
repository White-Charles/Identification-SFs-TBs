function arrow3(X1,X2,r1,h,r2,color)
%һ���򵥵�ʵ����arrow3([1 2 3],[7 8 9],0.25,1,0.6,'b');
%��ͷ��Բ�����Բ׶�����:����Բ����������յ�λ�ã��Լ��뾶��Բ׶�İ뾶�͸߶�
hold on;
cylinder3(X1,X2,r1,color)
X3=(X2-X1)/norm(X2-X1)*h+X2;
cone3(X2,X3,r2,color)
end
