function  [ResultData] = AddNetLag2CtrlOperationQueue(ResultData, Config)



[r, c] = size(ResultData.ctrlQueue);

while c > 0
    
    if (ResultData.ctrlQueue(c).status ~= 1)
        break;
    end
    
    ResultData.ctrlQueue(c).t = Config.ctrlAllLatency* Config.DSSStepsize  + ResultData.ctrlQueue(c).t * Config.DSSStepsize;
    ResultData.ctrlQueue(c).status = 2; % sent ;
    c = c - 1;
end

end