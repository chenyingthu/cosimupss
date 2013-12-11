%% multirun Co simulation test with new functions
clear

addpath([pwd,'/coSimu']);
addpath([pwd,'./IEEE30_DSS']);
addpath([pwd, './matpower4.1']);
addpath([pwd, './matpower4.1/extras/se']);

% 1. we should define the cross sets of variables used to adjust the config
InitialConfig;

[DSSStartOK, DSSObj, DSSText] = DSSStartup;


if ~DSSStartOK
    a='DSS Did Not Start'
    disp(a)
    return;
end

% MultiRunConfig.ConfigName = {'opfControlPerod', 'limitControlled', 'ctrlAllLatency', 'measAllLatency'};
% MultiRunConfig.ConfigName = {'opfControlPerod', 'limitControlled', 'measLagSchema', 'measAllLatency'};
% MultiRunConfig.ConfigName = {'falseDataSchema'};
MultiRunConfig.ConfigName = {'measErroRatio', 'limitControlled'};
MultiRunConfig.ConfigValue = cell(size(MultiRunConfig.ConfigName));


% controlPeriod = [5, 10, 15];
limitControl = [0, 1];
% ctrlAllLatency = [0, 2, 10, 20, 40, 80, inf];
% controlPeriod = [10];
% limitControl = [1];
% measLagSchema = [2, 3];
% measAllLatency = [20, 40];
% 
% MultiRunConfig.ConfigValue{1} = controlPeriod;
% MultiRunConfig.ConfigValue{2} = limitControl;
% MultiRunConfig.ConfigValue{3} = measLagSchema;
% MultiRunConfig.ConfigValue{4} = measAllLatency;
limitControl = [0];
measErroRatio = [0, 2, 5, 10];
MultiRunConfig.ConfigValue{1} = measErroRatio;
MultiRunConfig.ConfigValue{2} = limitControl;

n = length(MultiRunConfig.ConfigValue) ;
[allM{1:n}] = ndgrid(MultiRunConfig.ConfigValue{:});
allM = cell2mat(cellfun(@(a)a(:),allM,'un',0));


[r, c] = size(allM);

dstFilePath = [pwd, '\debug\ResultData']

for i = 1 : r
    fileName = dstFilePath;
    for j = 1 : c 
        value = sprintf('%d',allM(i,j));
        eval(['Config.', MultiRunConfig.ConfigName{j}, '=',value]);
        fileName = [fileName,MultiRunConfig.ConfigName{j},'_',value,'_'];
    end
    ResultData = RunCoSimuTest(Config, DSSObj, DSSText);
    save(fileName,'ResultData');
end

% controlPeriod = [10];
% limitControl = [1];
% measLagSchema = [2, 3];
% measAllLatency = [20, 40];
% % 
% MultiRunConfig.ConfigValue{1} = controlPeriod;
% MultiRunConfig.ConfigValue{2} = limitControl;
% MultiRunConfig.ConfigValue{3} = measLagSchema;
% MultiRunConfig.ConfigValue{4} = measAllLatency;


MultiRunConfig.ResultCompareName = 'pLossHis';
[Diff,caseNames] = CompareResultofMultiRunTest(Config, MultiRunConfig, 1);

MultiRunConfig.ResultCompareName = 'allQGenHis(2, :)';
[Diff,caseNames] = CompareResultofMultiRunTest(Config, MultiRunConfig, 0);

MultiRunConfig.ResultCompareName = 'allPGenHis(1, :)';
[Diff,caseNames] = CompareResultofMultiRunTest(Config, MultiRunConfig, 0);


MultiRunConfig.ResultCompareName = 'allBusVHis(1, :)';
[Diff,caseNames] = CompareResultofMultiRunTest(Config, MultiRunConfig, 0);

MultiRunConfig.ResultCompareName = 'allBusVHis(12, :)';
[Diff,caseNames] = CompareResultofMultiRunTest(Config, MultiRunConfig, 0);

MultiRunConfig.ResultCompareName = 'pLForCtrlHis(1, :)';
[Diff,caseNames] = CompareResultofMultiRunTest(Config, MultiRunConfig, 0);

MultiRunConfig.ResultCompareName = 'overallPlossKWH';
[Diff,caseNames] = CompareResultofMultiRunTest(Config, MultiRunConfig, 0);
