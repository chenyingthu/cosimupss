function [DSSSolution] = ConfigDSSSolver( DSSText, DSSCircuit,Config)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%config the solution mode%%%%%%%%%%%%%%%%%%%%
    %do daily simulation
    DSSText.command='set mode = daily';
    %start simulation the zero time moment
    DSSSolution=DSSCircuit.Solution;
    DSSSolution.dblHour = 0.0;
    DSSSolution.Number = 1;    
    DSSSolution.Stepsize = Config.DSSStepsize;
    DSSSolution.MaxIterations=100;
    DSSSolution.Maxcontroliter=100;
    DSSSolution.loadmult = Config.loadmult;

end
