clear
cd ..
addpath([pwd,'/coSimu']);
addpath([pwd,'./IEEE30_DSS']);
addpath([pwd, './matpower4.1']);
pwdstr = pwd;


%% test 1 : 
%for the false data schema 1 with different measErroRatio and genSetpointType


MultiRunConfig.ConfigName = {'falseDataSchema', 'genSetpointType', 'falseDataAttacks{1}.toBus', 'falseDataAttacks{1}.strategy', 'falseDataAttacks{1}.erroRatio'};
MultiRunConfig.ConfigValue = cell(size(MultiRunConfig.ConfigName));


falseDataSchema = [2];
genSetpointType = [1,2];
toBus = [2:1:30];
strategy = [1, 1.1, 1.2, 2,3,4,5];
erroRatio = [-1, -0.5, 0.5, 1];
% 
MultiRunConfig.ConfigValue{1} = falseDataSchema;
MultiRunConfig.ConfigValue{2} = genSetpointType;
MultiRunConfig.ConfigValue{3} = toBus;
MultiRunConfig.ConfigValue{4} = strategy;
MultiRunConfig.ConfigValue{5} = erroRatio;

dstFilePath = [pwd, '\debug\falsedata\test2\'];


% [nCase, caseConfigs ] = MultiRunCoSimu(MultiRunConfig, dstFilePath);
cd(pwdstr);

MultiRunConfig.ResultCompareName = 'performance.all';
[caseNames, values_all] = ComparePerformanceofMultiRunTest(MultiRunConfig, dstFilePath );
[sorted, idx ] = sort(values_all,  'descend');
worstCases4All = caseNames(idx(1:10))

MultiRunConfig.ResultCompareName = 'performance.Eq';
[caseNames, values_Eq] = ComparePerformanceofMultiRunTest(MultiRunConfig, dstFilePath );

MultiRunConfig.ResultCompareName = 'performance.Ee';
[caseNames, values_Ee] = ComparePerformanceofMultiRunTest(MultiRunConfig, dstFilePath );

MultiRunConfig.ResultCompareName = 'performance.Es';
[caseNames, values_Es] = ComparePerformanceofMultiRunTest(MultiRunConfig, dstFilePath );

