clear
cd ..
addpath([pwd,'/coSimu']);
addpath([pwd,'./IEEE30_DSS']);
addpath([pwd, './matpower4.1']);
pwdstr = pwd;


%% test 1 : 
%for the false data schema 1 with different measErroRatio and genSetpointType


MultiRunConfig.ConfigName = {'falseDataSchema', 'measErroRatio', 'genSetpointType'};
MultiRunConfig.ConfigValue = cell(size(MultiRunConfig.ConfigName));


falseDataSchema = [1];
measErroRatio = [2,5];
genSetpointType=[1,2];
% 
MultiRunConfig.ConfigValue{1} = falseDataSchema;
MultiRunConfig.ConfigValue{2} = measErroRatio;
MultiRunConfig.ConfigValue{3} = genSetpointType;
dstFilePath = [pwd, '\debug\falsedata\test1\'];


[nCase, caseConfigs ] = MultiRunCoSimu(MultiRunConfig, dstFilePath);
cd(pwdstr);

MultiRunConfig.ResultCompareName = 'performance.all';
caseNames = ComparePerformanceofMultiRunTest(MultiRunConfig, dstFilePath );

MultiRunConfig.ResultCompareName = 'performance.Eq';
caseNames = ComparePerformanceofMultiRunTest(MultiRunConfig, dstFilePath );