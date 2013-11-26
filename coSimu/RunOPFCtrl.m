function [ResultData] = RunOPFCtrl(DSSObj, DSSText, CurrentStatus, Config)

cmdstr = ['Compile (' , Config.basedir , Config.DSSMaster, ')'];
DSSText.command = cmdstr;

Config.measTunnelLatency = Config.measAllLatency * rand(size(Config.measLaggedTunnel));

% Set up the interface variables
DSSCircuit = DSSObj.ActiveCircuit;

%% deal with loadshape
% create daily loadshape for simulation
cmdstr = ['New LoadShape.', Config.loadshape, ' npts=2880 sinterval=30 mult=(File=', Config.loadshape, '.csv'];
DSSText.command = cmdstr;
% set the loadshape for the circuit
DSSText.command = ['batchedit load..*  daily=', Config.loadshape];


DSSSolution = ConfigDSSSolver( DSSText, DSSCircuit, Config);

ResultData = SetupResultDataSet( Config, DSSCircuit, CurrentStatus );

present_step = 1;



while(present_step < Config.num_pts)
    % time line
    ResultData.t = [ResultData.t; present_step];

    DSSSolution.Solve;

    %% obtain all real history records from opendss
    
    ResultData = RecordRealSystemStatus(DSSCircuit,ResultData);
    
    %% check the voltages of all buses to shed/recovery load
    ResultData = LoadShedAndRecovery(Config,ResultData,DSSText);
  

    %% do control according opf result
    if HasControlEvent(Config, present_step) 
        % make measurements for control center to do opf control
        CurrentStatus = SampleAllMeasurements(Config, ResultData, CurrentStatus);      
        [ResultData, isOpfConverged] = ObtainOpfControlCommand( DSSCircuit, DSSText, CurrentStatus, ResultData, Config);
        if (isOpfConverged)
            ResultData = AddCmd2CtrlOperationQueue(DSSCircuit, ResultData, Config);
            ResultData = AddNetLag2CtrlOperationQueue(ResultData, Config);
        end
    end
    
    [hasOptEvent, opts ] = HasOperationEvent(Config, ResultData, present_step);
    
    if hasOptEvent
        ExcuteOpfCtrlOperation(DSSText, opts);
    end

   
    %increment the present step
    present_step = present_step + 1;
end

   %% evaluate the avc performance
ResultData = PerformanceEvaluation(Config, ResultData);
