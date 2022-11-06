% Author: Dr. Yuan SUN
% email address: yuan.sun@unimelb.edu.au OR suiyuanpku@gmail.com
% Modified by: Zhitao Huang
% email address: 2015160057@email.szu.edu.cn
%
% ------------
% Description:
% ------------
% This file is the entry point for the DECC-MDG algorithm on the CEC'2013 benchmark functions.
%


clear;
% set random seed
rand('state', sum(100*clock)); 
randn('state', sum(100*clock));
%warning('off' ,'Octave:divide-by-zero');

% number of independent runs
runs = 25;

% population size
NP = 100;

% number of fitness evaluations
Max_FEs = 3e6;

% for the benchmark functions initialization
global initial_flag;
myfunc = 1:15;
addpath('benchmark2013');
addpath('benchmark2013/datafiles');
problem=2013;

for func_num = myfunc 
    % load the FEs used in the decomposition process
    decResults = sprintf('./FCA_G/dg2/results/2010/F%02d',func_num);
    load (decResults);
    FEs = Max_FEs - evaluations.count;
    
    % set the dimensionality and upper and lower bounds of the search space
    if (ismember(func_num, [13,14]))
        D = 905;
        Lbound = -100.*ones(NP,D);
        Ubound = 100.*ones(NP,D);
    elseif (ismember(func_num, [1,4,7,8,11,12,15]))
        D = 1000;
        Lbound = -100.*ones(NP,D);
        Ubound = 100.*ones(NP,D);
    elseif (ismember(func_num, [2,5,9]))
        D=1000;
        Lbound = -5.*ones(NP,D);
        Ubound = 5.*ones(NP,D);
    else 
        D=1000;
        Lbound = -32.*ones(NP,D);
        Ubound = 32.*ones(NP,D);
    end

    VTRs = [];
    bestval = zeros(1,runs);
    
    tStart = tic;
    for runindex = 1:runs
        % trace the fitness
        fprintf(1, 'Function %02d, Run %02d\n', func_num, runindex);
        if ~exist('./trace2013','dir')
            mkdir('./trace2013');
        end
        filename = sprintf('trace2013/tracef%02d_%02d.mat',func_num, runindex);
        
        initial_flag = 0;
        % call the decc algorithm
        gval  =  decc('benchmark_func', func_num, D, Lbound, Ubound, NP,FEs, runindex,problem);
        save(filename, 'gval');
        bestval(runindex) = min(gval);
    end
    optimizationTime = toc(tStart)/runs;
    filename = sprintf('./FCA_G/groupResult/cec2010/F%02d.mat',func_num);
    load(filename);
    sumTime = optimizationTime + groupingTime;
    time.groupingTime = groupingTime;
    time.optimizationTime = optimizationTime;
    time.sumTime = sumTime;
    
    meanval=mean(bestval);
    medianval=median(bestval);
    stdval=std(bestval);
    
    optimizationResultPath = 'optimizationResults/cec2013';
    if ~exist(optimizationResultPath,'dir')
       mkdir(optimizationResultPath);
    end
    filename = sprintf(strcat(optimizationResultPath,'/f%02d.mat'),func_num);
    
    save(filename,'bestval','meanval','medianval','stdval','time');

end

