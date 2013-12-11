%1. to run opendss in matlab;
%2. to simulate the voltage control with only local control strategies
clear ;

addpath([pwd, '/coSimu']);
addpath([pwd, '/IEEE30_DSS']);
addpath([pwd, '/matpower4.1']);
addpath([pwd, '/matpower4.1/extras/se']);
pwdpath = pwd;

InitialConfig;

[DSSStartOK, DSSObj, DSSText] = DSSStartup;

if DSSStartOK
    ResultData = RunCoSimuTest(Config, DSSObj, DSSText);
else
    a='DSS Did Not Start'
    disp(a)   
end



cd(pwdpath);

