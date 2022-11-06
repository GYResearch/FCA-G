% Author: Dr. Zhyenu Yang
% Modified by: Mohammad Nabi Omidvar
% email address: mn.omidvar AT gmail.com
%
% ------------
% Description:
% ------------
% This file is an implementation of cooperative co-evolution which
% uses SaNSDE algorithm as subcomponent optimizer.
%
% -----------
% References:
% -----------
% Omidvar, M.N.; Li, X.; Mei, Y.; Yao, X., "Cooperative Co-evolution with
% Differential Grouping for Large Scale Optimization," Evolutionary Computation,
% IEEE Transactions on, vol.PP, no.99, pp.1,1, 0
% http://dx.doi.org/10.1109/TEVC.2013.2281543
%
% --------
% License:
% --------
% This program is to be used under the terms of the GNU General Public License 
% (http://www.gnu.org/copyleft/gpl.html).
% Author: Mohammad Nabi Omidvar
% e-mail: mn.omidvar AT gmail.com
% Copyright notice: (c) 2013 Mohammad Nabi Omidvar


function gval = decc(fname, func_num, dim, Lbound, Ubound, popsize, Max_FEs, runindex)

    % for fitness trace
    tracerst = [];
    N=1000;%任务数量
    M=100;%虚拟机数量，bw_vm宽带
    load './Data/task_information/length_t.mat';
    load './Data/task_information/size_t.mat';
    load './Data/VM_information/bw_vm.mat';
    load './Data/VM_information/core_vm.mat';
    load './Data/VM_information/mips_vm.mat';
    
    % the initial population
    cost1  = zeros(N,M);
    for popnum =1:popsize
        pay=1;
        for i=1:N
            j=round(rand(1,1)*(M-1))+1;
            cost2(popnum,i) = (size_t(i)/bw_vm(j) + length_t(i)/(core_vm(j)*mips_vm(j))).^pay;
            cost1(i,j) =cost1(i,j) + (size_t(i)/bw_vm(j) + length_t(i)/(core_vm(j)*mips_vm(j))).^pay;%当前任务选中的虚拟机           
        end
    end
    cost1=cost1';
    pop=cost2;
    val = feval(fname, pop, cost1,func_num);
    [bestval, ibest] = min(val);
    bestmem = pop(ibest, :);
    FEs = popsize;
    gval = bestval;
   
    if ~isfolder(savePath)
        mkdir(savePath);
    end
    
    % the initial crossover rate for SaNSDE
    group = {};
    ccm = 0.5;
    sansde_iter = 100;
    Cycle = 0;
    iter = 1;

    %addpath('benchmark');

    load(sprintf('./Task/F%02d.mat',func_num));
    group = {nonseps{1:end} seps};

    group_num = size(group, 2);

    display = 1;
    frequency = 100;
    delta = zeros(1, group_num);
    while (FEs < Max_FEs)
        Cycle = Cycle + 1;
        if (FEs <= popsize) || rand() < 0.05
            for i = 1:group_num

                dim_index = group{i};

                subpop = pop(:, dim_index); 
                subcost1=cost1(:, dim_index); 
                subLbound = Lbound(:, dim_index);        
                subUbound = Ubound(:, dim_index);

                if (FEs + (sansde_iter * popsize) > Max_FEs)
                    if(group_num > 1)
                        sansde_iter = ceil((Max_FEs - FEs - popsize) / popsize);
                    else
                        sansde_iter = ceil((Max_FEs - FEs) / popsize);
                    end
                end

                [subpopnew, bestmemnew, bestvalnew, tracerst, ccm, used_FEs] = sansde(fname, func_num, dim_index, subpop, subcost1, bestmem, bestval, subLbound, subUbound, sansde_iter, ccm, group_num);
                FEs = FEs + used_FEs;
                de = bestval - bestvalnew;
                if de ~= 0
                    delta(i) = de;
                end
                pop(:, dim_index) = subpopnew;
                if bestvalnew < bestval
                    bestmem = bestmemnew;
                    bestval = bestvalnew;
                end
                iter = iter + 1;
                gval(iter) = bestval;

                if(display == 1)
                    fprintf(1, 'Function = %d, Run = %d, Cycle = %d, bestval = %e, Group = %d\n', func_num, runindex, Cycle, bestval, i);
                end

                if(FEs >= Max_FEs)
                     break;
                end
            end
        end
        [deltaArr, deltaIndex] = sort(delta, 'descend');
        j = deltaIndex(1);
        while length(deltaArr) >= 2 && deltaArr(1) > deltaArr(2) && FEs < Max_FEs
            dim_index = group{j};

            subpop = pop(:, dim_index); 
            subLbound = Lbound(:, dim_index);        
            subUbound = Ubound(:, dim_index);

            if (FEs + (sansde_iter * popsize) > Max_FEs)
                if(group_num > 1)
                    sansde_iter = ceil((Max_FEs - FEs - popsize) / popsize);
                else
                    sansde_iter = ceil((Max_FEs - FEs) / popsize);
                end
            end

            [subpopnew, bestmemnew, bestvalnew, tracerst, ccm, used_FEs] = sansde(fname, func_num, dim_index, subpop, subcost1, bestmem, bestval, subLbound, subUbound, sansde_iter, ccm, group_num);
            FEs = FEs + used_FEs;
            de = bestval - bestvalnew;
            if de ~= 0
                delta(j) = de;
                deltaArr(1) = de;
            end
            pop(:, dim_index) = subpopnew;
            if bestvalnew < bestval
                bestmem = bestmemnew;
                bestval = bestvalnew;
            end
            iter = iter + 1;
            gval(iter) = bestval;

            if(display == 1)
                fprintf(1, 'Function = %d, Run = %d, Cycle = %d, bestval = %e, Group = %d\n', func_num, runindex, Cycle, bestval, i);
            end

            if(FEs >= Max_FEs)
                 break;
            end
        end

    end
end
