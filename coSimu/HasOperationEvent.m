function [hasOptEvent, opts ] = HasOperationEvent(Config, ResultData, present_step)
hasOptEvent = 0;
opts = [];

[r, c] = size(ResultData.ctrlQueue);

while c > 1
    
    if (ResultData.ctrlQueue(c).status ~= 2)
        break;
    end
    
    if abs(ResultData.ctrlQueue(c).t - present_step*Config.DSSStepsize) < Config.ctrlTGap
        opts = [opts, ResultData.ctrlQueue(c)];
        hasOptEvent = 1;
    end

    c = c - 1;
end

end
