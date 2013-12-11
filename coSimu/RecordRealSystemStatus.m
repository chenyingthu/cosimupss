function  [ResultData] = RecordRealSystemStatus(DSSCircuit, ResultData)

    % get all load data from dss and mapping them to matpower case
    [ploadMeas, qloadMeas] = ExtractMonitorDataOfPQLoad(DSSCircuit);
    ResultData.allPLoadHis = [ResultData.allPLoadHis, ploadMeas];
    ResultData.allQLoadHis = [ResultData.allQLoadHis, qloadMeas];
    ResultData.sheddedLoadHis = [ResultData.sheddedLoadHis, ones(size(ploadMeas))];

    
    [plineHead, qlineHead, plineTail, qlineTail] = ExtractMonitorDataOfPQLine(DSSCircuit);
    ResultData.allLineHeadPHis = [ResultData.allLineHeadPHis, plineHead];
    ResultData.allLineHeadQHis = [ResultData.allLineHeadQHis, qlineHead];
    ResultData.allLineTailPHis = [ResultData.allLineTailPHis, plineTail];
    ResultData.allLineTailQHis = [ResultData.allLineTailQHis, qlineTail];
    
    [plineHead, qlineHead, plineTail, qlineTail] = ExtractMonitorDataOfPQTransf(DSSCircuit);
    ResultData.allTransfHeadPHis = [ResultData.allTransfHeadPHis, plineHead];
    ResultData.allTransfHeadQHis = [ResultData.allTransfHeadQHis, qlineHead];
    ResultData.allTransfTailPHis = [ResultData.allTransfTailPHis, plineTail];
    ResultData.allTransfTailQHis = [ResultData.allTransfTailQHis, qlineTail];
    
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
    
    
    % recod all p and q flowing on line
    
    
    % p loss & all bus V
    lossesPQ=DSSCircuit.Losses;
    av = DSSCircuit.AllBusVmagPu';
    ResultData.allBusVHis = [ResultData.allBusVHis, av(1:3:end)];   
    ResultData.pLossHis = [ResultData.pLossHis; lossesPQ(1)/1000];
    
    

end
