% Author: Mohammad Nabi Omidvar
% email address: mn.omidvar AT gmail.com
% Modified by: Zhitao Huang
% email address: 2015160057@email.szu.edu.cn
%
% ------------
% Description:
% ------------
% This file is used to analyze the performance of the differential
% grouping algorithm on CEC'2010 benchmark problems.
% This program reads the data files generated by merged differential 
% grouping and shows how many variables from each formed group
% are correctly identified and to which permutation group they
% belong.
%
%--------
% Inputs:
%--------
%    funs: a vector containing the functions ids the functions that you 
%          want to analyze.
%

function analyze2010()
    more off;
    funcs=[1:1:20];
    % Number of non-separable groups for each function in CEC'2010 benchmark suite.
    numNonSep = [0 0 0 1 1 1 1 1 10 10 10 10 10 20 20 20 20 20 20 20];
    var_nonsep=[0 0 0 50 50 50 50 50 500 500 500 500 500 1000 1000 1000 1000 1000 1000 1000];
    num_sep=[];
    num_nonsep=[];
    groups_nonsep=[];
    fe=[];
    for f=funcs
        filename = sprintf('./groupResult/cec2010/F%02d.mat', f);
        p = 1:1:1000;
        load(filename);
    
        mat = zeros(length(nonseps), 20);
        drawline('=');
        fprintf('Function F: %02d\n', f);
%         fprintf('FEs used: %d\n', FEs);
        fprintf('Number of separables variables: %d\n', length (seps));
        fprintf('Number of non-separables groups: %d\n', length (nonseps));
        fe=[fe;0];
        %记录每个测试函数下，MDG分组中不可分变量的个数
        num_sep=[num_sep; length(seps)];
        %记录每个测试函数下，MDG分组中不可分组的个数
        groups_nonsep=[groups_nonsep;length(nonseps)];
        %读取目标函数中的信息，如真实的分组情况
        filename1 = sprintf('./cec2010/datafiles/f%02d_op.mat', f);
        filename2 = sprintf('./cec2010/datafiles/f%02d_opm.mat', f);
        flag = false;
        if(exist(filename1))
            load(filename1);
            flag = true;
        elseif(exist(filename2))
            load(filename2);
            flag = true;
        end
    
        printheader();
    
        for i=[1:1:length(nonseps)]
            fprintf('Size of G%02d: %3d  |  ', i, length (nonseps{i}));
            m = 50;
            if(flag)
                for g=[1:1:20]
                    index = (g-1)*m+1:g*m;
                    captured = length(intersect(p(index), nonseps{i}));
                    fprintf(' %4d', captured);
                    mat(i, g) = captured;
                end
            end
            fprintf('\n');
        end
        
    
        mat2 = mat;
        [temp I] = max(mat, [], 1);
        [sorted II] = sort(temp, 'descend');
        masks = zeros(size(mat));
        for k = 1:min(size(mat))
            mask = zeros(1, length(sorted));
            mask(II(k)) = 1;
            masks(I(II(k)), :) = mask;
            %point = [I(k) II(k)];
            mat(I(II(k)), :) = mat(I(II(k)), :) .* mask;
            [temp I] = max(mat, [], 1);
            [sorted II] = sort(temp, 'descend');
        end
        mat = mat2 .* masks;
        [temp I] = max(mat, [], 1);
        if(ismember(f, [19 20]))
            gsizes = cellfun('length', nonseps);
            fprintf('Number of non-separable variables correctly grouped: %d\n', max(gsizes));
            num_nonsep=[num_nonsep;max(gsizes)];     
        else
            if(length(nonseps)==0)
                fprintf('Number of non-separable variables correctly grouped: %d\n', 0);
                num_nonsep=[num_nonsep;0];
            else
                fprintf('Number of non-separable variables correctly grouped: %d\n', sum(temp(1:numNonSep(f))));
                num_nonsep=[num_nonsep;sum(temp(1:numNonSep(f)))];
            end
        end
        drawline('=');
        pause;
    end
    
    
    var_misplaced=var_nonsep'-num_nonsep;
    overall_acc=[];
    sep_acc=[];
    nonsep_group_acc=[];
    for i=1:20
        %num_sep中存储的是每个函数上的变量的可分变量的个数
        %var_nonsep中存储的是每个函数上真实的不可分离变量的个数
        if(num_sep(i)<(1000-var_nonsep(i)))
            real_sep=num_sep(i);
        else
            real_sep=(1000-var_nonsep(i));
        end
        %完全可分离函数
        if(i<=3)
            acc=num_sep(i)/1000;
            s_acc=num2str(acc,'%.4f');
            n_acc="-";
        %完全不可分函数
        elseif(i>=14)
            acc=num_nonsep(i)/1000;
            n_acc=num2str(acc,'%.4f');
            s_acc="-";
        %部分可分离函数
        else
            acc=(num_nonsep(i)+real_sep)/1000;
            s_acc=num2str(real_sep/(1000-var_nonsep(i)),'%.4f');
            n_acc=num2str(num_nonsep(i)/var_nonsep(i),'%.4f');
        end
        sep_acc=[sep_acc;s_acc];
        nonsep_group_acc=[nonsep_group_acc;n_acc];
        overall_acc=[overall_acc;acc];
        
    end
    

    
    %cec'2010
    xlswrite('results_2010.xlsx',[1:20]','A1:A20');
    xlswrite('results_2010.xlsx',1000-var_nonsep','B1:B20');
    xlswrite('results_2010.xlsx',var_nonsep','C1:C20');
    xlswrite('results_2010.xlsx',numNonSep','D1:D20');
    xlswrite('results_2010.xlsx',num_sep,'E1:E20');
    xlswrite('results_2010.xlsx',num_nonsep,'F1:F20');
    xlswrite('results_2010.xlsx',groups_nonsep,'G1:G20');
    xlswrite('results_2010.xlsx',var_misplaced,'H1:H20');
    xlswrite('results_2010.xlsx',fe,'I1:I20');
    xlswrite('results_2010.xlsx',sep_acc,'J1:J20');
    xlswrite('results_2010.xlsx',nonsep_group_acc,'K1:K20');
    xlswrite('results_2010.xlsx',overall_acc,'L1:L20');
    
end
% Helper Functions ----------------------------------------------------------
function drawline(c)
    for i=1:121  
        fprintf(1,c);
    end
    fprintf('\n')
end

function printheader()
    fprintf('Permutation Groups|  ');
    for i=1:20
        fprintf(' %4s', sprintf('P%d', i));
    end 
    fprintf('\n')
    drawline('-');
end
% End Helper Functions ------------------------------------------------------


