clear;
clc;

% set random seed
rand('state', sum(100*clock)); 
randn('state', sum(100*clock));
%warning('off' ,'Octave:divide-by-zero');

% problem dimension
D = 1000;

% population size
NP = 100;

% number of independent runs
runs = 25;

% number of fitness evaluations
Max_FEs = 3e6;

% for the benchmark functions initialization
global initial_flag;
problem=2010;
myfunc = 1:20;
addpath('benchmark2010');
addpath('benchmark2010/datafiles');

for func_num = myfunc 
    % load the FEs used in the decomposition process
    decResults = sprintf('./FCA_G/dg2/results/2010/F%02d',func_num);
    load (decResults);
    FEs = Max_FEs - evaluations.count;
    
    % set the dimensionality and upper and lower bounds of the search space
    if(ismember(func_num, [1, 4, 7:9, 12:14, 17:20]))
        XRmin = -100*ones(NP,D); 
        XRmax = 100*ones(NP,D); 
        Lbound = XRmin;
        Ubound = XRmax;
    end
    if(ismember(func_num, [2, 5, 10, 15]))
        XRmin = -5*ones(NP,D); 
        XRmax = 5*ones(NP,D); 
        Lbound = XRmin;
        Ubound = XRmax;
    end
    if(ismember(func_num, [3, 6, 11, 16]))
        XRmin = -32*ones(NP,D); 
        XRmax = 32*ones(NP,D); 
        Lbound = XRmin;
        Ubound = XRmax;
    end

    VTRs = [];
    bestval = zeros(1,runs);
    tStart = tic;
    for runindex = 1:runs
        % trace the fitness
        fprintf(1, 'Function %02d, Run %02d\n', func_num, runindex);
        if ~exist('./trace2010','dir')
            mkdir('./trace2010');
        end
        filename = sprintf('trace2010/tracef%02d_%02d.mat',func_num, runindex);
        
        initial_flag = 0;
        % call the cmaescc algorithm
        gval  = decc('benchmark_func', func_num, D, Lbound, Ubound, NP,FEs, runindex, problem);
        save(filename,'gval');
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
    
    optimizationResultPath = 'optimizationResults/cec2010';
    if ~exist(optimizationResultPath,'dir')
       mkdir(optimizationResultPath);
    end
    filename = sprintf(strcat(optimizationResultPath,'/f%02d.mat'),func_num);
    save(filename,'bestval','meanval','medianval','stdval','time');

end