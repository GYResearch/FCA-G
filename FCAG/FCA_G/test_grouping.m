function [group, nonseps, seps, time] = test_grouping(problem, func)
    % ����sfxx.mat����ȡ�������Ϣ
    filename = sprintf('./dg2/cec%d/sadjacency/sf%02d.mat',problem, func);
    load(filename);
    time = sftime;
    % �Է�����Ϣ���д���
    [m,n] = size(Adj);
    if n == 1 
        % ȫ�ǿɷ���ı���
        seps = Adj;
        nonseps = {};
        group = {seps};
    else
        % �в��ɷ������
        i = 1;
        j = 1;
        seps = [];
        nonseps = {};
        for row = 1:m
            % �ж��Ƿ��ǿɷ������
            if Adj(row,2) == 0
                % �ɷ������
                % ���������seps��
                seps(i,1) = Adj(row,1);
                i = i + 1;
                continue;
            end
            % ���ɷ������
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

