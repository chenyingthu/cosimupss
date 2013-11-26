function ResultData = LoadShedAndRecovery(Config, ResultData, DSSText)
%% This function is used to detect the low or high voltage of buese, which
%% should cause the load connected be shedded

nSample = length(ResultData.t);
busAvgV = ResultData.allBusVHis(:, end);
if (nSample >  Config.vRecoverSample)
    busAvgV = sum(ResultData.allBusVHis(:, [nSample - Config.vRecoverSample : nSample]), 2)/ (Config.vRecoverSample + 1);   
end

targetBusIdx = find(busAvgV < Config.vLow4LoadShed | busAvgV > Config.vHigh4LoadShed);
if ~isempty(targetBusIdx)
    % som load sheding required
    for i = 1 : length(targetBusIdx)
        iBus = targetBusIdx(i);
        iLoad = find(ResultData.allLoadIdx == ResultData.allBusIdx(iBus)); 
        if isempty(iLoad)
            continue;
        end
        if isempty(ResultData.sheddedLoad) | isempty(find(ResultData.sheddedLoad == iLoad))
            ResultData.sheddedLoad = [ResultData.sheddedLoad; iLoad];
            disp(['load shed requred for load', int2str(iLoad), ' for the moment t as ', int2str(nSample)]);
        end
    end
end

% recover the load with voltage above the recovery limit
recoverLoad = [];

if ~isempty(ResultData.sheddedLoad)
    for j = 1 : length(ResultData.sheddedLoad)
        iLoad = ResultData.sheddedLoad(j);
        iBus = find(ResultData.allBusIdx == ResultData.allLoadIdx(iLoad));
        iBusAvgV = busAvgV(iBus);
        if (iBusAvgV > Config.vLow4LoadBack & iBusAvgV < Config.vHigh4LoadBack)
            recoverLoad = [recoverLoad, j];
            disp(['load recover requred for load', int2str(ResultData.sheddedLoad(j)), ' for the moment t as ', int2str(nSample)]);
            cmdStr = ['Load.', ResultData.allLoadName{iLoad}, '.enabled=Yes'];
            DSSText.Command = cmdStr;
            continue;
        end
        cmdStr = ['Load.', ResultData.allLoadName{iLoad}, '.enabled=No'];
        DSSText.Command = cmdStr; 
        ResultData.sheddedLoadHis(iLoad, end) = 0;
    end
    ResultData.sheddedLoad(recoverLoad) = [];

end

end