function [ResultData] = RunCoSimuTest(Config, DSSObj, DSSText)
InitialCurrentStatus;
ResultData = RunOPFCtrl(DSSObj, DSSText, CurrentStatus, Config);

end