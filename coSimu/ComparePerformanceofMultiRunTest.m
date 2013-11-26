function [caseNames, values] = ComparePerformanceofMultiRunTest(MultiRunConfig, fileNamebase )

n = length(MultiRunConfig.ConfigValue);
[allM{1:n}] = ndgrid(MultiRunConfig.ConfigValue{:});
allM = cell2mat(cellfun(@(a)a(:),allM,'un',0));

[r, c] = size(allM);

values = [];
caseNames = cell(r, 1);
% load data file
for i = 1 : r   
    caseName = [];
    for j = 1 : c
        value = num2str(allM(i,j));
        idx = strfind(MultiRunConfig.ConfigName{j}, '.');
        substr = MultiRunConfig.ConfigName{j};
        if ~isempty(idx)
            substr = MultiRunConfig.ConfigName{j}(idx(end) + 1 : end);
        end
        caseName = [caseName, substr, '_',strrep(value,'.','-'), '_'];
    end
    caseNames{i} = caseName;
    load([fileNamebase, caseName]);
    eval(['v =', 'ResultData.', MultiRunConfig.ResultCompareName, ';']);
    eval(['values = [values;v];']);
end

figure
plot(values);
title(['comparison of ', MultiRunConfig.ResultCompareName, ' for ' , num2str(r), ' cases']);
ylabel(MultiRunConfig.ResultCompareName);
xlabel('cases NO');
end