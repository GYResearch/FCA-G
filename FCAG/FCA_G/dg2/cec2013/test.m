% res = {};
% for i = 1:15
%     filename = sprintf('sadjacency/sf%02d.mat',i);
%     load(filename);
%     temp = {};
% %     [m,n] = size(Adj);
%     for j = 1:1000
%         temp{j} = find(Adj == j);
%     end
%     res{i} = temp;
% end

filename = sprintf('./sadjacency/sf%02d.mat',12);
load(filename);
temp = {};
for j = 1:1000
    [row,col] = find(Adj == j);
    temp{j} = [row,col];
end