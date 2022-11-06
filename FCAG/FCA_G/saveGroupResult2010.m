groupResultPath = './groupResult/cec2010';
if(~exist(groupResultPath,'dir'))
    mkdir(groupResultPath);
end

for func = 1:20
    filename = sprintf('./dg2/results/2010/F%02d.mat',func);
    load(filename);
    tStart = tic;
    [group, nonseps, seps, time] = test_grouping(2010,func);
    groupingTime = toc(tStart) + time + groupingTime;
    filename = sprintf(strcat(groupResultPath,'/F%02d.mat'),func);
    save(filename,'group','nonseps','seps','groupingTime');
end