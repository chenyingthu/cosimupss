function  [ResultData] = RecordRealSystemStatus(DSSCircuit, ResultData)

    % get all load data from dss and mapping them to matpower case
    [ploadMeas, qloadMeas] = ExtractMonitorDataOfPQLoad(DSSCircuit);
    ResultData.allPLoadHis = [ResultData.allPLoadHis, ploadMeas];
    ResultData.allQLoadHis = [ResultData.allQLoadHis, qloadMeas];
    ResultData.sheddedLoadHis = [ResultData.sheddedLoadHis, ones(size(ploadMeas))];

    % record tap changes
    transfers = DSSCircuit.Transformers;
    iTransf = transfers.first;
    transfTMeas = [];
    while iTransf > 0
        transfTMeas = [transfTMeas; transfers.tap];
        iTransf = transfers.next;
    end
    ResultData.allTransfTHis = [ResultData.allTransfTHis, transfTMeas];
    
    % record all p q of gens
    gens = DSSCircuit.Generators;
    genPMeasKw = [];
    genQMeasKva = [];
    iGen = gens.First;
    while iGen > 0                
        genPMeasKw = [genPMeasKw; gens.kw];
        genQMeasKva = [genQMeasKva; gens.kva];
        iGen = gens.next;
    end
    ResultData.allPGenHis = [ResultData.allPGenHis, genPMeasKw];
    ResultData.allQGenHis = [ResultData.allQGenHis, genQMeasKva];
    
    
    % p loss & all bus V
    lossesPQ=DSSCircuit.Losses;
    av = DSSCircuit.AllBusVmagPu';
    ResultData.allBusVHis = [ResultData.allBusVHis, av(1:3:end)];   
    ResultData.pLossHis = [ResultData.pLossHis; lossesPQ(1)/1000];
    
    

end
