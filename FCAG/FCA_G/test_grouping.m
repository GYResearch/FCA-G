function [group, nonseps, seps, time] = test_grouping(problem, func)
    % 加载sfxx.mat，获取分组的信息
    filename = sprintf('./dg2/cec%d/sadjacency/sf%02d.mat',problem, func);
    load(filename);
    time = sftime;
    % 对分组信息进行处理
    [m,n] = size(Adj);
    if n == 1 
        % 全是可分离的变量
        seps = Adj;
        nonseps = {};
        group = {seps};
    else
        % 有不可分离变量
        i = 1;
        j = 1;
        seps = [];
        nonseps = {};
        for row = 1:m
            % 判断是否是可分离变量
            if Adj(row,2) == 0
                % 可分离变量
                % 将其添加如seps中
                seps(i,1) = Adj(row,1);
                i = i + 1;
                continue;
            end
            % 不可分离变量
            non_sep = [];
            k = 1;
            for col = 1:n
                if Adj(row,col) ~= 0
                    non_sep(k) = Adj(row,col);
                    k = k + 1;
                end
            end
            nonseps{1,j} = non_sep;
            j = j+1;
        end
        group = nonseps;
        if ~isempty(seps)
            group = {group{1:end} seps};
        end
    end
end

