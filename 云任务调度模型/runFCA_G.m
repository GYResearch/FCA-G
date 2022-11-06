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

addpath('./benchmark_func2013_large_matlab');
addpath('./Task');

global initial_flag;

% 设置上下界
XRmin = zeros(NP,D); 
XRmax = 100.*ones(NP,D); 
Lbound = XRmin;
Ubound = XRmax;

func_num = 4;

diffGrouping = sprintf('./Task/dg2/results/F%02d', func_num);
load (diffGrouping);
FEs = Max_FEs - evaluations.count;

bestval = zeros(1,runs);

for runindex = 1:runs
    % trace the fitness
    fprintf(1, 'FCA_G, Run %02d\n', runindex);
    optResTracePath = './optimizationResults/FCA_G/trace';
    if ~exist(optResTracePath,'dir')
        mkdir(optResTracePath);
    end
    filename = sprintf(strcat(optResTracePath,'/trace%02d.mat'), runindex);

    initial_flag = 0;
    % call the cmaescc algorithm
%     [gval, one_groups]  = decc('benchmark_func', 4, D, Lbound, Ubound, NP,Max_FEs/NP, 2010);
    gval = decc('benchmark_func', func_num, D, Lbound, Ubound, NP, FEs, runindex);
%     groups{runindex} = one_groups;
    save(filename,'gval');
    bestval(runindex) = min(gval);
end

meanval = mean(bestval);
medianval = median(bestval);
stdval = std(bestval);
optResultName = './optimizationResults/FCA_G/optResult.mat';
save(optResultName,'bestval','meanval','medianval','stdval');
