function [ ResultData, isConverged ] = ObtainOpfControlCommand( DSSCircuit, DSSText, CurrentStatus, ResultData, Config)

%% using latest meas
CurrentStatus.bus(ResultData.allLoadIdx, 3) = CurrentStatus.ploadMeas;
CurrentStatus.bus(ResultData.allLoadIdx, 4) = CurrentStatus.qloadMeas;
CurrentStatus.bus(ResultData.allBusIdx, 8) = CurrentStatus.busVMeasPu;
CurrentStatus.branch(ResultData.allTransfIdx,9) = CurrentStatus.transfTMeas;
CurrentStatus.gen(ResultData.allGenIdx,2) = CurrentStatus.genPMeasKw/1e3;
CurrentStatus.gen(ResultData.allGenIdx,3) = CurrentStatus.genQMeasKva/1e3;


%% limit the controllablity of the gens
if Config.limitControlled == 1
    CurrentStatus.gen(ResultData.allGenIdx,9) = min(CurrentStatus.genPMeasKw*1.1/1e3, CurrentStatus.genControllabilty(ResultData.allGenIdx, 1));
    CurrentStatus.gen(ResultData.allGenIdx,10) = max(CurrentStatus.genPMeasKw*0.8/1e3, CurrentStatus.genControllabilty(ResultData.allGenIdx, 2));
end

%% run opf
optresult = runopf(CurrentStatus, Config.opt);

%% set opf result back to opendss as control set point

if optresult.success == 1
    ResultData.pLForCtrlHis = [ResultData.pLForCtrlHis, CurrentStatus.ploadMeas];
    ResultData.qLForCtrlHis = [ResultData.qLForCtrlHis, CurrentStatus.qloadMeas];
    ResultData.pGenCtrlHis = [ResultData.pGenCtrlHis, optresult.gen(:, 2)*1e3];
    ResultData.qGenCtrlHis = [ResultData.qGenCtrlHis, optresult.gen(:, 3)*1e3];
    ResultData.vGenCtrlHis = [ResultData.vGenCtrlHis, optresult.gen(:, 6)];
    ResultData.tCtrlHis = [ResultData.tCtrlHis, ResultData.t(end)];
else
    disp(['t = ', num2str(ResultData.t(end)),' >>>>>>>>>>>>>>>> opf failed']);
end
isConverged = optresult.success;

end
