function [ ResultData ] = SetupResultDataSet( Config , DSSCircuit , CurrentStatus)

    ResultData.allBusName = DSSCircuit.AllBusNames;
    ResultData.allBusIdx = [];
    for i = 1 : length(ResultData.allBusName)
        busID = str2num(ResultData.allBusName{i}(2:end));
        ResultData.allBusIdx = [ResultData.allBusIdx; find(CurrentStatus.bus(:,1)==busID)];        
    end
    
    
    gens = DSSCircuit.Generators;
    ResultData.nGens = gens.count;
    ResultData.allGenName=cell([ResultData.nGens,1]);
    ResultData.allGenIdx = [];
    iGen = gens.first;
    while iGen > 0
        ResultData.allGenName{iGen} = gens.name;
        genName = str2num(gens.Name(2:end));
        ResultData.allGenIdx = [ResultData.allGenIdx; find(CurrentStatus.gen(:,1)==genName)];        
        iGen = gens.next;
    end

    
    transfers = DSSCircuit.Transformers;
    ResultData.nTransf = transfers.count;
    ResultData.allTransfName=cell([ResultData.nTransf,1]);
    ResultData.allTransfIdx = [];
    ResultData.allTransfHeadBusIdx = [];
    iTransf = transfers.first;
    while iTransf > 0
        ResultData.allTransfName{iTransf} = transfers.name;
        fromBus = str2num(transfers.name(1:find(transfers.name=='-')-1));
        endBus = str2num(transfers.name(find(transfers.name=='-')+1:end));
        ResultData.allTransfIdx = [ResultData.allTransfIdx; find(CurrentStatus.branch(:,1)==fromBus & CurrentStatus.branch(:,2) == endBus)];        
        ResultData.allTransfHeadBusIdx = [ResultData.allTransfHeadBusIdx; find(CurrentStatus.bus(:,1)==fromBus)];
        iTransf = transfers.next;
    end

           
    loads = DSSCircuit.load;
    iLoad = loads.first;
    ResultData.nLoad = loads.count;
    ResultData.allLoadName=cell([ResultData.nLoad,1]);
    ResultData.allLoadID=[];

    ResultData.origPLoad = [];
    loadshape = csvread(['IEEE30_DSS/', Config.loadshape, '.csv']);
    while iLoad > 0
        ResultData.allLoadName{iLoad} = loads.name;
        ResultData.allLoadID = [ResultData.allLoadID; str2num(loads.name(2:end))];
        ResultData.origPLoad = [ResultData.origPLoad; loads.kw*loadshape'];
        iLoad = loads.next;
    end
    ResultData.allLoadIdx = zeros(ResultData.nLoad, 1);
    for i = 1:ResultData.nLoad
        ResultData.allLoadIdx(i) = find(CurrentStatus.bus(:,1)==ResultData.allLoadID(i));
    end
        
    
    
    
    
    ResultData.allTransfTHis = [];
    
    ResultData.allPLoadHis = [];
    ResultData.allQLoadHis = [];
    
    ResultData.allBusVHis = [];
    ResultData.pLossHis = [];
    
    ResultData.pGenCtrlHis = [];
    ResultData.qGenCtrlHis = [];
    ResultData.vGenCtrlHis = [];
    ResultData.tCtrlHis = [];
    
    ResultData.allPGenHis = [];
    ResultData.allQGenHis = [];
    ResultData.allVGenHis = [];
    ResultData.pLForCtrlHis = [];
    ResultData.qLForCtrlHis = [];
    
    ResultData.ctrlQueue = [];
    
    
    ResultData.sheddedLoad = [];
    ResultData.sheddedLoadHis = [];
    
    ResultData.t = [];
    
    ResultData.performance.EeBase = 1.0562e+005;
end
