function [ newnormals ] = homo( normals )
%HOMO 此处显示有关此函数的摘要
%   此处显示详细说明
    for i = 1:size(normals,1)
        if normals(i,3)<0
            normals(i,:)=-normals(i,:);
        elseif normals(i,3)==0
            if normals(i,2)<0
                normals(i,:)=-normals(i,:);
            elseif normals(i,2)==0
                if normals(i,1)<0
                    normals(i,:)=-normals(i,:);
                end
            end   
        end
    end
    newnormals = normals;
end

