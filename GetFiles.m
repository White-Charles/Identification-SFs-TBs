function [names,class_num] = GetFiles(foldername)
files = dir(foldername);
size0 = size(files);
length = size0(1);
names = files(3:length);
class_num = size(names);
end