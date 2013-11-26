function PlotAllLoadBusVoltage(ResultData)

figure();
hold on

linestyles = cellstr(char('-',':','-.','--','-',':','-.','--','-',':','-',':',...
    '-.','--','-',':','-.','--','-',':','-.'));

MarkerEdgeColors=jet(ResultData.nLoad);  % n is the number of different items you have
Markers=['o','x','+','*','s','d','v','^','<','>','p','h','.',...
    '+','*','o','x','^','<','h','.','>','p','s','d','v',...
    'o','x','+','*','s','d','v','^','<','>','p','h','.'];
nStyle = length(linestyles);
caseNames = cell(ResultData.nLoad, 1);

for i = 1 : ResultData.nLoad
    v = ResultData.allBusVHis(ResultData.allLoadIdx(i), :);
    caseNames{i} = [ 'load ', ResultData.allLoadName{i}, '_V'];
    plot(v, [linestyles{mod(i, nStyle)+1}],'Color',MarkerEdgeColors(ResultData.nLoad - i + 1,:));
end

legend(caseNames);
grid;
title([num2str(ResultData.nLoad), ' load bus voltage comparison']);
xlabel('time moment = iStep x Config.DSSStepsize');
ylabel('voltage(p.u)');

end