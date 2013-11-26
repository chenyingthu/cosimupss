%% multirun Co simulation test with new functions
clear
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
dstFilePath = [pwd, '\debug\falsedata\test1'];


[nCase, caseConfigs ] = MultiRunCoSimu(MultiRunConfig, dstFilePath);
cd(pwdstr);

MultiRunConfig.ResultCompareName = 'performance.all';
caseNames = ComparePerformanceofMultiRunTest(MultiRunConfig, dstFilePath );

MultiRunConfig.ResultCompareName = 'performance.Eq';
caseNames = ComparePerformanceofMultiRunTest(MultiRunConfig, dstFilePath );

%% test 2: 
% 
MultiRunConfig.ConfigName = {'falseDataSchema', 'measErroRatio', 'falseDataAttacks{1}.toBus', 'falseDataAttacks{1}.strategy', 'falseDataAttacks{1}.erroRatio'};
MultiRunConfig.ConfigValue = cell(size(MultiRunConfig.ConfigName));


falseDataSchema = [2];
measErroRatio = [2];
toBus = [2:1:30];
strategy = [1.1, 1.2, 2,3,4,5];
erroRatio = [-0.5, 0.5, 1];
% 
MultiRunConfig.ConfigValue{1} = falseDataSchema;
MultiRunConfig.ConfigValue{2} = measErroRatio;
MultiRunConfig.ConfigValue{3} = toBus;
MultiRunConfig.ConfigValue{4} = strategy;
MultiRunConfig.ConfigValue{5} = erroRatio;


n = length(MultiRunConfig.ConfigValue) ;
[allM{1:n}] = ndgrid(MultiRunConfig.ConfigValue{:});
allM = cell2mat(cellfun(@(a)a(:),allM,'un',0));



dstFilePath = [pwd, '\debug\falsedata\test2']

[r, c] = size(allM);
allConfigs=cell(r,1);
for i = 1 : r
        fileName = dstFilePath;
    for j = 1 : c 
        value = num2str(allM(i,j));
%         disp(['Config.', MultiRunConfig.ConfigName{j}, '=',value,';']);
        eval(['Config.', MultiRunConfig.ConfigName{j}, '=',value,';']);
        idx = strfind(MultiRunConfig.ConfigName{j}, '.');
        substr = MultiRunConfig.ConfigName{j};
        if ~isempty(idx)
            substr = MultiRunConfig.ConfigName{j}(idx(end) + 1 : end);
        end
        
        fileName = [fileName, substr, '_',strrep(value,'.','-'),'_'];
    end
    ResultData = RunCoSimuTest(Config, DSSObj, DSSText);
    Config.resultFileName = fileName;
    save(fileName,'ResultData', 'Config');
    allConfigs{r} = Config;
end
allCfgFileName = [dstFilePath, 'allConfigs', '.mat'];
if exist(allCfgFileName, 'file')
    tmp = allConfigs;
    load([dstFilePath, 'allConfigs']);
    allConfigs = {allConfigs;tmp};
end

save([dstFilePath, 'allConfigs'], 'allConfigs');
cd(pwdstr);
