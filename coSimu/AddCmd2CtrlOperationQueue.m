function  [ResultData] = AddCmd2CtrlOperationQueue(DSSCircuit, ResultData, Config)

if isempty(ResultData.pGenCtrlHis)
    disp('no control cmd added to queue');
    return
end

gens = DSSCircuit.Generators;
iGen = gens.First;
latestPCtrl = ResultData.pGenCtrlHis(:, end);
latestQCtrl = ResultData.qGenCtrlHis(:, end);
latestVCtrl = ResultData.vGenCtrlHis(:, end);
while iGen > 0
    genIdx = ResultData.allGenIdx(iGen);
    kwstr = num2str(latestPCtrl(genIdx));
    ctrlOperation.t = ResultData.tCtrlHis(end);
    ctrlOperation.status = 1; % created;
    ctrlOperation.target = gens.Name;
    ctrlOperation.opt = ['Generator.', gens.Name, '.kw=',kwstr];
        
    vpustr = num2str(latestVCtrl(genIdx));
    ctrlOperation.opt = [ctrlOperation.opt, ' vpu=',vpustr];
 
    kvarstr = num2str(latestQCtrl(genIdx));
    ctrlOperation.opt= [ ctrlOperation.opt,' kvar=',kvarstr];
    
    if Config.genSetpointType == 1
        ctrlOperation.opt = [ ctrlOperation.opt, ' model=3'];
    else
        ctrlOperation.opt = [ ctrlOperation.opt, ' model=1'];
    end
    
    ResultData.ctrlQueue = [ResultData.ctrlQueue, ctrlOperation];
    
    iGen = gens.next;
end
ctrlOperation.t = ResultData.tCtrlHis(end);
ctrlOperation.status = 1;
ctrlOperation.target = 'vsource.source';

ctrlOperation.opt = ['vsource.source.pu=',num2str(latestVCtrl(Config.vSrcIdx))];
ResultData.ctrlQueue = [ResultData.ctrlQueue, ctrlOperation];

end

