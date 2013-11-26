function [r, rtConfigs] = MultiRunCoSimu(MultiRunConfig, dstFilePath)

warning off all

% 1. we should define the cross sets of variables used to adjust the config
InitialConfig;

if ~exist(dstFilePath, 'dir')
    mkdir(dstFilePath);
end


[DSSStartOK, DSSObj, DSSText] = DSSStartup;


if ~DSSStartOK
    a='DSS Did Not Start'
    disp(a)
    return;
end


n = length(MultiRunConfig.ConfigValue) ;
[allM{1:n}] = ndgrid(MultiRunConfig.ConfigValue{:});
allM = cell2mat(cellfun(@(a)a(:),allM,'un',0));



[r, c] = size(allM);
allConfigs=cell(r,1);

disp(['start multiRunSim for test 1', ' all result will be stored in ' , dstFilePath]);
disp(['total ', num2str(r), ' cases will be simulated']);
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
    disp(['case NO ', num2str(i), ' as file name : ', fileName, ' excuting']);
    ResultData = RunCoSimuTest(Config, DSSObj, DSSText);
    Config.resultFileName = fileName;
    save(fileName,'ResultData', 'Config');
    allConfigs{r} = Config;
end
allCfgFileName = [dstFilePath, 'allConfigs', '.mat'];
rtConfigs = allConfigs;
if exist(allCfgFileName, 'file')
    load([dstFilePath, 'allConfigs']);
    allConfigs = {allConfigs;rtConfigs};
end

save([dstFilePath, 'allConfigs'], 'allConfigs');
disp(['end multiRunSim for test 1 ======================']);

end