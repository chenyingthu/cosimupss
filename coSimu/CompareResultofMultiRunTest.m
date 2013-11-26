function [values, caseNames] = CompareResultofMultiRunTest(Config, MultiRunConfig, isTranspose)
% compare the result obtained from multi run test
% 1. open file that produced by the multi run test
n = length(MultiRunConfig.ConfigValue) ;
[allM{1:n}] = ndgrid(MultiRunConfig.ConfigValue{:});
allM = cell2mat(cellfun(@(a)a(:),allM,'un',0));

[r, c] = size(allM);

values = [];
caseNames = cell(r, 1);
% load data file
for i = 1 : r
    fileNamebase =  [Config.basedir, 'debug\ResultData'];
    caseName = [];
    for j = 1 : c
        str = sprintf('%d',allM(i,j));
        caseName = [caseName,MultiRunConfig.ConfigName{j},'_',str,'_'];
    end
    caseNames{i} = caseName;
    load([fileNamebase, caseName]);
    eval(['v =', 'ResultData.', MultiRunConfig.ResultCompareName, ';']);
    if isTranspose
        eval(['values = [values;', 'transpose(v)' ,'];']);
    else
        eval(['values = [values;v];']);
    end
end

[ nPlot, nPoint ]  = size(values);


linestyles = cellstr(char('-',':','-.','--','-',':','-.','--','-',':','-',':',...
'-.','--','-',':','-.','--','-',':','-.'));
 
MarkerEdgeColors=jet(nPlot);  % n is the number of different items you have
Markers=['o','x','+','*','s','d','v','^','<','>','p','h','.',...
'+','*','o','x','^','<','h','.','>','p','s','d','v',...
'o','x','+','*','s','d','v','^','<','>','p','h','.'];

if nPoint > 1
    nStyle = length(linestyles);

    figure;
    hold on;
    for iPlot = 1 : nPlot
        plot(values(iPlot, :), [linestyles{mod(iPlot, nStyle)+1}],'Color',MarkerEdgeColors(nPlot - iPlot + 1,:));
    end
    legend(caseNames);
    grid;
    title([num2str(nPlot), ' cases comparison for ', MultiRunConfig.ResultCompareName]);
    xlabel('time moment = iStep x Config.DSSStepsize');
    ylabel(MultiRunConfig.ResultCompareName);

    hold off;
else
    figure;
    hold on;
    plot(values);
    grid;
    title([num2str(nPlot), ' cases comparison for ', MultiRunConfig.ResultCompareName]);
    xlabel('time moment = iStep x Config.DSSStepsize');
    ylabel(MultiRunConfig.ResultCompareName);

    hold off;
    
end

end